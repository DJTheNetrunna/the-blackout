# Knox Nightmare Build 42 Compatibility Matrix

Research snapshot: **2026-08-30**. `mods/manifest.tsv` is the machine-readable source of truth.

Legend: **Yes** = approved default, **Candidate** = optional test-world only, **Hold** = do not currently enable, **No** = rejected for that target.

| Mod | SP | Hosted MP | Dedicated | B42 | Notes |
|---|---|---|---|---|---|
| DEZ — Dynamic Evolution Z | Yes | Yes | Yes | 42.20 | Current server-side evolution logic; avoid documented conflicting zombie-behavior mods. |
| LED Lantern | Yes | Yes | Yes | Yes | Lighting utility; good fit for blackout gameplay. |
| Surviving the Storm | Yes | Yes | Candidate | 42.12–42.20 | Upstream explicitly reviewed B42.20 and reports hosted-MP testing; dedicated feedback still requested. |
| Reactive Sound Events | Yes | Hold | Hold | 42.13+ | Physical scenes are SP-only; current B42.20 comments still request stable MP updates. |
| Special Zombies Framework | Yes | Yes | Candidate | 42.20.2 | Current framework; multiplayer sync documented. Dedicated test remains project gate. |
| Special Zombies — Screamer | Yes | Yes | Candidate | 42.20.2 | Rare screamer; multiplayer state/audio sync documented. |
| Hark's Horde Night Revamped | Yes | Yes | Yes | B42 Stable | Explicit SP/MP/dedicated support; per-player horde sizes can become expensive. |
| Afraid of Monsters zombies | Yes | Candidate | Candidate | B42 | SOLO default visual horror; broader MP remains a project test gate. |
| Hibernating Zombies | Candidate | Hold | No | 41/42 | SP fully supported upstream, MP WIP; also needs interaction testing with horde systems. |
| Authentic Z | Candidate | Candidate | Candidate | B42 | Recent B42.20/server issue reports; no asset redistribution. |
| The Fog [B42] Alpha | Candidate | No | No | B42 | Heavy early-alpha world override; laboratory SOLO only. |
| They Fear the Light | Hold | Hold | Hold | B42 | B42.20 migration warning unresolved. |
| Original Horde Night | Candidate | Candidate | No | B42 | Superseded by HHNR for default profiles. |
| Bleak World | No | No | No | Removed/incompatible | Workshop currently surfaces as removed/incompatible. |

## Why target-specific status matters

Single-player scene/audio mods can be excellent even when they are not safe for dedicated servers. Knox Nightmare therefore does not use one global `approved/rejected` bit. Each target gets its own status in the manifest.

## Sources used for this pass

- Project Zomboid Build 42.20 feature/game-mode documentation.
- Current Steam Workshop descriptions/change notes for Surviving the Storm, Reactive Sound Events, Hibernating Zombies, Hark's Horde Night Revamped, and related mods.
- Current Workshop metadata / indexed author metadata for the Special Zombies framework and Screamer.

Workshop payloads remain on Steam and are never committed here.
