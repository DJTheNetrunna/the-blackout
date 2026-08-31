#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd -- "$SCRIPT_DIR/.." && pwd)"

tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT
mkdir -p "$tmp/steamcmd" "$tmp/server" "$tmp/cache/Server" "$tmp/cache/Saves/Multiplayer/KnoxNightmare"
mkdir -p "$tmp/Steam/steamapps/common/ProjectZomboid" "$tmp/Steam/steamapps/workshop/content/108600"
mkdir -p "$tmp/localdata/Saves/Sandbox/ExistingWorld"
touch "$tmp/Steam/steamapps/appmanifest_108600.acf"
printf 'existing-save\n' > "$tmp/localdata/Saves/Sandbox/ExistingWorld/map.bin"

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
export MOD_PROFILE=server
export PREFETCH_WORKSHOP=1
export MOCK_STEAM_LOG="$tmp/steam.log"
export MOCK_LAUNCH_LOG="$tmp/launch.log"
export PZ_STEAMAPPS_DIR="$tmp/Steam/steamapps"
export PZ_GAME_DIR="$tmp/Steam/steamapps/common/ProjectZomboid"
export PZ_WORKSHOP_DIR="$tmp/Steam/steamapps/workshop/content/108600"
export PZ_DATA_DIR="$tmp/localdata"

# Profile generation
for target in solo coop server; do
  "$SCRIPT_DIR/configure-knox.sh" "$target" >/dev/null
  test -f "$REPO_ROOT/.generated/$target/Knox Nightmare - ${target^^}.cfg"
  test -f "$REPO_ROOT/.generated/$target/KnoxNightmare_SandboxVars.lua"
done

grep -Fxq 'ZombieLore.SprinterPercentage=15' "$REPO_ROOT/.generated/solo/Knox Nightmare - SOLO.cfg"
grep -Fxq 'ReactiveSE' "$REPO_ROOT/.generated/solo/MOD_IDS.txt"
grep -Fxq 'BleakWorldHorror' "$REPO_ROOT/.generated/solo/MOD_IDS.txt"
grep -Fxq 'StarlitLibrary' "$REPO_ROOT/.generated/solo/MOD_IDS.txt"
grep -Fxq 'ZCTWS' "$REPO_ROOT/.generated/solo/MOD_IDS.txt"
if grep -Fxq 'afraidofmonsterszombies' "$REPO_ROOT/.generated/solo/MOD_IDS.txt"; then
  printf 'Afraid of Monsters conflicts with default Bleak World SOLO visual layer\n' >&2
  exit 1
fi
if grep -Fxq 'ReactiveSE' "$REPO_ROOT/.generated/coop/MOD_IDS.txt"; then
  printf 'ReactiveSE leaked into default CO-OP profile\n' >&2
  exit 1
fi
grep -Fxq 'SurvivingTheStorm' "$REPO_ROOT/.generated/coop/MOD_IDS.txt"
if grep -Fxq 'SurvivingTheStorm' "$REPO_ROOT/.generated/server/MOD_IDS.txt"; then
  printf 'SurvivingTheStorm leaked into default SERVER profile\n' >&2
  exit 1
fi
grep -Fxq 'HHNR' "$REPO_ROOT/.generated/server/MOD_IDS.txt"

# Local Steam detection
"$SCRIPT_DIR/detect-local.sh" --shell > "$tmp/detected.txt"
grep -Fq "$tmp/Steam/steamapps" "$tmp/detected.txt"

# Pretend Steam already downloaded SOLO's selected Workshop items.
while IFS= read -r wid; do
  [[ -n "$wid" ]] && mkdir -p "$PZ_WORKSHOP_DIR/$wid"
done < "$REPO_ROOT/.generated/solo/WORKSHOP_IDS.txt"

# Local install must back up but preserve the existing save.
"$SCRIPT_DIR/install-local.sh" solo >/dev/null
grep -Fxq 'existing-save' "$tmp/localdata/Saves/Sandbox/ExistingWorld/map.bin"
test -f "$tmp/localdata/Sandbox Presets/Knox Nightmare - SOLO.cfg"
find "$tmp/root/local-backups" -type f -name 'local-saves-*.tar.gz' | grep -q .

# Hosted CO-OP install is isolated under its own names.
"$SCRIPT_DIR/install-local.sh" coop >/dev/null
test -f "$tmp/localdata/Server/KnoxNightmare-Coop.ini"
test -f "$tmp/localdata/Server/KnoxNightmare-Coop_SandboxVars.lua"

# Dedicated lifecycle
"$SCRIPT_DIR/install.sh" >/dev/null
"$SCRIPT_DIR/install-mods.sh" server >/dev/null
"$SCRIPT_DIR/update-mods.sh" >/dev/null
"$SCRIPT_DIR/launch-server.sh"

grep -Fxq -- '-servername KnoxNightmare -cachedir='"$tmp/cache" "$tmp/launch.log"
update_calls="$(grep -Fc '+app_update 380870 validate' "$tmp/steam.log" || true)"
[[ "$update_calls" -ge 2 ]]
grep -Fq '+workshop_download_item 108600 3676814360 validate' "$tmp/steam.log"
grep -Fq '+workshop_download_item 108600 3713005182 validate' "$tmp/steam.log"

"$SCRIPT_DIR/backup.sh" >/dev/null
archive="$(find "$tmp/backups" -type f -name '*.tar.gz' | head -n 1)"
[[ -n "$archive" ]]
rm -rf "$tmp/cache/Server" "$tmp/cache/Saves"
"$SCRIPT_DIR/restore.sh" "$archive" --no-safety-backup >/dev/null
grep -Fxq 'worlddata' "$tmp/cache/Saves/Multiplayer/KnoxNightmare/map.bin"

for profile in vanilla server server-lab; do
  rm -rf "$tmp/cache/Server"
  MOD_PROFILE="$profile" "$SCRIPT_DIR/generate-config.sh" "$profile" >/dev/null
  if grep -Eq '(2590814089|2858019558|3518609649|3395146956)' "$tmp/cache/Server/KnoxNightmare.ini"; then
    printf 'rejected Workshop ID leaked into profile %s\n' "$profile" >&2
    exit 1
  fi
done

printf '[knox-nightmare] SOLO Fear Pass + CO-OP + SERVER mocked lifecycle tests passed\n'
