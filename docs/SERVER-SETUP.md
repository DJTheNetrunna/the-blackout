# Server Setup

## Dedicated server

Project Zomboid Dedicated Server uses Steam App ID `380870` and supports anonymous SteamCMD installation.

The repository defaults to:

```text
SERVER_NAME=KnoxNightmare
PZ_SERVER_DIR=~/knox-nightmare/server
PZ_CACHE_DIR=~/knox-nightmare/Zomboid
```

The active configuration files become:

```text
~/knox-nightmare/Zomboid/Server/KnoxNightmare.ini
~/knox-nightmare/Zomboid/Server/KnoxNightmare_SandboxVars.lua
```

## Generation

Never hand-maintain duplicate Workshop lists. `mods/manifest.tsv` is the source of truth.

```bash
./scripts/generate-config.sh core
```

This writes `WorkshopItems=` and `Mods=` into the deployment INI based on the selected profile.

## Start

```bash
./scripts/launch-server.sh
```

The launcher passes both `-servername` and `-cachedir` so configuration/save paths are deterministic.

## Stop

Use the Project Zomboid server console and issue:

```text
quit
```

A clean stop is especially important before backup, restore, and mod updates.
