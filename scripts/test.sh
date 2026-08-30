#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd -- "$SCRIPT_DIR/.." && pwd)"

tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT
mkdir -p "$tmp/steamcmd" "$tmp/server" "$tmp/cache/Server" "$tmp/cache/Saves/Multiplayer/KnoxNightmare"

cat > "$tmp/steamcmd/steamcmd.sh" <<'MOCK'
#!/usr/bin/env bash
printf '%s\n' "$*" >> "${MOCK_STEAM_LOG:?}"
MOCK
chmod +x "$tmp/steamcmd/steamcmd.sh"

cat > "$tmp/server/start-server.sh" <<'MOCK'
#!/usr/bin/env bash
printf '%s\n' "$*" > "${MOCK_LAUNCH_LOG:?}"
MOCK
chmod +x "$tmp/server/start-server.sh"
printf 'worlddata\n' > "$tmp/cache/Saves/Multiplayer/KnoxNightmare/map.bin"

export KNOX_ROOT="$tmp/root"
export PZ_SERVER_DIR="$tmp/server"
export PZ_CACHE_DIR="$tmp/cache"
export STEAMCMD_DIR="$tmp/steamcmd"
export BACKUP_DIR="$tmp/backups"
export SERVER_NAME=KnoxNightmare
export MOD_PROFILE=core
export PREFETCH_WORKSHOP=1
export MOCK_STEAM_LOG="$tmp/steam.log"
export MOCK_LAUNCH_LOG="$tmp/launch.log"

"$SCRIPT_DIR/install.sh" >/dev/null
"$SCRIPT_DIR/install-mods.sh" recommended >/dev/null
"$SCRIPT_DIR/launch-server.sh"

grep -Fxq -- '-servername KnoxNightmare -cachedir='"$tmp/cache" "$tmp/launch.log"
grep -Fq '+app_update 380870 validate' "$tmp/steam.log"
grep -Fq '+workshop_download_item 108600 3676814360 validate' "$tmp/steam.log"
grep -Fq '+workshop_download_item 108600 3627773043 validate' "$tmp/steam.log"

"$SCRIPT_DIR/backup.sh" >/dev/null
archive="$(find "$tmp/backups" -type f -name '*.tar.gz' | head -n 1)"
[[ -n "$archive" ]]
rm -rf "$tmp/cache/Server" "$tmp/cache/Saves"
"$SCRIPT_DIR/restore.sh" "$archive" --no-safety-backup >/dev/null
grep -Fxq 'worlddata' "$tmp/cache/Saves/Multiplayer/KnoxNightmare/map.bin"

for profile in vanilla core recommended horror-lab; do
  rm -rf "$tmp/cache/Server"
  MOD_PROFILE="$profile" "$SCRIPT_DIR/generate-config.sh" "$profile" >/dev/null
  ! grep -Eq '(2590814089|2858019558|3518609649)' "$tmp/cache/Server/KnoxNightmare.ini"
done

printf '[knox-nightmare] Mock lifecycle tests passed\n'
