#!/usr/bin/env bash
set -euo pipefail

input="${1:-}"
output="${2:-}"
[[ -n "$input" && -n "$output" ]] || { echo "Usage: $0 <preset.cfg> <SandboxVars.lua>" >&2; exit 2; }
[[ -f "$input" ]] || { echo "Preset not found: $input" >&2; exit 1; }
mkdir -p "$(dirname -- "$output")"

awk '
function trim(s) { gsub(/^[[:space:]]+|[[:space:]]+$/, "", s); return s }
function lua(v, q) {
  if (v == "true" || v == "false" || v ~ /^-?[0-9]+([.][0-9]+)?$/) return v
  q = v
  gsub(/\\/, "\\\\", q)
  gsub(/"/, "\\\"", q)
  return "\"" q "\""
}
/^[[:space:]]*#/ || /^[[:space:]]*$/ { next }
{
  eq = index($0, "=")
  if (!eq) next
  key = trim(substr($0, 1, eq - 1))
  value = trim(substr($0, eq + 1))
  if (key == "Version") key = "VERSION"

  dot = index(key, ".")
  if (dot) {
    table = substr(key, 1, dot - 1)
    subkey = substr(key, dot + 1)
    if (!(table in table_seen)) {
      table_seen[table] = 1
      table_order[++table_count] = table
    }
    table_lines[table] = table_lines[table] "        " subkey " = " lua(value) ",\n"
  } else {
    root_lines = root_lines "    " key " = " lua(value) ",\n"
  }
}
END {
  printf "SandboxVars = {\n%s", root_lines
  for (i = 1; i <= table_count; i++) {
    table = table_order[i]
    printf "    %s = {\n%s    },\n", table, table_lines[table]
  }
  print "}"
}
' "$input" > "$output"
