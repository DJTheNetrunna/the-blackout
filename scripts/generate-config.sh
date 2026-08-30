#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib/common.sh
source "$SCRIPT_DIR/lib/common.sh"
load_env

profile="${1:-$MOD_PROFILE}"
mkdir -p "$PZ_CACHE_DIR/Server"

rows="$(selected_manifest_rows "$profile" || true)"
workshop=""
mods=""
if [[ -n "$rows" ]]; then
  workshop="$(printf '%s\n' "$rows" | awk -F '\t' '{print $1}' | paste -sd ';' -)"
  mods="$(printf '%s\n' "$rows" | awk -F '\t' '{print $2}' | paste -sd ';' -)"
fi

out="$(active_server_ini)"
cp "$(server_template)" "$out"
sed -i -E "s|^WorkshopItems=.*$|WorkshopItems=$workshop|" "$out"
sed -i -E "s|^Mods=.*$|Mods=$mods|" "$out"
cp "$(sandbox_template)" "$(active_sandbox_lua)"

log "Generated profile '$profile'"
log "Server config: $out"
log "WorkshopItems=${workshop:-<none>}"
log "Mods=${mods:-<none>}"
