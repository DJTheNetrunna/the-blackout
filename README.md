# The Blackout — Knox Nightmare

Knox Nightmare is a reproducible **Project Zomboid Build 42.20.x** survival-horror build with first-class local support on **Linux and Windows**, hosted CO-OP support on both, and Linux-first dedicated-server automation.

## Easiest install

You do not need to run the individual scripts or manually find Steam folders.

### Windows 10/11

1. Download this repository with **Code → Download ZIP** and extract it, or clone it with Git.
2. Double-click **`KnoxNightmare.bat`**.
3. Choose **Install BLIND** (recommended first experience), **Install SOLO**, or **Install hosted CO-OP**.
4. If mods are missing, the installer creates one Workshop helper page. Subscribe to each listed mod and let Steam finish downloading.
5. Launch Project Zomboid and create a **new** Knox Nightmare world.

### Linux / Steam Deck

```bash
git clone https://github.com/DJTheNetrunna/the-blackout.git
cd the-blackout
./knox-nightmare
```

Choose **Install BLIND** from the menu. Steam Deck users should run this in Desktop Mode.

### Updating later

Open the same launcher and choose **Update**, or run:

```bash
./knox-nightmare update blind
```

```powershell
.\KnoxNightmare.bat update blind
```

Automatic updates work in a Git clone. The updater backs up local saves, refuses unsafe Git states, fast-forwards from the official `main` branch, and reinstalls the current preset/mod list. ZIP users can install normally but must download a fresh ZIP for code updates.

See [`docs/EASY-INSTALL.md`](docs/EASY-INSTALL.md) for the short walkthrough and recovery guidance.

| Profile | Purpose | Default philosophy |
|---|---|---|
| **BLIND** | Recommended first local playthrough | Stable SOLO mod set, no world map, spoiler-minimized onboarding |
| **SOLO** | Normal single-player / local game | Maximum atmosphere, audio, rare special infected, darkness and isolation |
| **CO-OP** | Steam/local hosted multiplayer | Horror with mods that have current hosted-MP evidence |
| **SERVER** | Dedicated server | Stability, synchronization, predictable resource use and administration |

All targets share the same Build 42 sandbox source in `config/sandbox/base.cfg`. Small overlays in `config/profiles/` change only the values that need to differ. BLIND deliberately uses the stable SOLO Workshop set; it changes information, navigation, and onboarding—not mod stability. Linux Bash and Windows PowerShell generators consume the same sources and manifest, so Windows is not a separate modpack.

## Platform support

| Platform | SOLO | Hosted CO-OP | Dedicated server automation |
|---|---|---|---|
| Linux desktop | ✅ | ✅ | ✅ |
| Steam Deck / SteamOS | ✅ Linux path | ✅ Linux path | Not a primary target |
| Windows 10/11 | ✅ Native PowerShell | ✅ Native PowerShell | Not automated yet |
| macOS | Experimental/manual | Experimental/manual | No |

See [`docs/PLATFORM-SUPPORT.md`](docs/PLATFORM-SUPPORT.md) and [`docs/WINDOWS.md`](docs/WINDOWS.md).

## Stable-first BLIND horror pass

The recommended profile is built around:

> **Isolation + uncertainty + darkness + unreliable information + sound**

BLIND reveals the premise, not the triggers. Expect long nights, dangerous weather, scarce reliable transport, costly noise, changing infected behavior, and interiors that cannot be treated as permanently cleared. Some threats and event conditions are intentionally undocumented because naming them would remove the uncertainty they are meant to create.

The tuning favors calm intervals, warning signs, escalation, and recovery over constant attacks. Crowd density is kept below the old Fear Pass while sound attraction is stronger. Sprinters are rare enough to remain surprising instead of becoming routine.

Players who need exact technical details can use the opt-in [spoiler document](docs/SPOILERS-HORROR-EVENTS.md). Modpack developers should also read the [compatibility matrix](mods/COMPATIBILITY-MATRIX.md).

## Build 42 horror model

Knox Nightmare uses the current B42 mixed-speed system instead of making every zombie a permanent sprinter:

- `ZombieLore.Speed=4` — random speed band.
- `ZombieLore.SprinterPercentage` — rare and target-adjusted; exact values are in the opt-in spoiler document.
- `ZombieLore.ActiveOnly=2` — full zombie activity is concentrated at night.
- pitch-black, long nights.
- strong sound attraction and frequent migration.
- high but target-adjusted population pressure.
- no minimap; BLIND also removes the world map.
- scarce food, medicine, firearms, ammunition, tools, fuel and working vehicles.
- water/electricity shutoff modifiers target the opening two weeks.
- blood-and-saliva infection with 2–3 day mortality.
- no multi-hit or starter kit.

## Advanced Linux / Steam Deck SOLO install

```bash
git clone https://github.com/DJTheNetrunna/the-blackout.git
cd the-blackout

./knox-nightmare install blind
```

## Advanced Windows SOLO install

Open PowerShell in the repository directory:

```powershell
git clone https://github.com/DJTheNetrunna/the-blackout.git
Set-Location .\the-blackout

.\KnoxNightmare.bat install blind
```

The local installers on both platforms:

1. detect the Steam library actually containing Project Zomboid;
2. detect the matching `steamapps/workshop/content/108600` directory;
3. use the local Project Zomboid data directory (`~/Zomboid` on Linux, `%USERPROFILE%\Zomboid` on Windows);
4. back up existing local saves before installing anything;
5. generate and install `Knox Nightmare - BLIND.cfg` into `Sandbox Presets`;
6. write selected Workshop URLs and Mod IDs under `Zomboid/KnoxNightmare/blind/`;
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
./scripts/configure-knox.sh blind
./scripts/configure-knox.sh coop
./scripts/configure-knox.sh server
```

Windows:

```powershell
.\scripts\windows\Configure-Knox.ps1 solo
.\scripts\windows\Configure-Knox.ps1 blind
.\scripts\windows\Configure-Knox.ps1 coop
.\scripts\windows\Configure-Knox.ps1 server
```

Generated artifacts go under `.generated/<target>/`.

## Workshop and spoiler policy

The installer must reveal Workshop subscriptions so Steam can obtain legitimate mod files, but the normal README does not explain every encounter or trigger. Exact default lists, load order, candidate systems, conflicts, and disclosed mechanics live in [`mods/COMPATIBILITY-MATRIX.md`](mods/COMPATIBILITY-MATRIX.md) and the opt-in [`docs/SPOILERS-HORROR-EVENTS.md`](docs/SPOILERS-HORROR-EVENTS.md).

Candidate/hold/rejected status is target-specific. Strong single-player horror is not globally rejected merely because dedicated-server support is weak, but Stable-first BLIND never enables an unverified candidate by surprise.

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

GitHub CI has separate Linux and Windows jobs. Linux validates shell syntax, all profile generation, SteamCMD/server lifecycle, save backup, BLIND local install and restore. Windows validates PowerShell syntax, Steam/Workshop path detection, BLIND generation, save preservation + ZIP/SHA-256 backup, BLIND installation and hosted CO-OP configuration.

Live gameplay still has to be tested on actual Project Zomboid clients/servers. Static or mocked CI is never reported as a successful gameplay playtest.

## License

Original scripts and documentation are MIT-licensed. Project Zomboid and all Workshop content remain the property of their respective owners/authors and are not relicensed here.
