#!/usr/bin/env bash

# adjusted from source: https://shendriks.dev/posts/2024-04-19-using-hugo-with-mermaid-wo-javascript/

set -euo pipefail

while IFS= read -r -d '' file
do
  DIR=$(dirname "$file")
  mmdc ${MMDC_EXTRA_OPTIONS:-} -i "${DIR}"/index.md -o "${DIR}"/mermaid-out.svg

  # Fix numbering of output files considering all code blocks found in the .md file
  readarray -t number_map < <(grep -E '^```([a-zA-Z0-9]+)' "${DIR}"/index.md | nl -w1 | grep mermaid | awk '{print $1}' | nl -w1 -s:)
  for value in "${number_map[@]}"
  do
    readarray -t numbers < <(echo "$value" | tr ":" "\n")
    if [[ "${numbers[0]}" != "${numbers[1]}" ]]; then
      mv -v "${DIR}"/mermaid-out-"${numbers[0]}".svg "${DIR}"/mermaid-out-"${numbers[1]}".svg
    fi
  done
done<   <(find content/ -name index.md -print0)
