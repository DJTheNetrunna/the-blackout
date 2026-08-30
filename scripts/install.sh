#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib/common.sh
source "$SCRIPT_DIR/lib/common.sh"
load_env

mkdir -p "$KNOX_ROOT" "$PZ_SERVER_DIR" "$PZ_CACHE_DIR/Server" "$STEAMCMD_DIR" "$BACKUP_DIR"

if ! steamcmd="$(steamcmd_bin 2>/dev/null)"; then
  require_cmd tar
  if command -v curl >/dev/null 2>&1; then
    downloader=(curl -fsSL -o "$STEAMCMD_DIR/steamcmd_linux.tar.gz")
  elif command -v wget >/dev/null 2>&1; then
    downloader=(wget -qO "$STEAMCMD_DIR/steamcmd_linux.tar.gz")
  else
    die "Need curl or wget to download SteamCMD"
  fi

  log "Downloading Valve SteamCMD"
  "${downloader[@]}" "https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz"
  tar -xzf "$STEAMCMD_DIR/steamcmd_linux.tar.gz" -C "$STEAMCMD_DIR"
  rm -f "$STEAMCMD_DIR/steamcmd_linux.tar.gz"
  steamcmd="$STEAMCMD_DIR/steamcmd.sh"
fi

log "Installing/updating Project Zomboid Dedicated Server (App 380870)"
"$steamcmd" +force_install_dir "$PZ_SERVER_DIR" +login anonymous +app_update 380870 validate +quit

"$SCRIPT_DIR/generate-config.sh" "$MOD_PROFILE"
"$SCRIPT_DIR/validate-mods.sh"

log "Install complete. Launch with: $SCRIPT_DIR/launch-server.sh"
