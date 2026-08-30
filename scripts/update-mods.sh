#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib/common.sh
source "$SCRIPT_DIR/lib/common.sh"
load_env

steamcmd="$(steamcmd_bin)" || die "SteamCMD not installed; run scripts/install.sh first"
warn "Stop the Project Zomboid server cleanly before updating."
log "Updating dedicated server"
"$steamcmd" +force_install_dir "$PZ_SERVER_DIR" +login anonymous +app_update 380870 validate +quit

if [[ "$PREFETCH_WORKSHOP" == "1" ]]; then
  "$SCRIPT_DIR/install-mods.sh" "$MOD_PROFILE"
else
  log "Workshop items will refresh during the next server launch."
fi
