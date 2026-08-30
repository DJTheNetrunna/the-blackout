#!/usr/bin/env bash
set -euo pipefail

COMMON_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd -- "$COMMON_DIR/../.." && pwd)"

load_env() {
  local env_file="${KNOX_ENV:-$REPO_ROOT/.env}"
  if [[ -f "$env_file" ]]; then
    # shellcheck disable=SC1090
    source "$env_file"
  fi

  : "${KNOX_ROOT:=$HOME/knox-nightmare}"
  : "${PZ_SERVER_DIR:=$KNOX_ROOT/server}"
  : "${PZ_CACHE_DIR:=$KNOX_ROOT/Zomboid}"
  : "${STEAMCMD_DIR:=$KNOX_ROOT/steamcmd}"
  : "${BACKUP_DIR:=$KNOX_ROOT/backups}"
  : "${SERVER_NAME:=KnoxNightmare}"
  : "${MOD_PROFILE:=core}"
  : "${PREFETCH_WORKSHOP:=0}"

  export KNOX_ROOT PZ_SERVER_DIR PZ_CACHE_DIR STEAMCMD_DIR BACKUP_DIR SERVER_NAME MOD_PROFILE PREFETCH_WORKSHOP
}

log() { printf '[knox-nightmare] %s\n' "$*"; }
warn() { printf '[knox-nightmare] WARNING: %s\n' "$*" >&2; }
die() { printf '[knox-nightmare] ERROR: %s\n' "$*" >&2; exit 1; }

require_cmd() {
  command -v "$1" >/dev/null 2>&1 || die "Required command not found: $1"
}

steamcmd_bin() {
  if [[ -x "$STEAMCMD_DIR/steamcmd.sh" ]]; then
    printf '%s\n' "$STEAMCMD_DIR/steamcmd.sh"
  elif command -v steamcmd >/dev/null 2>&1; then
    command -v steamcmd
  else
    return 1
  fi
}

manifest_file() { printf '%s\n' "$REPO_ROOT/mods/manifest.tsv"; }
server_template() { printf '%s\n' "$REPO_ROOT/config/server/KnoxNightmare.ini"; }
sandbox_template() { printf '%s\n' "$REPO_ROOT/config/sandbox/KnoxNightmare_SandboxVars.lua"; }
active_server_ini() { printf '%s/Server/%s.ini\n' "$PZ_CACHE_DIR" "$SERVER_NAME"; }
active_sandbox_lua() { printf '%s/Server/%s_SandboxVars.lua\n' "$PZ_CACHE_DIR" "$SERVER_NAME"; }

profile_filter_awk() {
  local profile="$1"
  case "$profile" in
    vanilla) printf '%s\n' 'NR==0' ;;
    core) printf '%s\n' '$5=="approved" && $4=="core"' ;;
    recommended) printf '%s\n' '$5=="approved" && ($4=="core" || $4=="utility")' ;;
    horror-lab) printf '%s\n' '($5=="approved" || $5=="candidate") && ($4=="core" || $4=="utility" || $4=="horror" || $4=="visual")' ;;
    *) die "Unknown mod profile: $profile (expected vanilla|core|recommended|horror-lab)" ;;
  esac
}

selected_manifest_rows() {
  local profile="$1" filter
  filter="$(profile_filter_awk "$profile")"
  awk -F '\t' "NR>1 && ($filter)" "$(manifest_file)"
}
