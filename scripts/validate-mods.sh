#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib/common.sh
source "$SCRIPT_DIR/lib/common.sh"
load_env

online=0
[[ "${1:-}" == "--online" ]] && online=1
manifest="$(manifest_file)"
[[ -f "$manifest" ]] || die "Missing manifest: $manifest"
fail=0

log "Checking shell syntax"
for f in "$SCRIPT_DIR"/*.sh "$SCRIPT_DIR"/lib/*.sh; do
  bash -n "$f" || fail=1
done

log "Checking multi-target manifest"
if ! awk -F '\t' '
  NR==1 { if (NF != 12) { print "bad header field count" > "/dev/stderr"; bad=1 }; next }
  NF != 12 { print "bad field count on line " NR > "/dev/stderr"; bad=1 }
  $1 !~ /^[0-9]+$/ { print "invalid workshop id on line " NR > "/dev/stderr"; bad=1 }
  $6 !~ /^(approved|candidate|hold|rejected)$/ || $7 !~ /^(approved|candidate|hold|rejected)$/ || $8 !~ /^(approved|candidate|hold|rejected)$/ { print "invalid target status on line " NR > "/dev/stderr"; bad=1 }
  $9 !~ /^[0-9]+$/ { print "invalid load order on line " NR > "/dev/stderr"; bad=1 }
  seenW[$1]++ { print "duplicate workshop id " $1 > "/dev/stderr"; bad=1 }
  seenM[$2]++ { print "duplicate mod id " $2 > "/dev/stderr"; bad=1 }
  {
    ids[$2]=1
    if (!($6=="rejected" && $7=="rejected" && $8=="rejected")) deps[NR]=$10
  }
  END {
    for (line in deps) {
      if (deps[line] == "none") continue
      n=split(deps[line], d, ";")
      for (i=1; i<=n; i++) if (!(d[i] in ids)) { print "unknown dependency " d[i] " on line " line > "/dev/stderr"; bad=1 }
    }
    exit bad ? 1 : 0
  }
' "$manifest"; then
  fail=1
fi

for profile in solo coop server solo-lab coop-lab server-lab vanilla; do
  rows="$(selected_manifest_rows "$profile" || true)"
  if printf '%s\n' "$rows" | awk -F '\t' '$6=="rejected" && $7=="rejected" && $8=="rejected" {bad=1} END {exit bad?0:1}'; then
    warn "Profile '$profile' emitted a globally rejected mod"
    fail=1
  fi
done

for target in solo coop server; do
  "$SCRIPT_DIR/configure-knox.sh" "$target" >/dev/null
  cfg="$REPO_ROOT/.generated/$target/Knox Nightmare - ${target^^}.cfg"
  lua="$REPO_ROOT/.generated/$target/KnoxNightmare_SandboxVars.lua"
  grep -Fxq 'Version=6' "$cfg" || fail=1
  grep -Fq 'SprinterPercentage' "$cfg" || fail=1
  if command -v luac >/dev/null 2>&1; then luac -p "$lua" || fail=1; fi
done

if [[ $online -eq 1 ]] && command -v curl >/dev/null 2>&1; then
  log "Checking non-globally-rejected Workshop pages"
  while IFS=$'\t' read -r wid _mid _name _tier _build solo coop server _rest; do
    [[ "$solo$coop$server" == "rejectedrejectedrejected" ]] && continue
    url="https://steamcommunity.com/sharedfiles/filedetails/?id=$wid"
    curl -fsSL --max-time 15 "$url" | grep -q "$wid" || warn "Could not verify Workshop page for $wid"
  done < <(tail -n +2 "$manifest")
fi

if command -v shellcheck >/dev/null 2>&1; then
  log "Running shellcheck"
  shellcheck -x -e SC1091,SC2016 "$SCRIPT_DIR"/*.sh "$SCRIPT_DIR"/lib/*.sh || fail=1
fi

[[ $fail -eq 0 ]] || die "Validation failed"
log "Validation passed"
