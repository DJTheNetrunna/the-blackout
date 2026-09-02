#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib/common.sh
source "$SCRIPT_DIR/lib/common.sh"
load_env

target="${1:-server}"
case "$target" in
  blind|solo|coop|server) ;;
  *) die "Usage: $0 <blind|solo|coop|server>" ;;
esac

outdir="$REPO_ROOT/.generated/$target"
mkdir -p "$outdir"
merged="$outdir/Knox Nightmare - ${target^^}.cfg"

overlay="$(profile_sandbox_cfg "$target")"
[[ -f "$overlay" ]] || die "Missing profile overlay: $overlay"

awk '
function trim(s) { gsub(/^[[:space:]]+|[[:space:]]+$/, "", s); return s }
/^[[:space:]]*#/ || /^[[:space:]]*$/ { next }
{
  eq = index($0, "=")
  if (!eq) next
  key = trim(substr($0, 1, eq - 1))
  value = trim(substr($0, eq + 1))
  if (!(key in seen)) order[++count] = key
  seen[key] = 1
  values[key] = value
}
END {
  for (i = 1; i <= count; i++) print order[i] "=" values[order[i]]
}
' "$(base_sandbox_cfg)" "$overlay" > "$merged"

lua="$outdir/KnoxNightmare_SandboxVars.lua"
"$SCRIPT_DIR/render-sandbox.sh" "$merged" "$lua"

profile="$target"
rows="$(selected_manifest_rows "$profile" || true)"
: > "$outdir/WORKSHOP_IDS.txt"
: > "$outdir/MOD_IDS.txt"
: > "$outdir/WORKSHOP_URLS.txt"
if [[ -n "$rows" ]]; then
  printf '%s\n' "$rows" | awk -F '\t' '{print $1}' > "$outdir/WORKSHOP_IDS.txt"
  printf '%s\n' "$rows" | awk -F '\t' '{print $2}' > "$outdir/MOD_IDS.txt"
  awk '{print "https://steamcommunity.com/sharedfiles/filedetails/?id=" $1}' "$outdir/WORKSHOP_IDS.txt" > "$outdir/WORKSHOP_URLS.txt"
fi

if [[ "$target" != "solo" && "$target" != "blind" ]]; then
  ini="$outdir/KnoxNightmare${target:+-${target^}}.ini"
  cp "$(server_template)" "$ini"
  workshop="$(paste -sd ';' "$outdir/WORKSHOP_IDS.txt")"
  mods="$(paste -sd ';' "$outdir/MOD_IDS.txt")"
  sed -i -E "s|^WorkshopItems=.*$|WorkshopItems=$workshop|" "$ini"
  sed -i -E "s|^Mods=.*$|Mods=$mods|" "$ini"
  if [[ "$target" == "coop" ]]; then
    sed -i -E 's|^PublicName=.*$|PublicName=The Blackout - Knox Nightmare CO-OP|' "$ini"
    sed -i -E 's|^MaxPlayers=.*$|MaxPlayers=8|' "$ini"
  fi
fi

log "Generated Knox Nightmare $target profile in $outdir"
