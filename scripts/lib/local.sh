#!/usr/bin/env bash
set -euo pipefail

add_steamapps_candidate() {
  local candidate="$1" item
  [[ -n "$candidate" ]] || return 0
  for item in "${STEAMAPPS_CANDIDATES[@]:-}"; do
    [[ "$item" == "$candidate" ]] && return 0
  done
  STEAMAPPS_CANDIDATES+=("$candidate")
}

detect_local_paths() {
  STEAMAPPS_CANDIDATES=()

  if [[ -n "${PZ_STEAMAPPS_DIR:-}" ]]; then
    add_steamapps_candidate "$PZ_STEAMAPPS_DIR"
  fi

  add_steamapps_candidate "$HOME/.local/share/Steam/steamapps"
  add_steamapps_candidate "$HOME/.steam/steam/steamapps"
  add_steamapps_candidate "$HOME/.var/app/com.valvesoftware.Steam/.local/share/Steam/steamapps"

  local root vdf libpath
  for root in "$HOME/.local/share/Steam" "$HOME/.steam/steam" "$HOME/.var/app/com.valvesoftware.Steam/.local/share/Steam"; do
    vdf="$root/steamapps/libraryfolders.vdf"
    [[ -f "$vdf" ]] || continue
    while IFS= read -r libpath; do
      [[ -n "$libpath" ]] || continue
      libpath="${libpath//\\\\/\\}"
      add_steamapps_candidate "$libpath/steamapps"
    done < <(sed -nE 's/^[[:space:]]*"path"[[:space:]]+"([^"]+)".*/\1/p' "$vdf")
  done

  local steamapps=""
  for root in "${STEAMAPPS_CANDIDATES[@]}"; do
    if [[ -f "$root/appmanifest_108600.acf" || -d "$root/common/ProjectZomboid" ]]; then
      steamapps="$root"
      break
    fi
  done

  if [[ -z "$steamapps" && -n "${PZ_GAME_DIR:-}" ]]; then
    steamapps="$(cd -- "$PZ_GAME_DIR/../.." 2>/dev/null && pwd || true)"
  fi

  [[ -n "$steamapps" ]] || return 1

  PZ_STEAMAPPS_DIR="$steamapps"
  : "${PZ_GAME_DIR:=$steamapps/common/ProjectZomboid}"
  : "${PZ_WORKSHOP_DIR:=$steamapps/workshop/content/108600}"
  : "${PZ_DATA_DIR:=$HOME/Zomboid}"

  export PZ_STEAMAPPS_DIR PZ_GAME_DIR PZ_WORKSHOP_DIR PZ_DATA_DIR
}
