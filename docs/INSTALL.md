# Installation

Knox Nightmare has three installation paths. All target Build 42.20.x and share the same sandbox source.

## Recommended easy launcher

Windows users can double-click `KnoxNightmare.bat`. Linux and Steam Deck users can run `./knox-nightmare`. Both launchers offer install, update, and system-check actions while preserving the lower-level commands below for advanced use.

See [`EASY-INSTALL.md`](EASY-INSTALL.md).

## SOLO — normal Steam client

Requirements: Linux Steam installation of Project Zomboid, Bash, tar, gzip, and sha256sum.

```bash
git clone https://github.com/DJTheNetrunna/the-blackout.git
cd the-blackout
./knox-nightmare install solo
```

The installer discovers the Steam library that actually contains App `108600`, derives its Workshop path, backs up existing local saves, installs only the named Knox Nightmare sandbox preset, and reports missing Workshop subscriptions. Subscribe to missing items through the normal Steam client.

Then launch Project Zomboid → **Mods** → enable the generated SOLO Mod IDs → **Solo** → **Custom Sandbox** → load **Knox Nightmare - SOLO** → create a new world.

## CO-OP — normal Host workflow

```bash
./knox-nightmare install coop
```

This installs the CO-OP menu preset and isolated `KnoxNightmare-Coop` host files under the detected Project Zomboid data directory. Existing saves and unrelated host profiles are preserved.

Launch Project Zomboid → **Host** → **Manage Settings** → select/verify `KnoxNightmare-Coop` → create a new hosted world.

## SERVER — dedicated Linux server

```bash
cp config/examples/knox-nightmare.env.example .env
$EDITOR .env
./scripts/install.sh
./scripts/generate-config.sh server
./scripts/validate-mods.sh
./scripts/launch-server.sh
```

`install.sh` obtains SteamCMD if necessary and installs Project Zomboid Dedicated Server App `380870`. Workshop/game App ID is `108600`.

## Steam library detection

`detect-local.sh` checks common native and Flatpak Steam roots plus libraries listed in `libraryfolders.vdf`. Do not assume Project Zomboid lives under one fixed home-directory path.

Overrides are supported:

```bash
PZ_STEAMAPPS_DIR=/mnt/games/SteamLibrary/steamapps ./scripts/install-local.sh solo
```

## Save protection

Local installers back up the entire existing `Saves/` tree before installing a preset and never convert or modify an existing world. Dedicated-server operations should use `backup.sh` before Build/mod changes.

## Build 41

Do not overwrite a Build 41 world with Build 42. Preserve B41 saves separately and create a new Build 42.20 Knox Nightmare world unless a future tested migration procedure is documented.
