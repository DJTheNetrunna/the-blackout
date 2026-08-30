# Local Steam / Single-Player Installation

## Detection

Run:

```bash
./scripts/detect-local.sh
```

The detector checks native Linux Steam, the common `~/.steam/steam` link, Flatpak Steam, and extra libraries declared in `libraryfolders.vdf`. It selects the Steam library containing Project Zomboid's `appmanifest_108600.acf` or game directory, then derives the matching Workshop directory.

Typical paths are only fallbacks, never hard-coded assumptions.

Override detection when necessary:

```bash
PZ_STEAMAPPS_DIR=/mnt/games/SteamLibrary/steamapps ./scripts/install-local.sh solo
```

## Steam client Workshop flow

The normal-player path is the normal Steam client:

1. `install-local.sh` generates `WORKSHOP_URLS.txt`.
2. It checks the detected `steamapps/workshop/content/108600/<WorkshopID>` directories.
3. Missing items are listed in `MISSING_WORKSHOP_URLS.txt`.
4. Subscribe to those URLs in Steam.
5. Allow Steam to finish downloads before launching the world.

SteamCMD remains supported for the dedicated server. The repository does not impersonate Steam-client subscription state or copy third-party Workshop payloads into Git.

## User data

Native Linux Project Zomboid normally stores saves/config under `~/Zomboid`. `PZ_DATA_DIR` can override it when necessary.

The installer creates only:

- one named Knox Nightmare sandbox preset;
- `~/Zomboid/KnoxNightmare/<profile>/` reference lists;
- for CO-OP, named `KnoxNightmare-Coop` server files.

It does not delete or convert existing saves.
