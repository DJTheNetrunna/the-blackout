#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib/common.sh
source "$SCRIPT_DIR/lib/common.sh"
# shellcheck source=lib/local.sh
source "$SCRIPT_DIR/lib/local.sh"
load_env

detect_local_paths || die "Project Zomboid Steam library not detected. Set PZ_STEAMAPPS_DIR or PZ_GAME_DIR explicitly."

if [[ "${1:-}" == "--shell" ]]; then
  printf 'PZ_STEAMAPPS_DIR=%q\n' "$PZ_STEAMAPPS_DIR"
  printf 'PZ_GAME_DIR=%q\n' "$PZ_GAME_DIR"
  printf 'PZ_WORKSHOP_DIR=%q\n' "$PZ_WORKSHOP_DIR"
  printf 'PZ_DATA_DIR=%q\n' "$PZ_DATA_DIR"
else
  printf 'Steam apps: %s\nGame:       %s\nWorkshop:   %s\nUser data:  %s\n' "$PZ_STEAMAPPS_DIR" "$PZ_GAME_DIR" "$PZ_WORKSHOP_DIR" "$PZ_DATA_DIR"
fi
