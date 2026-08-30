#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib/common.sh
source "$SCRIPT_DIR/lib/common.sh"
# shellcheck source=lib/local.sh
source "$SCRIPT_DIR/lib/local.sh"
load_env
require_cmd tar
require_cmd sha256sum

detect_local_paths || die "Project Zomboid Steam library not detected"
saves="$PZ_DATA_DIR/Saves"
[[ -d "$saves" ]] || { log "No existing local Saves directory found; nothing to back up."; exit 0; }

stamp="$(date -u +%Y%m%d-%H%M%S)"
dir="$KNOX_ROOT/local-backups"
mkdir -p "$dir"
archive="$dir/local-saves-$stamp.tar.gz"
tar -C "$PZ_DATA_DIR" -czf "$archive" Saves
sha256sum "$archive" > "$archive.sha256"
log "Local save backup: $archive"
