# Mod Compatibility — Build 42.20

Last research pass: **2026-08-30**.

Knox Nightmare now classifies compatibility separately for **SOLO**, **CO-OP**, and **SERVER**. The authoritative table is [`mods/COMPATIBILITY-MATRIX.md`](../mods/COMPATIBILITY-MATRIX.md); machine-readable values live in `mods/manifest.tsv`.

## Default SOLO-only advantage

`ReactiveSE` is approved for SOLO because its physical scene system is single-player-first. It is held from the default CO-OP/SERVER builds pending stronger current B42.20 multiplayer evidence.

`afraidofmonsterszombies` is also approved for SOLO while remaining a multiplayer candidate.

## Default CO-OP additions

Surviving the Storm, the current Special Zombies framework, Screamer, and Hark's Horde Night Revamped are included where current upstream evidence supports hosted multiplayer. Their dedicated status can still be more conservative.

## Dedicated default

The default SERVER profile is intentionally small:

- Dynamic Evolution Z
- LED Lantern
- Hark's Horde Night Revamped

This reduces synchronization and resource-risk surface while retaining dynamic escalation, light dependence, and event pressure.

## Hold/rejected examples

- They Fear the Light — hold while its B42.20 migration state remains uncertain.
- The Fog Alpha — SOLO candidate only because it forces several world/zombie settings.
- Hibernating Zombies — SOLO candidate; multiplayer is WIP and interaction with horde frameworks needs isolation testing.
- Bleak World — rejected because the Workshop currently surfaces as removed/incompatible.
- root-replacement/B41-only/removed mods remain rejected as appropriate.

No third-party Workshop files are redistributed by this repository.
