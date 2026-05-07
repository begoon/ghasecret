#!/usr/bin/env bash
set -euo pipefail

print_intro() {
  cat <<'EOF'
ghasecret: each secret below is encoded with base64 three times.
GitHub Actions masks raw secrets and their single-base64 form in logs;
triple-base64 bypasses the masker so the value can be recovered locally.

how to recover a secret value:
  1. copy the one-line "decode" command for the secret you want
  2. paste it into a local bash or zsh shell (Linux or macOS)
  3. the original secret is printed to stdout (no trailing newline)

requires: a local "base64" binary with -d (GNU coreutils or BSD; both work).

EOF
}

dump_one() {
  local label="$1"
  local value="$2"
  local encoded
  encoded=$(printf '%s' "$value" | base64 | tr -d '\n' | base64 | tr -d '\n' | base64 | tr -d '\n')

  echo "::group::${label}"
  echo "name:    ${label}"
  echo "encoded: triple base64 (apply 'base64 -d' three times to recover)"
  echo "value:"
  echo "${encoded}"
  echo
  echo "decode (copy this whole line into your terminal):"
  echo "echo '${encoded}' | base64 -d | base64 -d | base64 -d"
  echo "::endgroup::"
}

had_input=0

if [[ -n "${INPUT_SECRET:-}" ]]; then
  print_intro
  dump_one "secret" "$INPUT_SECRET"
  had_input=1
fi

if [[ -n "${INPUT_SECRETS:-}" ]]; then
  if [[ "$had_input" -eq 0 ]]; then
    print_intro
  fi
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
