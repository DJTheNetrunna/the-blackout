# Compatibility Rules

1. Build 42.20.x is the supported baseline.
2. Build 41 saves/config assumptions are not accepted without explicit revalidation.
3. Compatibility is classified separately for SOLO, CO-OP, and SERVER in `mods/manifest.tsv`.
4. A target's default profile includes only that target's `approved` entries.
5. `*-lab` profiles may include that target's `candidate` entries and are disposable-world only.
6. `hold` and `rejected` entries never enter normal generated profiles.
7. Dependency order is explicit; frameworks load before dependent modules.
8. Third-party Workshop payloads remain on Steam and are never silently vendored into Git.
9. Local installation backs up existing saves and writes named presets/configs without editing old worlds.
10. Dedicated changes require backup/rollback discipline before Build or mod transitions.
11. Static/CI success is not a substitute for real B42.20 save/reload, multiplayer synchronization, or dedicated-server runtime testing.
