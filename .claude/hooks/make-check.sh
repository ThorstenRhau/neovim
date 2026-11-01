#!/usr/bin/env bash
# PostToolUse hook for Edit and Write: run `make check` after a Lua file
# changes and show Claude the output when it fails.

set -uo pipefail

file=$(jq -r '.tool_input.file_path // empty')
[[ $file == *.lua ]] || exit 0

if ! output=$(cd "$CLAUDE_PROJECT_DIR" && make -s check 2>&1); then
  printf 'make check failed after editing %s:\n%s\n' "$file" "$output" >&2
  exit 2
fi
