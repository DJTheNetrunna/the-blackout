# Knox Nightmare on Windows

Knox Nightmare now includes a native **PowerShell** installer for normal single-player and Steam-hosted CO-OP. WSL and Git Bash are not required.

## Easy install

Extract the repository, then double-click:

```text
KnoxNightmare.bat
```

Choose SOLO, hosted CO-OP, Update, or System Check from the menu. The batch launcher uses the native PowerShell implementation without requiring users to type an execution-policy command.

## Requirements

- Windows 10 or Windows 11
- Steam version of Project Zomboid Build 42.20.x
- PowerShell 5.1+ or PowerShell 7+
- Git, or a downloaded ZIP of this repository

Project Zomboid's Windows user data is normally stored under `%USERPROFILE%\Zomboid`. Steam Workshop content is stored under the same Steam library as the game at `steamapps\workshop\content\108600`.

The installer detects the Steam installation from the Windows registry, reads Steam's `libraryfolders.vdf`, and then selects the library that actually contains Project Zomboid. This supports secondary Steam libraries such as `D:\SteamLibrary` instead of assuming the game is on C:.

## SOLO install

Open PowerShell in the repository directory:

```powershell
git clone https://github.com/DJTheNetrunna/the-blackout.git
Set-Location .\the-blackout

.\KnoxNightmare.bat install solo
```

The installer will:

1. locate the actual Project Zomboid Steam library;
2. locate the matching Workshop content directory;
3. detect the Project Zomboid user-data directory;
4. create a ZIP backup of existing `Saves\` plus a SHA-256 sidecar;
5. generate the current Knox Nightmare SOLO preset from the shared Build 42 source;
6. install only `Knox Nightmare - SOLO.cfg` under `Zomboid\Sandbox Presets\`;
7. write Workshop IDs, Mod IDs, and Workshop URLs under `Zomboid\KnoxNightmare\solo\`;
8. report any Workshop items Steam has not downloaded yet;
9. leave every existing save unchanged.

After Steam downloads the missing Workshop subscriptions, launch Project Zomboid and use:

**Solo → Custom Sandbox → Knox Nightmare - SOLO → create a NEW world.**

Do not test the pack by continuing an existing save.

## CO-OP install

```powershell
.\KnoxNightmare.bat install coop
```

In addition to the save-safe preset install, CO-OP installs isolated files:

```text
%USERPROFILE%\Zomboid\Server\KnoxNightmare-Coop.ini
%USERPROFILE%\Zomboid\Server\KnoxNightmare-Coop_SandboxVars.lua
```

Other hosted-server profiles are not overwritten. If an older Knox Nightmare CO-OP config exists and differs, it is backed up first.

Launch Project Zomboid and use **Host → Manage Settings** to select or verify `KnoxNightmare-Coop` before creating a new hosted world.

## Generate profiles without installing

```powershell
.\scripts\windows\Configure-Knox.ps1 solo
.\scripts\windows\Configure-Knox.ps1 coop
.\scripts\windows\Configure-Knox.ps1 server
```

Generated files are placed under `.generated\<target>\` using the same `config\sandbox\base.cfg`, target overlays, and `mods\manifest.tsv` as Linux.

## PowerShell execution policy

If Windows blocks a locally cloned script, you can run a single process with a temporary policy instead of changing the machine-wide setting:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\scripts\windows\Install-Local.ps1 solo
```

Do not disable PowerShell security globally just to run Knox Nightmare.

## Updating

Git-based installations can update safely from the menu or with:

```powershell
.\KnoxNightmare.bat update solo
```

The updater backs up saves before fetching, accepts only the official repository on `main`, refuses a dirty worktree, fast-forwards without rewriting history, and reinstalls the selected preset. ZIP installations remain fully supported for installation but require a fresh ZIP for code updates.

## Advanced path overrides

Normally nothing needs to be configured. For unusual Steam layouts or CI/testing, these environment variables are supported:

```text
KNOX_STEAM_ROOT
KNOX_PZ_STEAMAPPS
KNOX_PZ_GAME_DIR
KNOX_PZ_WORKSHOP_DIR
KNOX_PZ_DATA_DIR
KNOX_BACKUP_ROOT
```

Example:

```powershell
$env:KNOX_PZ_STEAMAPPS = 'D:\SteamLibrary\steamapps'
.\scripts\windows\Detect-Local.ps1
```

## Current Windows scope

- SOLO local install: supported by native PowerShell tooling.
- Steam-hosted CO-OP install: supported by native PowerShell tooling.
- Profile generation: supported.
- Dedicated Windows server deployment: not automated yet; the dedicated-server automation remains Linux-first.
- Real gameplay validation is still separate from CI. CI proves the installer/control flow, not that every Workshop mod behaves perfectly on every PC.
