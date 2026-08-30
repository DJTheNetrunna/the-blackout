# Knox Nightmare — SERVER

SERVER is the dedicated Linux profile.

```bash
cp config/examples/knox-nightmare.env.example .env
./scripts/install.sh
./scripts/generate-config.sh server
./scripts/validate-mods.sh
./scripts/launch-server.sh
```

Default dedicated mods:

- Dynamic Evolution Z
- LED Lantern
- Hark's Horde Night Revamped

The server profile deliberately excludes mods whose Build 42.20 dedicated behavior is still under project validation, even when those same mods are approved for SOLO or CO-OP.

SERVER uses 6% sprinters, population multiplier 0.9 and peak 1.3 to preserve the nocturnal identity while keeping a safer multiplayer simulation baseline.

Administration, backups and restore continue to use the scripts in the repository root.
