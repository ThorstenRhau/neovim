#!/usr/bin/env bash
# Offline Neovim startup smoke test for macOS.
#
# It preflights locally installed locked dependencies, copies the configuration
# and runtime data into disposable XDG directories, then starts Neovim under
# sandbox-exec with network access denied. The test fails after 45 seconds or
# unless scripts/smoke.lua reports success. It never downloads or repairs
# dependencies; run it with `make smoke`.
set -euo pipefail

command -v sandbox-exec >/dev/null || { echo 'smoke requires macOS sandbox-exec to enforce offline execution.' >&2; exit 1; }
export NVIM_SMOKE_SOURCE
NVIM_SMOKE_SOURCE=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)
export NVIM_SMOKE_DATA="${XDG_DATA_HOME:-$HOME/.local/share}/nvim"
unset NVIM_APPNAME NVIM NVIM_LISTEN_ADDRESS TOKEN_DEV VIMINIT EXINIT

# Preflight runs without the user's init or vim.pack, before copying or loading anything.
nvim --clean -l "$NVIM_SMOKE_SOURCE/scripts/smoke.lua" preflight

smoke_tmp=$(mktemp -d "${TMPDIR:-/tmp}/nvim-smoke.XXXXXX")
smoke_pid=''
watchdog_pid=''
cleanup() {
  [[ -z "$watchdog_pid" ]] || kill "$watchdog_pid" 2>/dev/null || true
  [[ -z "$smoke_pid" ]] || kill "$smoke_pid" 2>/dev/null || true
  rm -rf -- "$smoke_tmp"
}
trap cleanup EXIT
trap 'exit 130' INT TERM
export XDG_CONFIG_HOME="$smoke_tmp/config" XDG_DATA_HOME="$smoke_tmp/data"
export XDG_STATE_HOME="$smoke_tmp/state" XDG_CACHE_HOME="$smoke_tmp/cache"
export XDG_RUNTIME_DIR="$smoke_tmp/runtime"
export XDG_CONFIG_DIRS="$smoke_tmp/empty" XDG_DATA_DIRS="$smoke_tmp/empty"
mkdir -p "$XDG_CONFIG_HOME/nvim" "$XDG_DATA_HOME/nvim" "$XDG_STATE_HOME" "$XDG_CACHE_HOME" "$XDG_RUNTIME_DIR" "$smoke_tmp/work"
chmod 700 "$XDG_RUNTIME_DIR"
cp -RL "$NVIM_SMOKE_SOURCE/"{init.lua,lua,after,scripts,.editorconfig,nvim-pack-lock.json} "$XDG_CONFIG_HOME/nvim/"
cp -RL "$NVIM_SMOKE_DATA/site" "$XDG_DATA_HOME/nvim/site"
cd -- "$smoke_tmp/work"

# This applies to Neovim and all subprocesses, including absolute-path download tools.
sandbox-exec -p '(version 1)(allow default)(deny network*)(allow network* (local unix-socket) (remote unix-socket))' \
  nvim --headless -i NONE -u "$XDG_CONFIG_HOME/nvim/init.lua" \
  --cmd 'lua dofile(vim.env.XDG_CONFIG_HOME .. "/nvim/scripts/smoke.lua").guard()' \
  -c 'lua dofile(vim.env.XDG_CONFIG_HOME .. "/nvim/scripts/smoke.lua").check()' \
  >"$smoke_tmp/output" 2>&1 &
smoke_pid=$!
(sleep 45; kill -TERM "$smoke_pid" 2>/dev/null; sleep 2; kill -KILL "$smoke_pid" 2>/dev/null) &
watchdog_pid=$!
result=0
wait "$smoke_pid" || result=$?
smoke_pid=''
cat "$smoke_tmp/output"
if [[ "$result" != 0 ]] || ! rg -q '^smoke: passed' "$smoke_tmp/output"; then
  echo 'smoke failed (startup, assertion, or 45-second timeout).' >&2
  exit 1
fi
