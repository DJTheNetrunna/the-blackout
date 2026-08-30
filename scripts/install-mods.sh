#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib/common.sh
source "$SCRIPT_DIR/lib/common.sh"
load_env

profile="${1:-$MOD_PROFILE}"
"$SCRIPT_DIR/generate-config.sh" "$profile"

if [[ "$PREFETCH_WORKSHOP" != "1" ]]; then
  log "Workshop prefetch disabled. The PZ server will obtain configured WorkshopItems on launch."
  exit 0
fi

steamcmd="$(steamcmd_bin)" || die "SteamCMD not installed; run scripts/install.sh first"
rows="$(selected_manifest_rows "$profile" || true)"
[[ -n "$rows" ]] || { log "No Workshop items selected for profile '$profile'."; exit 0; }

while IFS=$'\t' read -r wid _; do
  [[ -n "$wid" ]] || continue
  log "Prefetching Workshop item $wid"
  if ! "$steamcmd" +login anonymous +workshop_download_item 108600 "$wid" validate +quit; then
    warn "SteamCMD could not prefetch $wid anonymously. It may still download when the dedicated server launches."
  fi
done <<< "$rows"
