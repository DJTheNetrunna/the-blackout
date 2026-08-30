#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib/common.sh
source "$SCRIPT_DIR/lib/common.sh"
load_env
require_cmd tar
require_cmd sha256sum

mkdir -p "$BACKUP_DIR"
[[ -d "$PZ_CACHE_DIR" ]] || die "Cachedir not found: $PZ_CACHE_DIR"

stamp="$(date -u +%Y%m%d-%H%M%S)"
archive="$BACKUP_DIR/knox-nightmare-$stamp.tar.gz"

paths=()
[[ -d "$PZ_CACHE_DIR/Server" ]] && paths+=(Server)
[[ -d "$PZ_CACHE_DIR/Saves" ]] && paths+=(Saves)
[[ ${#paths[@]} -gt 0 ]] || die "No Server/ or Saves/ data found under $PZ_CACHE_DIR"

tar -C "$PZ_CACHE_DIR" -czf "$archive" "${paths[@]}"
sha256sum "$archive" > "$archive.sha256"
log "Backup: $archive"
log "Checksum: $archive.sha256"
