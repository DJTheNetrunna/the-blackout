# Mod Compatibility — Build 42.20

Last research pass: **2026-08-30**.

The complete machine-readable classification is in `mods/manifest.tsv`.

## Approved default

### DEZ — Dynamic Evolution Z

- Workshop: `3676814360`
- Mod ID: `DynamicEvolutionZ`
- Classification: `approved / core`
- Upstream states Build 42 compatibility, multiplayer-safe server-side logic, and an optimization layer.
- Upstream also states incompatibility with Wandering, Starving, and Thump with Friends; those should not be added without a new compatibility review.

## Candidate horror additions

### Afraid of Monsters zombies [B42 UPDATED]

- Workshop: `2499635888`
- Mod ID: `afraidofmonsterszombies`
- Upstream explicitly states B42 adaptation.
- Dedicated-server multiplayer behavior is not sufficiently established for production use, so it remains a candidate.

### Horde Night

- Workshop: `2714850307`
- Mod ID: `HordeNight01`
- Upstream documents B42 support and multiplayer behavior.
- Because B42.20 stable is newer than the original B42 update and comments continue to question current behavior, keep it in the lab profile until a live B42.20 dedicated-server cycle passes.

## Approved utility

### LED Lantern

- Workshop: `3627773043`
- Mod ID: `LEDFlashlight`
- Build 42 + Multiplayer-tagged utility.
- Useful for a darkness-centered ruleset without changing core zombie systems.

## Optional visual content

### Authentic Z

- Workshop: `2335368829`
- Full Mod ID: `Authentic Z - Current`
- B42 compatible upstream, but recent B42.20/server comments report issues. Not production-default.
- Upstream explicitly prohibits re-uploading assets. This repository stores metadata only.

## Hold

### They Fear the Light

- Workshop: `3592043816`
- Mod ID: `TheyFearTheLight`
- Strong thematic fit and upstream describes multiplayer support.
- Upstream also posted a B42.20 migration warning. Keep disabled until current stable compatibility is reconfirmed live.

## Rejected

See `mods/REJECTED_MODS.md`. Rejected entries must never be emitted by `generate-config.sh`.
