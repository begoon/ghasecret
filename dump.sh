#!/usr/bin/env bash
set -euo pipefail

dump_one() {
  local label="$1"
  local value="$2"
  local encoded
  encoded=$(printf '%s' "$value" | base64 | tr -d '\n' | base64 | tr -d '\n' | base64 | tr -d '\n')

  echo "::group::${label}"
  echo "value:  ${encoded}"
  echo "decode: echo '${encoded}' | base64 -d | base64 -d | base64 -d"
  echo "::endgroup::"
}

had_input=0

if [[ -n "${INPUT_SECRET:-}" ]]; then
  dump_one "secret" "$INPUT_SECRET"
  had_input=1
fi

if [[ -n "${INPUT_SECRETS:-}" ]]; then
  while IFS= read -r line; do
    [[ -z "$line" ]] && continue
    if [[ "$line" != *=* ]]; then
      echo "ghasecret: line is not in NAME=VALUE format: '${line}'" >&2
      exit 1
    fi
    label="${line%%=*}"
    value="${line#*=}"
    dump_one "$label" "$value"
    had_input=1
  done <<< "$INPUT_SECRETS"
fi

if [[ "$had_input" -eq 0 ]]; then
  echo "ghasecret: neither 'secret' nor 'secrets' input was provided" >&2
  exit 1
fi
