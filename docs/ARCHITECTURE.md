# Architecture

```text
mods/manifest.tsv
      │
      ├── generate-config.sh ──> KnoxNightmare.ini
      │
      ├── validate-mods.sh ────> structural / upstream checks
      │
      └── documentation

config/sandbox/KnoxNightmare_SandboxVars.lua
      │
      └── install.sh ──────────> cachedir/Server/

SteamCMD ──> Project Zomboid Dedicated Server (380870)
                    │
                    └── launch-server.sh (-servername, -cachedir)

cachedir/Server + cachedir/Saves
      │
      ├── backup.sh
      └── restore.sh
```

## Ownership

- `mods/manifest.tsv`: single source of truth for Workshop/mod IDs and compatibility classification.
- `config/`: canonical examples committed to Git.
- deployment cachedir: generated/runtime state, never committed.
- Steam Workshop payloads: owned/distributed by their respective authors through Steam, never vendored here by default.

## Validation pipeline

`.github/workflows/validate.yml` installs ShellCheck and Lua 5.4, runs `validate-mods.sh`, then runs `scripts/test.sh`. The test uses mock SteamCMD/server launchers so pull requests can exercise the install/config/update/launch/backup/restore control flow without downloading Project Zomboid.
