#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib/common.sh
source "$SCRIPT_DIR/lib/common.sh"
# shellcheck source=lib/local.sh
source "$SCRIPT_DIR/lib/local.sh"
load_env

target="${1:-solo}"
case "$target" in
  solo|coop) ;;
  *) die "Usage: $0 <solo|coop>" ;;
esac

detect_local_paths || die "Project Zomboid Steam library not detected. Run scripts/detect-local.sh or set PZ_STEAMAPPS_DIR."
[[ -d "$PZ_GAME_DIR" || -f "$PZ_STEAMAPPS_DIR/appmanifest_108600.acf" ]] || die "Project Zomboid installation not found in detected Steam library"

if [[ "${KNOX_SKIP_SAVE_BACKUP:-0}" != "1" ]]; then
  "$SCRIPT_DIR/backup-local-saves.sh"
else
  warn "Local save backup skipped because KNOX_SKIP_SAVE_BACKUP=1"
fi

"$SCRIPT_DIR/configure-knox.sh" "$target"
generated="$REPO_ROOT/.generated/$target"
preset_name="Knox Nightmare - ${target^^}.cfg"
preset_dir="$PZ_DATA_DIR/Sandbox Presets"
mkdir -p "$preset_dir" "$PZ_DATA_DIR/KnoxNightmare/$target"

preset_src="$generated/$preset_name"
preset_dst="$preset_dir/$preset_name"
if [[ -f "$preset_dst" ]] && ! cmp -s "$preset_src" "$preset_dst"; then
  stamp="$(date -u +%Y%m%d-%H%M%S)"
  mkdir -p "$KNOX_ROOT/local-backups/presets"
  cp -p "$preset_dst" "$KNOX_ROOT/local-backups/presets/$preset_name.$stamp.bak"
fi
cp "$preset_src" "$preset_dst"
cp "$generated/WORKSHOP_IDS.txt" "$generated/MOD_IDS.txt" "$generated/WORKSHOP_URLS.txt" "$PZ_DATA_DIR/KnoxNightmare/$target/"

if [[ "$target" == "coop" ]]; then
  server_dir="$PZ_DATA_DIR/Server"
  mkdir -p "$server_dir"
  ini_src="$generated/KnoxNightmare-Coop.ini"
  ini_dst="$server_dir/KnoxNightmare-Coop.ini"
  lua_dst="$server_dir/KnoxNightmare-Coop_SandboxVars.lua"
  for pair in "$ini_src:$ini_dst" "$generated/KnoxNightmare_SandboxVars.lua:$lua_dst"; do
    src="${pair%%:*}"
    dst="${pair#*:}"
    if [[ -f "$dst" ]] && ! cmp -s "$src" "$dst"; then
      stamp="$(date -u +%Y%m%d-%H%M%S)"
      mkdir -p "$KNOX_ROOT/local-backups/server-config"
      cp -p "$dst" "$KNOX_ROOT/local-backups/server-config/$(basename -- "$dst").$stamp.bak"
    fi
    cp "$src" "$dst"
  done
fi

missing="$PZ_DATA_DIR/KnoxNightmare/$target/MISSING_WORKSHOP_URLS.txt"
: > "$missing"
while IFS= read -r wid; do
  [[ -n "$wid" ]] || continue
  if [[ ! -d "$PZ_WORKSHOP_DIR/$wid" ]]; then
    printf 'https://steamcommunity.com/sharedfiles/filedetails/?id=%s\n' "$wid" >> "$missing"
  fi
done < "$generated/WORKSHOP_IDS.txt"

if [[ -s "$missing" ]]; then
  warn "Some Workshop items are not installed in the detected Steam library. Subscribe through Steam, then relaunch Steam/PZ."
  cat "$missing"
else
  rm -f "$missing"
  log "All selected Workshop item directories are present."
fi

log "Installed $preset_name into $preset_dir"
[[ "$target" == "coop" ]] && log "Installed hosted CO-OP files under $PZ_DATA_DIR/Server without touching other server profiles."
log "No existing save was modified. Create a NEW Knox Nightmare world from the game menu."
