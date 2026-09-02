# Knox Nightmare Build 42 Compatibility Matrix

Research snapshot: **2026-09-02 Stable-first BLIND pass**. `mods/manifest.tsv` is the machine-readable source of truth.

Legend: **Yes** = approved default, **Candidate** = isolated test-world candidate, **Hold** = do not currently enable, **No** = rejected for that target.

| Mod | SP | Hosted MP | Dedicated | B42 | Notes |
|---|---|---|---|---|---|
| Starlit Library | Yes | Candidate | Candidate | 41/42 | Framework required by Zombies Crash Through Windows. |
| DEZ — Dynamic Evolution Z | Yes | Yes | Yes | 42.20 | Current evolution logic; avoid documented conflicting zombie-behavior mods. |
| LED Lantern | Yes | Yes | Yes | Yes | Lighting utility; supports flashlight-dependent blackout play. |
| Surviving the Storm | Yes | Yes | Candidate | 42.12–42.20 | Dangerous weather layer. |
| Reactive Sound Events | Yes | Hold | Hold | 42.13+ | Strong SP physical/audio scene horror; MP remains held. |
| Bleak World - Horror | Yes | Candidate | Candidate | B42 | Default SOLO Fear Pass visual/fog/shader layer. Conflicts with Afraid of Monsters zombie textures. |
| Special Zombies Framework | Yes | Yes | Candidate | 42.20.2 | Framework; multiplayer synchronization documented. |
| Special Zombies — Screamer | Yes | Yes | Candidate | 42.20.2 | Screamer can pull nearby infected and collapse a quiet situation. |
| Hark's Horde Night Revamped | Yes | Yes | Yes | B42 Stable | SP/MP/dedicated support; event intensity needs tuning. |
| Zombies Crash Through Windows | Yes | Candidate | Candidate | 41/42 | Interior danger/safety breaker; requires Starlit Library. |
| Afraid of Monsters zombies | Candidate | Candidate | Candidate | B42 | Alternate visual pack; do not stack with Bleak World. |
| Hibernating Zombies | Candidate | Hold | No | 41/42 | Excellent interior-horror concept; interaction with horde systems still needs testing. |
| Authentic Z | Candidate | Candidate | Candidate | B42 | B42.20/server reports mixed; no asset redistribution. |
| The Fog [B42] Alpha | Candidate | No | No | B42 | Early-alpha world override; isolated SOLO research only. |
| Lingering Whispers | Hold | Hold | Hold | 41/42 | Tagged B42, but current late-August reports show errors after a game update. |
| They Fear the Light | Candidate | Candidate | Candidate | B42 | Official DEZ compatibility exists; current audio/night-state reports still require an isolated B42.20 live test. |
| Original Horde Night | Candidate | Candidate | No | B42 | Superseded by HHNR in defaults. |
| Occult Zombies | Candidate | Candidate | Candidate | B42.20 | Recent users report current SP/MP operation; visual/spawn compatibility needs isolation testing. |
| ZombieBuddy | Candidate | Candidate | Candidate | B42 | Java framework; manual installation/security approval and version matching add complexity. |
| Knox Acoustics | Candidate | Candidate | Hold | 42.20 | Physically modeled acoustics; pre-release and CPU heavier. |
| ApocalipseBR Regioes | Candidate | Candidate | Candidate | 42.14+ | Region/boss framework with sprinter screams; designed for MP and also claims SP support. |
| ApocalipseBR Projeto Nemesis | Candidate | Candidate | Candidate | B42 | Stalker/boss pressure system with positional audio; test before defaulting. |
| Reanimating Zombies | Candidate | Hold | No | B42 | Excellent delayed-corpse false-security layer; current B42.20 and multiplayer behavior is not proven enough for defaults. |
| Starving Zombies | No | No | No | B42 | Thematically strong corpse scent/wind system, but explicitly incompatible with the default DEZ behavior layer. |

## Default SOLO fear-stack principle

Knox Nightmare prefers **orthogonal horror systems**: one visual layer, one window/interior threat layer, one special-zombie framework, one horde/event layer, and one atmospheric sound/scene layer. Stacking multiple mods that replace the same zombie textures or rewrite the same movement system is deliberately avoided.

## Current research notes

- Bleak World - Horror remains active and receives current user feedback in 2026; its page explicitly notes conflict with other zombie retextures.
- Zombies Crash Through Windows is a B41/B42 evolution of Stay Away From Windows with sandbox controls and Starlit Library dependency.
- Occult Zombies has current user reports of functioning on B42.20 and MP but remains non-default because it modifies zombie variants/spawns.
- Knox Acoustics explicitly targets B42.20 and models rooms, walls, portals, distance and VOIP acoustics, but is pre-release and depends on ZombieBuddy.
- Lingering Whispers is conceptually ideal but is held because current comments report errors after the late-August game update.
- They Fear the Light is promoted to an isolated candidate because DEZ now has an official compatibility layer; it is not in a default profile.
- Reanimating Zombies is tracked as a SOLO candidate for the future corpse-horror pass, never silently enabled.

Workshop payloads remain on Steam and are never committed here.
