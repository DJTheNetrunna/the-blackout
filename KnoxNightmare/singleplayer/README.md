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
2. Open **Mods** and verify the SOLO Mod IDs listed in `~/Zomboid/KnoxNightmare/solo/MOD_IDS.txt` are enabled. Keep the generated order; frameworks must load before their dependents.
3. Return to the main menu and choose **Solo**.
4. Choose **Custom Sandbox**.
5. Choose a vanilla Exclusion Zone spawn location. Knox Nightmare currently adds no map mod, deliberately avoiding map conflicts.
6. In **Sandbox Options**, select/load **Knox Nightmare - SOLO**.
7. Continue through character creation and create a **new** world/save. Do not use Continue on an old world to test the pack.
8. Once spawned, exit cleanly after the first test session and reload the same new Knox Nightmare save to verify persistence.

## Fear Pass default mods

Load order is generated from `mods/manifest.tsv`:

1. Starlit Library
2. Dynamic Evolution Z
3. LED Lantern
4. Surviving the Storm
5. Reactive Sound Events
6. Bleak World - Horror
7. Special Zombies Framework
8. Special Zombies #01 — Screamer
9. Hark's Horde Night Revamped
10. Zombies Crash Through Windows

### What changed

**Bleak World - Horror** replaces Afraid of Monsters as the default visual layer. Bleak changes the whole atmosphere—desaturation, fog, darkness treatment, zombie appearance, and screen effects—while Afraid of Monsters remains an alternate candidate because the two zombie retextures should not be stacked.

**Zombies Crash Through Windows** attacks a core safety assumption: reaching a closed room no longer means the chase is over. The mod uses speed-aware window-crash behavior and depends on Starlit Library.

The SOLO rare-sprinter percentage is now **15%**. The goal is not constant sprinting; it is uncertainty. Most zombies let you form a rhythm, then one breaks it.

## Horror configuration

- 15% random sprinters, concentrated by the vanilla night-activity rule.
- long pitch-black nights.
- Bleak World visual/fog layer.
- windows are no longer reliable emergency barriers.
- rare Screamer special infected can create cascading horde events.
- Reactive Sound Events adds unexplained physical/audio scenes.
- HHNR creates periodic large-scale pressure rather than letting a cleared base remain permanently comfortable.
- high sound-following distance and migration.
- peak population 1.6 on day 21.
- frequent meta/heli pressure.
- rare/very-rare survival resources.
- very-low vehicle frequency, low fuel, poor condition, frequent locks.
- dangerous storms through Surviving the Storm.
- no minimap; world map requires light.
- blood-and-saliva Knox infection; 2–3 day mortality.

## Fear-lab candidates

These are researched for future escalation but are not default because they need current-build or combination testing:

- **Occult Zombies** — disturbing custom zombie variants; recent users report B42.20 operation, but appearance/spawn interaction with Bleak World needs isolation testing.
- **Knox Acoustics** — real room/wall/distance sound propagation. Very high immersion potential, but it is pre-release, costs CPU, and depends on ZombieBuddy/Java setup.
- **ApocalipseBR Projeto Nemesis** — an unpredictable stalker/boss with positional audio and pressure spawning. Promising for a late-game "something is hunting me" layer; upstream is primarily MP/dedicated-oriented.
- **Lingering Whispers** — ideal psychological-horror concept, currently held because late-August 2026 users report errors after a game update.
- **They Fear the Light** — near-perfect design fit, but kept on hold until its current compatibility state is reconfirmed.

Do not enable every candidate together. Test one system at a time on a disposable world.

## Performance

The Fear Pass increases visual and event complexity. If FPS/simulation time degrades, remove experimental candidates first. Keep Knox Acoustics disabled until the baseline Fear Pass is stable. Lower population peak before weakening darkness, sound pressure, or interior danger.

## Save safety

Local backups are written under `~/knox-nightmare/local-backups/` by default with SHA-256 sidecars. The installer only writes a new named preset and Knox Nightmare reference files; it never rewrites existing saves.
