#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib/common.sh
source "$SCRIPT_DIR/lib/common.sh"
load_env
require_cmd tar

archive="${1:-}"
[[ -n "$archive" ]] || die "Usage: $0 <backup.tar.gz> [--no-safety-backup]"
[[ -f "$archive" ]] || die "Backup not found: $archive"

if [[ -f "$archive.sha256" ]] && command -v sha256sum >/dev/null 2>&1; then
  (cd "$(dirname -- "$archive")" && sha256sum -c "$(basename -- "$archive").sha256")
fi

tar -tzf "$archive" >/dev/null
if tar -tzf "$archive" | awk '$0 ~ /^\// || $0 ~ /(^|\/)\.\.($|\/)/ {bad=1} END {exit bad?0:1}'; then
  die "Archive contains an absolute or path-traversal entry"
fi

if [[ "${2:-}" != "--no-safety-backup" ]] && [[ -d "$PZ_CACHE_DIR/Server" || -d "$PZ_CACHE_DIR/Saves" ]]; then
  log "Creating safety backup before restore"
  "$SCRIPT_DIR/backup.sh"
fi

mkdir -p "$PZ_CACHE_DIR"
tar -C "$PZ_CACHE_DIR" -xzf "$archive"
log "Restored $archive into $PZ_CACHE_DIR"
