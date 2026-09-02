# The Blackout — Knox Nightmare

Knox Nightmare is a reproducible **Project Zomboid Build 42.20.x** survival-horror build with first-class local support on **Linux and Windows**, hosted CO-OP support on both, and Linux-first dedicated-server automation.

## Easiest install

You do not need to run the individual scripts or manually find Steam folders.

### Windows 10/11

1. Download this repository with **Code → Download ZIP** and extract it, or clone it with Git.
2. Double-click **`KnoxNightmare.bat`**.
3. Choose **Install SOLO** (recommended) or **Install hosted CO-OP**.
4. If mods are missing, the installer creates one Workshop helper page. Subscribe to each listed mod and let Steam finish downloading.
5. Launch Project Zomboid and create a **new** Knox Nightmare world.

### Linux / Steam Deck

```bash
git clone https://github.com/DJTheNetrunna/the-blackout.git
cd the-blackout
./knox-nightmare
```

Choose **Install SOLO** from the menu. Steam Deck users should run this in Desktop Mode.

### Updating later

Open the same launcher and choose **Update**, or run:

```bash
./knox-nightmare update solo
```

```powershell
.\KnoxNightmare.bat update solo
```

Automatic updates work in a Git clone. The updater backs up local saves, refuses unsafe Git states, fast-forwards from the official `main` branch, and reinstalls the current preset/mod list. ZIP users can install normally but must download a fresh ZIP for code updates.

See [`docs/EASY-INSTALL.md`](docs/EASY-INSTALL.md) for the short walkthrough and recovery guidance.

| Profile | Purpose | Default philosophy |
|---|---|---|
| **SOLO** | Normal single-player / local game | Maximum atmosphere, audio, rare special infected, darkness and isolation |
| **CO-OP** | Steam/local hosted multiplayer | Horror with mods that have current hosted-MP evidence |
| **SERVER** | Dedicated server | Stability, synchronization, predictable resource use and administration |

All three share the same Build 42 sandbox source in `config/sandbox/base.cfg`. Small target overlays in `config/profiles/` change only the values that need to differ. Linux Bash and Windows PowerShell generators consume the same source files and `mods/manifest.tsv`, so Windows is not a separate modpack.

## Platform support

| Platform | SOLO | Hosted CO-OP | Dedicated server automation |
|---|---|---|---|
| Linux desktop | ✅ | ✅ | ✅ |
| Steam Deck / SteamOS | ✅ Linux path | ✅ Linux path | Not a primary target |
| Windows 10/11 | ✅ Native PowerShell | ✅ Native PowerShell | Not automated yet |
| macOS | Experimental/manual | Experimental/manual | No |

See [`docs/PLATFORM-SUPPORT.md`](docs/PLATFORM-SUPPORT.md) and [`docs/WINDOWS.md`](docs/WINDOWS.md).

## Fear Pass

The current SOLO profile is deliberately more aggressive about horror. It uses one strong system per fear dimension instead of blindly stacking mods that overwrite the same mechanics:

- **Bleak World - Horror** for oppressive visuals/fog/zombie presentation.
- **Zombies Crash Through Windows** for interior danger.
- **Reactive Sound Events** for unexplained scene/audio pressure.
- **Special Zombies + Screamer** for rare chain-reaction threats.
- **HHNR** for recurring large-scale pressure.
- **Surviving the Storm** for weather that changes decisions.
- **15% random sprinters** so movement speed remains uncertain without turning the whole population into sprinters.

See `docs/SCARIER-BUILD-PLAN.md` for current candidate research and conflict policy.

## Build 42 horror model

Knox Nightmare uses the current B42 mixed-speed system instead of making every zombie a permanent sprinter:

- `ZombieLore.Speed=4` — random speed band.
- `ZombieLore.SprinterPercentage` — **15% SOLO**, 8% CO-OP, 6% SERVER.
- `ZombieLore.ActiveOnly=2` — full zombie activity is concentrated at night.
- pitch-black, long nights.
- strong sound attraction and frequent migration.
- high but target-adjusted population pressure.
- no minimap, map requires light.
- scarce food, medicine, firearms, ammunition, tools, fuel and working vehicles.
- water/electricity shutoff modifiers target the opening two weeks.
- blood-and-saliva infection with 2–3 day mortality.
- no multi-hit or starter kit.

## Advanced Linux / Steam Deck SOLO install

```bash
git clone https://github.com/DJTheNetrunna/the-blackout.git
cd the-blackout

./knox-nightmare install solo
```

## Advanced Windows SOLO install

Open PowerShell in the repository directory:

```powershell
git clone https://github.com/DJTheNetrunna/the-blackout.git
Set-Location .\the-blackout

.\KnoxNightmare.bat install solo
```

The local installers on both platforms:

1. detect the Steam library actually containing Project Zomboid;
2. detect the matching `steamapps/workshop/content/108600` directory;
3. use the local Project Zomboid data directory (`~/Zomboid` on Linux, `%USERPROFILE%\Zomboid` on Windows);
4. back up existing local saves before installing anything;
5. generate and install `Knox Nightmare - SOLO.cfg` into `Sandbox Presets`;
6. write selected Workshop URLs and Mod IDs under `Zomboid/KnoxNightmare/solo/`;
7. report missing Workshop subscriptions;
8. never change an existing world.

Then subscribe to any reported missing Workshop items in the normal Steam client and follow [`KnoxNightmare/singleplayer/README.md`](KnoxNightmare/singleplayer/README.md).

## CO-OP quick start

Linux / Steam Deck:

```bash
./knox-nightmare install coop
```

Windows:

```powershell
.\KnoxNightmare.bat install coop
```

This performs the same save-safe local installation and additionally installs a separate `KnoxNightmare-Coop.ini` and `KnoxNightmare-Coop_SandboxVars.lua` under the Project Zomboid `Server/` directory. Existing host profiles are left untouched.

See [`KnoxNightmare/multiplayer/README.md`](KnoxNightmare/multiplayer/README.md).

## Dedicated server quick start

The automated dedicated-server path remains Linux-first:

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

Linux:

```bash
./scripts/configure-knox.sh solo
./scripts/configure-knox.sh coop
./scripts/configure-knox.sh server
```

Windows:

```powershell
.\scripts\windows\Configure-Knox.ps1 solo
.\scripts\windows\Configure-Knox.ps1 coop
.\scripts\windows\Configure-Knox.ps1 server
```

Generated artifacts go under `.generated/<target>/`.

## Default Workshop sets

### SOLO — Fear Pass

- Starlit Library
- DEZ — Dynamic Evolution Z
- LED Lantern
- Surviving the Storm
- Reactive Sound Events
- Bleak World - Horror
- Special Zombies Framework
- Special Zombies #01 — Screamer
- Hark's Horde Night Revamped
- Zombies Crash Through Windows

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

No Workshop payloads are redistributed. Normal local installation uses Steam subscriptions. Both platform installers detect the real Steam library instead of assuming one fixed location or drive. SteamCMD remains the Linux dedicated-server install/update mechanism and can prefetch Workshop items where Valve permits it.

## Save protection

Linux `install-local.sh` and Windows `Install-Local.ps1` back up existing saves before installing the Knox preset unless the user explicitly chooses to skip backup. They never edit an existing save. Knox Nightmare must be started as a **new world**.

Server backup/restore remains available through:

```bash
./scripts/backup.sh
./scripts/restore.sh <archive.tar.gz>
```

## Validation

GitHub CI now has separate Linux and Windows jobs. Linux validates shell syntax, manifest/profile generation, SteamCMD/server lifecycle, save backup, local install and restore. Windows validates PowerShell syntax, Steam/Workshop path detection, Fear Pass preset generation, save preservation + ZIP/SHA-256 backup, SOLO installation and hosted CO-OP configuration.

Live gameplay still has to be tested on actual Project Zomboid clients/servers. Static or mocked CI is never reported as a successful gameplay playtest.

## License

Original scripts and documentation are MIT-licensed. Project Zomboid and all Workshop content remain the property of their respective owners/authors and are not relicensed here.
