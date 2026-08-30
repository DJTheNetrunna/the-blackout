#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib/common.sh
source "$SCRIPT_DIR/lib/common.sh"
load_env

launcher="$PZ_SERVER_DIR/start-server.sh"
[[ -x "$launcher" ]] || die "Server launcher not found/executable: $launcher (run scripts/install.sh)"
[[ -f "$(active_server_ini)" ]] || "$SCRIPT_DIR/generate-config.sh" "$MOD_PROFILE"

cd "$PZ_SERVER_DIR"
exec "$launcher" -servername "$SERVER_NAME" -cachedir="$PZ_CACHE_DIR"
