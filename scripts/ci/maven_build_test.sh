#!/usr/bin/env bash
set -euo pipefail

echo "==> Maven build/test"

if [[ ! -f mvnw && ! -f pom.xml ]]; then
  echo "No Maven files found; skipping."
  exit 0
fi

mvn_cmd=""
if [[ -f mvnw ]]; then
  chmod +x mvnw || true
  mvn_cmd="./mvnw"
elif command -v mvn >/dev/null 2>&1; then
  mvn_cmd="mvn"
else
  echo "Maven not found (no mvnw and no mvn on PATH)." >&2
  exit 1
fi

echo "==> Run tests and package"
"${mvn_cmd}" -B test package

mkdir -p out

echo "==> Collect Maven artifacts into out/"
count=0
while IFS= read -r -d '' f; do
  cp -v "${f}" "out/$(basename "${f}")"
  count=$((count + 1))
done < <(find . -type f -path '*/target/*' \( -name '*.jar' -o -name '*.war' -o -name '*.ear' -o -name '*.zip' -o -name '*.tar.gz' \) -print0 || true)

if (( count == 0 )); then
  target_dirs=()
  while IFS= read -r -d '' d; do
    target_dirs+=("${d}")
  done < <(find . -type d -name target -print0 || true)

  if (( ${#target_dirs[@]} > 0 )); then
    tar -czf out/maven-targets.tar.gz "${target_dirs[@]}"
  else
    echo "No Maven target/ outputs found after build." > out/NO_MAVEN_OUTPUTS.txt
  fi
fi

ls -la out

