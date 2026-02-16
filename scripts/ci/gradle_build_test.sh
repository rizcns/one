#!/usr/bin/env bash
set -euo pipefail

echo "==> Gradle build/test"

if [[ ! -f gradlew && ! -f build.gradle && ! -f build.gradle.kts ]]; then
  echo "No Gradle files found; skipping."
  exit 0
fi

gradle_cmd=""
if [[ -f gradlew ]]; then
  chmod +x gradlew || true
  gradle_cmd="./gradlew"
elif command -v gradle >/dev/null 2>&1; then
  gradle_cmd="gradle"
else
  echo "Gradle not found (no gradlew and no gradle on PATH)." >&2
  exit 1
fi

echo "==> Run tests and assemble"
"${gradle_cmd}" --no-daemon test assemble

mkdir -p out

echo "==> Collect build outputs into out/"
build_dirs=()
while IFS= read -r -d '' d; do
  build_dirs+=("${d}")
done < <(find . -type d -name build -print0 || true)

if (( ${#build_dirs[@]} > 0 )); then
  tar -czf out/gradle-build.tar.gz "${build_dirs[@]}"
else
  echo "No Gradle build/ directories found after build." > out/NO_GRADLE_BUILD_DIRS.txt
fi

ls -la out

