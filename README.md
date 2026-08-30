# The Blackout — Knox Nightmare

Knox Nightmare is a reproducible **Project Zomboid Build 42.20.x** survival-horror build for Linux with three first-class targets:

| Profile | Purpose | Default philosophy |
|---|---|---|
| **SOLO** | Normal single-player / local game | Maximum atmosphere, audio, rare special infected, darkness and isolation |
| **CO-OP** | Steam/local hosted multiplayer | Horror with mods that have current hosted-MP evidence |
| **SERVER** | Dedicated Linux server | Stability, synchronization, predictable resource use and administration |

All three share the same Build 42 sandbox source in `config/sandbox/base.cfg`. Small target overlays in `config/profiles/` change only the values that need to differ. `scripts/configure-knox.sh` renders the correct normal-game preset and server Lua rather than maintaining three unrelated worlds.

## Build 42 horror model

Knox Nightmare uses the current B42 mixed-speed system instead of making every zombie a permanent sprinter:

- `ZombieLore.Speed=4` — random speed band.
- `ZombieLore.SprinterPercentage` — 12% SOLO, 8% CO-OP, 6% SERVER.
- `ZombieLore.ActiveOnly=2` — full zombie activity is concentrated at night.
- pitch-black, long nights.
- strong sound attraction and frequent migration.
- high but target-adjusted population pressure.
- no minimap, map requires light.
- scarce food, medicine, firearms, ammunition, tools, fuel and working vehicles.
- water/electricity shutoff modifiers target the opening two weeks.
- blood-and-saliva infection with 2–3 day mortality.
- no multi-hit or starter kit.

## SOLO quick start

```bash
git clone https://github.com/DJTheNetrunna/the-blackout.git
cd the-blackout

./scripts/detect-local.sh
./scripts/install-local.sh solo
```

The local installer:

1. detects the Steam library actually containing Project Zomboid;
2. detects the matching `steamapps/workshop/content/108600` directory;
3. uses the local Project Zomboid data directory (normally `~/Zomboid`);
4. backs up existing local saves before installing anything;
5. generates and installs `Knox Nightmare - SOLO.cfg` into `Sandbox Presets`;
6. writes the selected Workshop URLs and Mod IDs under `~/Zomboid/KnoxNightmare/solo/`;
7. reports missing Workshop subscriptions;
8. never changes an existing world.

Then subscribe to any reported missing Workshop items in the normal Steam client and follow [`KnoxNightmare/singleplayer/README.md`](KnoxNightmare/singleplayer/README.md).

## CO-OP quick start

```bash
./scripts/install-local.sh coop
```

This performs the same save-safe local installation and additionally installs a separate `KnoxNightmare-Coop.ini` and `KnoxNightmare-Coop_SandboxVars.lua` under your Project Zomboid `Server/` directory. Existing host profiles are left untouched.

See [`KnoxNightmare/multiplayer/README.md`](KnoxNightmare/multiplayer/README.md).

## Dedicated server quick start

```bash
cp config/examples/knox-nightmare.env.example .env
$EDITOR .env
./scripts/install.sh
./scripts/generate-config.sh server
./scripts/validate-mods.sh
./scripts/launch-server.sh
```

Dedicated-server Steam App ID: `380870`. Project Zomboid / Workshop App ID: `108600`.

See [`KnoxNightmare/dedicated-server/README.md`](KnoxNightmare/dedicated-server/README.md).

## Generate without installing

```bash
./scripts/configure-knox.sh solo
./scripts/configure-knox.sh coop
./scripts/configure-knox.sh server
```

Generated artifacts go under `.generated/<target>/`:

```text
Knox Nightmare - SOLO.cfg
KnoxNightmare_SandboxVars.lua
WORKSHOP_IDS.txt
MOD_IDS.txt
WORKSHOP_URLS.txt
```

CO-OP and SERVER also receive generated INI material.

## Default Workshop sets

### SOLO

- DEZ — Dynamic Evolution Z
- LED Lantern
- Surviving the Storm
- Reactive Sound Events
- Special Zombies Framework
- Special Zombies #01 — Screamer
- Hark's Horde Night Revamped
- Afraid of Monsters zombies

### CO-OP

- DEZ — Dynamic Evolution Z
- LED Lantern
- Surviving the Storm
- Special Zombies Framework
- Special Zombies #01 — Screamer
- Hark's Horde Night Revamped

### SERVER

- DEZ — Dynamic Evolution Z
- LED Lantern
- Hark's Horde Night Revamped

Candidate/hold/rejected status is target-specific. A strong SOLO mod is no longer rejected merely because dedicated-server support is weak. See [`mods/COMPATIBILITY-MATRIX.md`](mods/COMPATIBILITY-MATRIX.md).

## Steam installation policy

No Workshop payloads are redistributed. The normal local path is Steam subscriptions; the repository detects the Steam library instead of assuming `~/.steam` or `~/.local/share/Steam`. SteamCMD remains the dedicated-server install/update mechanism and can prefetch Workshop items where Valve permits it.

## Save protection

`install-local.sh` backs up the entire existing `Saves/` tree before installing the Knox preset unless `KNOX_SKIP_SAVE_BACKUP=1` is deliberately set. It never edits an existing save. Knox Nightmare must be started as a **new world**.

Server backup/restore remains available through:

```bash
./scripts/backup.sh
./scripts/restore.sh <archive.tar.gz>
```

## Repository map

```text
.
├── config/
│   ├── sandbox/base.cfg
│   ├── profiles/{solo,coop,server}.cfg
│   └── server/
├── KnoxNightmare/
│   ├── singleplayer/
│   ├── multiplayer/
│   └── dedicated-server/
├── mods/
├── scripts/
├── docs/
└── .github/workflows/validate.yml
```

## Validation

GitHub CI validates shell syntax, ShellCheck, manifest shape/dependencies/load order, Build 42 preset generation, Lua syntax, all three target profiles, mocked SteamCMD install/update, local Steam path detection, local save backup, SOLO preset installation, CO-OP host configuration, server launch, backup and restore.

Live gameplay still has to be tested on an actual Project Zomboid client/server. Static or mocked CI is never reported as a successful gameplay playtest.

## License

Original scripts and documentation are MIT-licensed. Project Zomboid and all Workshop content remain the property of their respective owners/authors and are not relicensed here.
