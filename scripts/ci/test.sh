#!/usr/bin/env bash
set -euo pipefail

echo "==> CI test"

if [[ ! -f package.json ]]; then
  echo "No package.json found; skipping Node tests."
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

for name in ("test", "test:ci", "test:coverage"):
    if name in scripts and scripts.get(name):
        print(name)
        raise SystemExit(0)
print("")
PY
)"

if [[ -z "${script_to_run}" ]]; then
  echo "No test scripts found (test, test:ci, test:coverage); skipping."
  exit 0
fi

echo "==> Running ${runner} run ${script_to_run}"
"${runner}" run "${script_to_run}"
