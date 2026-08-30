# Knox Nightmare — SOLO

SOLO is the highest-horror profile and is designed for the normal Project Zomboid menu, not a dedicated server.

## Install

From the repository root:

```bash
./scripts/detect-local.sh
./scripts/install-local.sh solo
```

Or from this directory:

```bash
./install-local.sh
```

The installer backs up existing saves, installs only the named Knox Nightmare preset, and lists any missing Steam Workshop subscriptions. It does not modify an existing world.

## Normal game UI

After Steam has downloaded the listed Workshop items:

1. Launch **Project Zomboid** normally through Steam.
2. Open **Mods** and verify the SOLO Mod IDs listed in `~/Zomboid/KnoxNightmare/solo/MOD_IDS.txt` are enabled. Keep the generated order; the Special Zombies framework must load before Screamer.
3. Return to the main menu and choose **Solo**.
4. Choose **Custom Sandbox**. Build 42.20's game-mode selection includes the redesigned modes, but Knox Nightmare uses Custom Sandbox so its full v6 settings can be loaded.
5. Choose a vanilla Exclusion Zone spawn location. Knox Nightmare currently adds **no map mod**, deliberately avoiding map conflicts.
6. In **Sandbox Options**, select/load the installed preset **Knox Nightmare - SOLO**. Enable the Advanced view if you want to inspect the exact numeric settings.
7. Continue through character creation and create a **new** world/save. Do not use Continue on an old world to test the pack.
8. Once spawned, exit cleanly after the first test session and reload the same new Knox Nightmare save to verify persistence.

## SOLO default mods

Load order is generated from `mods/manifest.tsv`:

1. Dynamic Evolution Z
2. LED Lantern
3. Surviving the Storm
4. Reactive Sound Events
5. Special Zombies Framework
6. Special Zombies #01 — Screamer
7. Hark's Horde Night Revamped
8. Afraid of Monsters zombies

Reactive Sound Events is intentionally SOLO-approved because its physical scene system is currently single-player-first. Hibernating Zombies remains a SOLO candidate rather than default because its dormancy logic may undermine horde/event behavior when combined with the rest of the pack.

## SOLO horror configuration

- 12% random sprinters, concentrated by the vanilla night-activity rule.
- long pitch-black nights.
- high sound-following distance and migration.
- peak population 1.6 on day 21.
- frequent meta/heli pressure.
- rare/very-rare survival resources.
- very-low vehicle frequency, low fuel, poor condition, frequent locks.
- normal natural weather with full fog/rain intensity; Surviving the Storm makes bad weather mechanically meaningful rather than forcing constant storms.
- no minimap; world map requires light.
- blood-and-saliva Knox infection; 2–3 day mortality.
- vanilla map only.

## Mod configuration

Knox Nightmare does not hard-code undocumented Workshop sandbox keys. For mods that expose their own Sandbox Options pages, their author defaults are the starting configuration unless a value has been verified and recorded. This prevents stale guessed option names from silently doing nothing after B42 updates.

## Performance

For SOLO, begin with the default profile before adding candidate mods. If simulation or FPS degrades, remove candidates first, then lower population peak before weakening night darkness or sound design.

## Save safety

Local backups are written under `~/knox-nightmare/local-backups/` by default with SHA-256 sidecars. The installer only writes a new named preset and Knox Nightmare reference files; it never rewrites existing saves.
