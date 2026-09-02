# Knox Nightmare — BLIND / SOLO

BLIND is the recommended first-playthrough profile. It uses the stable SOLO Workshop set but removes the world map and keeps encounter details out of the onboarding path. SOLO retains the world map for players who want a more documented experience.

## Install — Linux / Steam Deck

From the repository root:

```bash
./scripts/detect-local.sh
./scripts/install-local.sh blind
```

## Install — Windows 10/11

From PowerShell in the repository root:

```powershell
.\scripts\windows\Detect-Local.ps1
.\scripts\windows\Install-Local.ps1 blind
```

Both installers detect the real Steam library, back up existing saves, install only the named Knox Nightmare preset, and list missing Steam Workshop subscriptions. They do not modify an existing world.

BLIND reference files are normally under `Zomboid/KnoxNightmare/blind/` on either platform. Use the `solo` target if you deliberately want its less restrictive navigation overlay.

## Normal game UI

After Steam has downloaded the listed Workshop items:

1. Launch **Project Zomboid** normally through Steam.
2. Open **Mods** and verify the Mod IDs in the generated `KnoxNightmare/blind/MOD_IDS.txt` reference file are enabled. Keep the generated order; frameworks must load before their dependents.
3. Return to the main menu and choose **Solo**.
4. Choose **Custom Sandbox**.
5. Choose a vanilla Exclusion Zone spawn location. Knox Nightmare currently adds no map mod, deliberately avoiding map conflicts.
6. In **Sandbox Options**, select/load **Knox Nightmare - BLIND**.
7. Continue through character creation and create a **new** world/save. Do not use Continue on an old world to test the pack.
8. Once spawned, exit cleanly after the first test session and reload the same new Knox Nightmare save to verify persistence.

## Spoiler boundary

BLIND tells you only what is needed for safe installation: expect darkness, costly sound, poor information, rare speed changes, dangerous weather, unstable shelter, and changing world pressure. It does not explain every event or threat.

If you need exact settings, mod names, or conflict research, opt into [`../../docs/SPOILERS-HORROR-EVENTS.md`](../../docs/SPOILERS-HORROR-EVENTS.md). Reading it before the first BLIND run will reduce the intended uncertainty.

## Fear-lab candidates

These are researched for future escalation but are not default because they need current-build or combination testing:

- **Occult Zombies** — disturbing custom zombie variants; recent users report B42.20 operation, but appearance/spawn interaction with Bleak World needs isolation testing.
- **Knox Acoustics** — real room/wall/distance sound propagation. Very high immersion potential, but it is pre-release, costs CPU, and depends on ZombieBuddy/Java setup.
- **ApocalipseBR Projeto Nemesis** — an unpredictable stalker/boss with positional audio and pressure spawning. Promising for a late-game "something is hunting me" layer; upstream is primarily MP/dedicated-oriented.
- **Lingering Whispers** — ideal psychological-horror concept, currently held because late-August 2026 users report errors after a game update.
- **They Fear the Light** — official DEZ compatibility exists, but current audio/night-state reports keep it isolated until a current live test passes.
- **Reanimating Zombies** — strong corpse false-security concept; held out of defaults until current B42.20 behavior is verified.

Do not enable every candidate together. Test one system at a time on a disposable world.

## Performance

The Fear Pass increases visual and event complexity. If FPS/simulation time degrades, remove experimental candidates first. Keep Knox Acoustics disabled until the baseline Fear Pass is stable. Lower population peak before weakening darkness, sound pressure, or interior danger.

## Save safety

Linux backups are written under `~/knox-nightmare/local-backups/` by default as tar.gz + SHA-256. Windows backups are written under `%USERPROFILE%\knox-nightmare\local-backups\` as ZIP + SHA-256. The installers write a named preset and Knox Nightmare reference files; they never rewrite existing saves.
