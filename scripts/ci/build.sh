#!/usr/bin/env bash
set -euo pipefail

echo "==> CI build"

if [[ ! -f package.json ]]; then
  echo "No package.json found; nothing to build."
  exit 0
fi

node_uses_pnpm=false
if [[ -f pnpm-lock.yaml ]]; then
  node_uses_pnpm=true
else
  node_uses_pnpm="$(python3 - <<'PY'
import json
try:
    with open("package.json", "r", encoding="utf-8") as f:
        pkg = json.load(f)
    pm = (pkg.get("packageManager") or "")
    print("true" if pm.startswith("pnpm@") else "false")
except Exception:
    print("false")
PY
  )"
fi

runner="npm"
if [[ "${node_uses_pnpm}" == "true" ]]; then
  runner="pnpm"
  if command -v corepack >/dev/null 2>&1; then
    corepack enable
  fi
  if ! command -v pnpm >/dev/null 2>&1; then
    echo "pnpm is required but was not found on PATH." >&2
    exit 1
  fi
fi

script_to_run="$(python3 - <<'PY'
import json
try:
    with open("package.json", "r", encoding="utf-8") as f:
        pkg = json.load(f)
    scripts = pkg.get("scripts") or {}
except Exception:
    scripts = {}

for name in ("build", "compile"):
    if name in scripts and scripts.get(name):
        print(name)
        raise SystemExit(0)
print("")
PY
)"

if [[ -n "${script_to_run}" ]]; then
  echo "==> Running ${runner} run ${script_to_run}"
  "${runner}" run "${script_to_run}"
else
  echo "No build scripts found (build, compile); skipping build command."
fi

if [[ -d dist ]]; then
  echo "dist/ already exists."
  exit 0
fi

echo "==> Standardizing build output into dist/"
if [[ -d build ]]; then
  cp -a build dist
elif [[ -d out ]]; then
  cp -a out dist
else
  mkdir -p dist
  # Last-resort: snapshot sources (excluding VCS/CI/deps) so CI artifacts are never empty.
  tar \
    --exclude='./.git' \
    --exclude='./.github' \
    --exclude='./node_modules' \
    --exclude='./dist' \
    --exclude='./out' \
    --exclude='./build' \
    --exclude='./scripts/ci' \
    -cf - . | tar -xf - -C dist
fi

echo "==> dist/ summary"
find dist -maxdepth 2 -type f | head -n 200 || true
