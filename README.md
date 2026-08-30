# The Blackout — Knox Nightmare

**Knox Nightmare** is a reproducible Project Zomboid **Build 42.20.x** horror-server profile for Linux. It is designed to make darkness itself a rules change: long pitch-black nights, nocturnal sprinters, dense and mobile zombie pressure, limited information, and optional Workshop layers that can be enabled without redistributing third-party mod files.

## Design goals

- **Vanilla-first horror:** the core nightmare remains playable even if every Workshop mod is disabled.
- **Build 42 stable:** targets the current 42.20 stable line; Build 41 saves/configs are not treated as compatible.
- **Reproducible:** clone → install → generate config → validate → launch.
- **Server-safe:** secrets stay outside Git; `.env.example` contains placeholders only.
- **License-safe:** no Steam Workshop mod payloads are committed. Only IDs, links, dependency/compatibility notes, and automation are stored.
- **Rollback-aware:** backup and restore are first-class operations.
- **Continuously validated:** GitHub Actions runs ShellCheck, Lua parsing, manifest checks, and a mocked lifecycle test.

## Current default mod profile

The default `core` profile enables only mods classified as **approved** in `mods/manifest.tsv`. Everything else is either opt-in (`candidate`) or blocked (`hold` / `rejected`) until compatibility is revalidated.

Current default:

- **DEZ — Dynamic Evolution Z** — Workshop `3676814360`, Mod ID `DynamicEvolutionZ`

The horror experience does **not** depend on this mod: the supplied sandbox configuration already makes zombies nocturnal sprinters and drives a high-pressure population curve.

## Quick start

```bash
git clone https://github.com/DJTheNetrunna/the-blackout.git
cd the-blackout
cp config/examples/knox-nightmare.env.example .env
$EDITOR .env

./scripts/install.sh
./scripts/generate-config.sh core
./scripts/validate-mods.sh
./scripts/launch-server.sh
```

On first launch, Project Zomboid may prompt for the administrator password. Do not store that password in this repository.

## Repository map

```text
.
├── README.md
├── docs/
├── config/
│   ├── examples/
│   ├── sandbox/
│   └── server/
├── mods/
├── scripts/
├── KnoxNightmare/
├── .gitignore
└── LICENSE
```

## Profiles

`./scripts/generate-config.sh <profile>` supports:

- `vanilla` — no Workshop mods; sandbox horror only.
- `core` — approved core mods only. **Default/recommended baseline.**
- `recommended` — approved core + approved utility mods.
- `horror-lab` — core plus candidate horror/visual mods. Intended for test worlds before production.

## Server paths

Defaults are controlled by `.env`:

- Install root: `~/knox-nightmare`
- Dedicated server: `~/knox-nightmare/server`
- PZ cachedir/config/save root: `~/knox-nightmare/Zomboid`
- Backups: `~/knox-nightmare/backups`
- Server name: `KnoxNightmare`

## Build 42 notes

- Dedicated server Steam App ID: `380870`.
- Game/Workshop App ID: `108600`.
- Build 42.20 is the stable baseline for this repository.
- Build 41 worlds are not migrated in place. Preserve them separately and start a new Build 42 world unless a future documented migration path is proven safe.

## Horror philosophy

Knox Nightmare is built around **anticipation, uncertainty, and forced tradeoffs**, not simply maximum zombie counts. Daylight is for movement. Night turns every mistake into a chase. Light sources become infrastructure. Loud weapons are strategic liabilities. Clearing an area never means the wider system has stopped moving.

See [`docs/HORROR-DESIGN.md`](docs/HORROR-DESIGN.md) and [`KnoxNightmare/SANDBOX_SETTINGS.md`](KnoxNightmare/SANDBOX_SETTINGS.md).

## Mods and licensing

Third-party Workshop content remains on Steam. This repository stores only metadata and configuration. See:

- [`mods/MODLIST.md`](mods/MODLIST.md)
- [`mods/manifest.tsv`](mods/manifest.tsv)
- [`docs/MOD-COMPATIBILITY.md`](docs/MOD-COMPATIBILITY.md)

Do **not** commit downloaded Workshop directories unless the author/license explicitly permits redistribution and the inclusion has been separately reviewed.

## Operations

```bash
# Update dedicated server; Workshop content refreshes on launch.
./scripts/update-mods.sh

# Create a timestamped backup + SHA-256 checksum.
./scripts/backup.sh

# Restore a backup after safety checks.
./scripts/restore.sh ~/knox-nightmare/backups/<archive>.tar.gz

# Validate manifest/config and optionally reachable Workshop pages.
./scripts/validate-mods.sh --online

# Run the local mocked lifecycle test (no game download required).
./scripts/test.sh
```

## Multiplayer considerations

- Start with `core`, validate a clean boot, then add candidates one at a time.
- Keep player counts conservative until server tick time and memory pressure are observed.
- Do not add root-file replacement mods to a dedicated server profile.
- Stop the server cleanly before updates/restores. Prefer the in-console `quit` command rather than killing the process.
- Back up before every mod-list or Build update.

## Removal / clean uninstall

1. Stop the server cleanly.
2. Run `./scripts/backup.sh` if the world should be preserved.
3. Remove the generated `WorkshopItems=` and `Mods=` entries or generate the `vanilla` profile.
4. Launch once and verify the world does not depend on removed mod assets.
5. To remove the full local deployment, delete the directory named by `KNOX_ROOT` in `.env`. The Git checkout and backups can be retained independently.

## Known risks

- Workshop authors can update or remove mods without notice.
- Some mods labeled Build 42 may lag the newest 42.20 hotfix.
- Candidate mods are intentionally not enabled in the production baseline.
- This repository can validate static configuration and Workshop metadata, but live gameplay compatibility must be tested against the actual server runtime after each upstream update.

## Documentation

- [Install](docs/INSTALL.md)
- [Server setup](docs/SERVER-SETUP.md)
- [Horror design](docs/HORROR-DESIGN.md)
- [Mod compatibility](docs/MOD-COMPATIBILITY.md)
- [Performance](docs/PERFORMANCE.md)
- [Troubleshooting](docs/TROUBLESHOOTING.md)
- [Rollback](docs/ROLLBACK.md)
- [Architecture](docs/ARCHITECTURE.md)

## License

The automation and original documentation in this repository are MIT-licensed. Third-party Project Zomboid/Workshop content is **not** covered by this license.
