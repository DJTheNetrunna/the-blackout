# Knox Nightmare — Historical Fear Pass

> Superseded by the 2026-09-02 Stable-first BLIND pass. Current exact settings and threats are in [`SPOILERS-HORROR-EVENTS.md`](SPOILERS-HORROR-EVENTS.md).

## Goal

Make Knox Nightmare frightening because **safe assumptions fail**, not simply because every zombie is faster.

The Fear Pass is built around five independent pressure layers:

1. **Sight:** Bleak World - Horror desaturates and darkens the world, adds fog/screen effects, and changes zombie presentation.
2. **Shelter:** Zombies Crash Through Windows removes the certainty that a closed window ends a chase.
3. **Sound:** Reactive Sound Events creates unexplained scenes; future Knox Acoustics testing can make rooms, walls and distance matter acoustically.
4. **Special infected:** Screamer creates local chain reactions. Occult Zombies and Nemesis remain isolated candidates for stranger threats.
5. **Time/event pressure:** long dark nights + rare random sprinters + HHNR + storms mean the world periodically changes the rules around the player.

## Default SOLO changes

- Historical sprinter percentage: 12% → 15%. Current BLIND/SOLO tuning is **5%** because surprise proved more valuable than frequency at the design level.
- Add **Bleak World - Horror** (`3403923830`, `BleakWorldHorror`).
- Add **Starlit Library** (`3378285185`, `StarlitLibrary`).
- Add **Zombies Crash Through Windows** (`3423871533`, `ZCTWS`).
- Move **Afraid of Monsters** out of default SOLO because it conflicts with Bleak World's zombie retextures; retain it as an alternate candidate.

## High-value candidates

### Occult Zombies

Workshop `3042358369`, test Mod ID `OccultZombieBasetesting`. Recent users report operation on B42.20 and multiplayer. It can add a disturbing "what is that?" layer but should be tested separately from Bleak World because both touch zombie presentation/spawn behavior.

### Knox Acoustics

Workshop `3774192369`, Mod ID `KnoxAcoustics`, dependency ZombieBuddy `3619862853`. It models room size, walls, doorways, windows, distance and direction. This could make large interiors significantly scarier, but it is pre-release and more CPU-intensive, and Java-mod setup is a meaningful operational/security boundary.

### ApocalipseBR Projeto Nemesis

Workshop `3706463588`, Mod ID `ApocalipseBrProjetoNemesis`, dependency `ApocalipseBR_Regioes`. It uses a pressure system to spawn a relentless boss, has positional audio, strong detection/navigation and roars that can attract other zombies. This is the most promising "something is hunting you" candidate, but upstream focuses primarily on multiplayer/dedicated use, so SOLO promotion requires live testing.

### Lingering Whispers

Workshop `2874678809`, Mod ID `Lingering Voices`. The concept is nearly perfect psychological horror—rare fragmented zombie speech—but current late-August 2026 Workshop comments report errors after a game update. Keep on hold until repaired.

### They Fear the Light

Workshop `3592043816`, Mod ID `TheyFearTheLight`. Its day/night behavior and light-pressure design align directly with Knox Nightmare. Official DEZ compatibility exists, so it is now an isolated candidate; current audio/night-state reports still block default promotion.

## Conflict policy

Do not build horror by blindly stacking every scary Workshop item. Replacing the same zombie textures twice, running multiple zombie-speed controllers, or layering several world-climate overrides can produce instability rather than fear.

The default stack therefore chooses one primary system per horror dimension. Candidates are tested individually, then in pairs, before promotion.

## Runtime gate

Before this Fear Pass is called gameplay-verified, test a new SOLO world through: spawn, first building, nightfall, window chase, storm, Screamer encounter, HHNR event, save/exit/reload, and a sustained session with console error review.
