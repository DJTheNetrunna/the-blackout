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
  : "${MOD_PROFILE:=server}"
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
base_sandbox_cfg() { printf '%s\n' "$REPO_ROOT/config/sandbox/base.cfg"; }
profile_sandbox_cfg() { printf '%s/config/profiles/%s.cfg\n' "$REPO_ROOT" "$1"; }
active_server_ini() { printf '%s/Server/%s.ini\n' "$PZ_CACHE_DIR" "$SERVER_NAME"; }
active_sandbox_lua() { printf '%s/Server/%s_SandboxVars.lua\n' "$PZ_CACHE_DIR" "$SERVER_NAME"; }

target_from_profile() {
  case "$1" in
    solo|solo-lab|blind|blind-lab) printf 'solo\n' ;;
    coop|coop-lab) printf 'coop\n' ;;
    server|server-lab|core|recommended|horror-lab) printf 'server\n' ;;
    vanilla) printf 'vanilla\n' ;;
    *) die "Unknown profile: $1 (expected blind|solo|coop|server or a *-lab/legacy alias)" ;;
  esac
}

selected_manifest_rows() {
  local profile="$1" target col allow_candidate=0
  target="$(target_from_profile "$profile")"
  [[ "$target" != "vanilla" ]] || return 0

  case "$target" in
    solo) col=6 ;;
    coop) col=7 ;;
    server) col=8 ;;
    *) die "Unsupported target: $target" ;;
  esac

  case "$profile" in
    *-lab) allow_candidate=1 ;;
  esac

  awk -F '\t' -v col="$col" -v allow_candidate="$allow_candidate" '
    NR > 1 {
      status = $col
      if (status == "approved" || (allow_candidate == 1 && status == "candidate")) print
    }
  ' "$(manifest_file)" | sort -t $'\t' -k9,9n
}
