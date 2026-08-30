# Knox Nightmare Horror Design

## Core loop

The experience is built around a clock:

**daylight → scavenging pressure → sunset deadline → nocturnal pursuit → exhausted recovery**

The player should fear being caught far from shelter near sunset more than simply seeing a large horde.

## Vanilla horror layer

The supplied sandbox profile intentionally works without third-party mods:

- `NightDarkness = 1` — pitch black.
- `NightLength = 2` — long nights.
- `ZombieLore.Speed = 1` — active zombies are sprinters.
- `ZombieLore.ActiveOnly = 2` — full activity is concentrated at night.
- house alarms and meta events remain active.
- population rises aggressively and migration happens frequently.
- sound carries far enough that firearms can transform a local fight into an area event.
- minimap is disabled; world map remains available but requires light.

## Why not enable every horror mod by default?

Workshop compatibility is a moving dependency graph. A frightening server that corrupts worlds is not a finished build. Knox Nightmare therefore separates:

- **approved** — suitable for the default profile;
- **candidate** — promising but requires live B42.20 dedicated-server testing;
- **hold** — upstream explicitly warns compatibility is in transition;
- **rejected** — removed, Build 41-only, incompatible, or structurally inappropriate for a dedicated server.

## Escalation path

1. Validate the `vanilla` profile.
2. Enable `core` and test a fresh world.
3. Try `recommended` for approved utilities.
4. Use `horror-lab` only on a disposable test world.
5. Promote a candidate to approved only after clean boot, join, save, restart, and sustained-play testing.

## Fear without cheapness

Recommended balance rules:

- keep multi-hit off;
- preserve escape routes during daytime;
- make night lethal but predictable enough to plan around;
- use audio and migration to create uncertainty rather than spawning enemies inside secured rooms;
- do not stack multiple mods that all rewrite zombie movement unless their compatibility is explicit.
