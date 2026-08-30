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
  if ! bash -n "$f"; then
    warn "Shell syntax failed: $f"
    fail=1
  fi
done

log "Checking manifest shape, numeric Workshop IDs, statuses, and duplicates"
if ! awk -F '\t' '
  NR==1 { if (NF != 10) { print "bad header field count" > "/dev/stderr"; bad=1 }; next }
  NF != 10 { print "bad field count on line " NR > "/dev/stderr"; bad=1 }
  $1 !~ /^[0-9]+$/ { print "invalid workshop id on line " NR > "/dev/stderr"; bad=1 }
  $5 !~ /^(approved|candidate|hold|rejected)$/ { print "invalid status on line " NR > "/dev/stderr"; bad=1 }
  seenW[$1]++ { print "duplicate workshop id " $1 > "/dev/stderr"; bad=1 }
  ($5 != "rejected") && seenM[$2]++ { print "duplicate active mod id " $2 > "/dev/stderr"; bad=1 }
  END { exit bad ? 1 : 0 }
' "$manifest"; then
  fail=1
fi

for profile in vanilla core recommended horror-lab; do
  rows="$(selected_manifest_rows "$profile" || true)"
  if printf '%s\n' "$rows" | awk -F '\t' '$5=="hold" || $5=="rejected" {bad=1} END {exit bad?0:1}'; then
    warn "Profile '$profile' emitted a hold/rejected mod"
    fail=1
  fi
done

if command -v luac >/dev/null 2>&1; then
  log "Checking sandbox Lua syntax with luac"
  luac -p "$(sandbox_template)" || fail=1
else
  log "luac not installed; skipping Lua parser check"
fi

if [[ $online -eq 1 ]]; then
  if ! command -v curl >/dev/null 2>&1; then
    warn "curl unavailable; skipping online checks"
  else
    log "Checking non-rejected Workshop pages"
    while IFS=$'\t' read -r wid mod_id name tier status build multiplayer dependencies redistribution notes; do
      [[ "$status" == "rejected" ]] && continue
      url="https://steamcommunity.com/sharedfiles/filedetails/?id=$wid"
      if ! curl -fsSL --max-time 15 "$url" | grep -q "$wid"; then
        warn "Could not verify Workshop page for $wid (rate limiting is possible)"
      fi
    done < <(tail -n +2 "$manifest")
  fi
fi

if [[ -f "$(active_server_ini)" ]]; then
  if grep -Eq '(^|;)(2590814089|2858019558|3518609649)(;|$)' "$(active_server_ini)"; then
    warn "Generated INI contains a rejected Workshop ID"
    fail=1
  fi
fi

if command -v shellcheck >/dev/null 2>&1; then
  log "Running shellcheck"
  shellcheck "$SCRIPT_DIR"/*.sh "$SCRIPT_DIR"/lib/*.sh || fail=1
else
  log "shellcheck not installed; skipping lint"
fi

[[ $fail -eq 0 ]] || die "Validation failed"
log "Validation passed"
