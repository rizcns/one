#!/usr/bin/env bash
set -euo pipefail

echo "==> CMake build/test"

if [[ ! -f CMakeLists.txt ]]; then
  echo "No CMakeLists.txt found; skipping."
  exit 0
fi

echo "==> Configure"
cmake -S . -B build -DCMAKE_BUILD_TYPE=Release

echo "==> Build"
cmake --build build --config Release

if [[ -f build/CTestTestfile.cmake ]]; then
  echo "==> Test"
  ctest --test-dir build -C Release --output-on-failure
else
  echo "No CTestTestfile.cmake found; skipping ctest."
fi

echo "==> Package build dir into out/"
mkdir -p out
tar -czf out/cmake-build.tar.gz -C build .
ls -la out

