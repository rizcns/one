#!/usr/bin/env bash
set -euo pipefail

echo "==> CI install"

if [[ ! -f package.json ]]; then
  echo "No package.json found; nothing to install."
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

if [[ "${node_uses_pnpm}" == "true" ]]; then
  echo "==> Installing Node dependencies with pnpm"
  if command -v corepack >/dev/null 2>&1; then
    corepack enable
  fi
  if ! command -v pnpm >/dev/null 2>&1; then
    echo "pnpm is required but was not found on PATH." >&2
    exit 1
  fi
  pnpm install --frozen-lockfile
  exit 0
fi

echo "==> Installing Node dependencies with npm"
if [[ -f package-lock.json || -f npm-shrinkwrap.json ]]; then
  npm ci
else
  echo "npm ci requires a lockfile (package-lock.json or npm-shrinkwrap.json) but none was found." >&2
  exit 1
fi
