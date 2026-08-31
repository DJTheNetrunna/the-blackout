# Knox Nightmare Platform Support

| Platform | SOLO | Hosted CO-OP | Dedicated server | Installer status | Notes |
|---|---|---|---|---|---|
| Linux desktop | Supported | Supported | Supported | Native Bash | Primary development platform. |
| Steam Deck / SteamOS | Supported path | Supported path | Not a primary target | Native Bash | Uses Linux/Steam paths; real handheld performance should be tested with the Fear Pass. |
| Windows 10/11 | Supported | Supported | Manual / not automated | Native PowerShell | Steam library, Workshop path, save backup, preset and CO-OP config automation included. |
| macOS | Manual / experimental | Manual / experimental | Not supported by this toolkit | No native installer yet | Project Zomboid has a macOS Steam depot, but this mod stack and installer flow have not been runtime-validated on macOS. |

## What “supported” means

Supported means the repository provides a reproducible installation/configuration path for that target and protects existing saves/configs. It does **not** mean every Workshop mod has been gameplay-tested on every hardware/OS combination.

## Shared cross-platform assets

The following are OS-independent source assets and are used by both Linux and Windows generators:

- `config/sandbox/base.cfg`
- `config/profiles/solo.cfg`
- `config/profiles/coop.cfg`
- `config/profiles/server.cfg`
- `mods/manifest.tsv`

This keeps Windows and Linux on the same horror ruleset and mod selection rather than maintaining separate modpacks.

## Platform-specific tooling

### Linux / Steam Deck

```bash
./scripts/detect-local.sh
./scripts/install-local.sh solo
./scripts/install-local.sh coop
```

### Windows

```powershell
.\scripts\windows\Detect-Local.ps1
.\scripts\windows\Install-Local.ps1 solo
.\scripts\windows\Install-Local.ps1 coop
```

## macOS

Project Zomboid itself is distributed for macOS through Steam, but Knox Nightmare does not yet claim native macOS installer support. A macOS port should add Steam-library detection, `~/Zomboid`/user-data verification, Workshop detection, save-safe preset installation, and a macOS CI/runtime gate before being labeled supported.
