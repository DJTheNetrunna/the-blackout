# Knox Nightmare

This directory contains the game-facing layer for the Build 42.20.x variants:

```text
singleplayer/       BLIND — recommended first run; SOLO — documented local horror
multiplayer/        CO-OP — normal hosted multiplayer
dedicated-server/   SERVER — dedicated Linux operation
```

All targets share:

- long pitch-black nights;
- B42 random zombie speed + a controlled sprinter percentage;
- night-focused zombie activity;
- scarcity, migration, strong sound attraction and utility failure;
- no minimap / map requires light;
- no multi-hit or starter kit;
- one target-aware Workshop manifest.

Differences are overlays, not separate unrelated configurations. Use:

```bash
./scripts/configure-knox.sh solo
./scripts/configure-knox.sh blind
./scripts/configure-knox.sh coop
./scripts/configure-knox.sh server
```

Local worlds must be created as new Knox Nightmare saves. Existing worlds are not converted in place.
