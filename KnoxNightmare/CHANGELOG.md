# Changelog

## 2026-09-02 — Easy installer and updater

- Added one interactive Linux/Steam Deck launcher: `./knox-nightmare`.
- Added a double-click Windows launcher: `KnoxNightmare.bat`.
- Added safe Git-based updates with pre-update save backup and fast-forward-only pulls.
- Added system checks and a browser-friendly missing-Workshop-mod helper.
- Kept all advanced profile, server, and development scripts available.

## 2026-08-30 — Native Windows local support

- Added native PowerShell SOLO and hosted CO-OP installers for Windows 10/11.
- Added Steam registry + `libraryfolders.vdf` detection so Project Zomboid can live on C:, D:, or another Steam library.
- Added Windows Project Zomboid data/Workshop detection.
- Added ZIP + SHA-256 backups of existing Windows saves before preset installation.
- Added Windows profile generation from the same shared sandbox and manifest used by Linux.
- Added isolated Windows CO-OP config installation with backup-before-replace behavior.
- Added `windows-latest` CI coverage for PowerShell syntax, Fear Pass generation, save preservation, SOLO install, Workshop detection, and hosted CO-OP config.
- Added platform-support and Windows installation documentation.

## 2026-08-30 — Fear Pass

- Increased SOLO rare sprinters from 12% to 15%.
- Added maintained Bleak World - Horror as the default SOLO visual/fog layer.
- Added Starlit Library + Zombies Crash Through Windows to make interiors less reliably safe.
- Moved Afraid of Monsters from SOLO default to alternate candidate because it conflicts with Bleak World zombie retextures.
- Added researched candidates for Occult Zombies, Knox Acoustics/ZombieBuddy, and ApocalipseBR Projeto Nemesis.
- Put Lingering Whispers on hold after current late-August B42.20 error reports.
- Added explicit conflict-first horror design guidance and Steam discussion announcement draft.
- Expanded CI assertions for the Fear Pass default mod set.

## 2026-08-30 — SOLO / CO-OP / SERVER profiles

- Promoted single-player to a first-class build target.
- Added Linux Steam library and Workshop path detection.
- Added save-safe local installer and local save backups.
- Added shared flat Build 42 v6 sandbox source with target overlays.
- Added generated normal-game `.cfg` presets and hosted/dedicated Lua output.
- Reworked zombie speed to B42 random speed + target-specific sprinter percentages.
- Expanded loot, weather, infection, utilities and vehicle settings.
- Added target-specific mod compatibility statuses and load ordering.
- Added current B42 horror mods to SOLO/CO-OP where compatibility evidence supports them.
- Added normal Steam client Workshop workflow documentation.
- Added separate SOLO, CO-OP and SERVER documentation and live test matrix.

## 2026-08-30 — Knox Nightmare B42 server baseline

- Added initial dedicated-server toolkit, backup/restore, SteamCMD automation and CI.
