#!/usr/bin/env bash
set -euo pipefail

echo "==> CI package"

mkdir -p out

# Ensure there is something to package.
if [[ ! -d dist && ! -d build ]]; then
  echo "No dist/ or build/ directory found; attempting to create dist/."
  bash scripts/ci/build.sh || true
fi

src=""
if [[ -d dist ]]; then
  src="dist"
elif [[ -d build ]]; then
  src="build"
else
  echo "No dist/ or build/ directory found; creating placeholder archive."
fi

suffix=""
if [[ -n "${GITHUB_REF_NAME:-}" ]]; then
  suffix="-${GITHUB_REF_NAME}"
fi

archive="out/node-dist${suffix}.tar.gz"

if [[ -n "${src}" ]]; then
  echo "==> Creating ${archive} from ${src}/"
  tar -czf "${archive}" -C "${src}" .
else
  echo "No build output available." > out/NO_BUILD_OUTPUT.txt
  tar -czf "${archive}" -C out NO_BUILD_OUTPUT.txt
fi

echo "==> out/ contents"
ls -la out

