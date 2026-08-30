# Troubleshooting

## Local Project Zomboid not detected

```bash
./scripts/detect-local.sh
```

If the game is on another Steam library, set the library explicitly:

```bash
PZ_STEAMAPPS_DIR=/path/to/SteamLibrary/steamapps ./scripts/install-local.sh solo
```

## SOLO preset does not appear

Verify the generated preset was installed under your Project Zomboid user-data `Sandbox Presets` directory and relaunch the game after installation.

```bash
./scripts/configure-knox.sh solo
./scripts/install-local.sh solo
```

## Local mods are missing

Check the generated file:

```text
~/Zomboid/KnoxNightmare/solo/MISSING_WORKSHOP_URLS.txt
```

Subscribe through Steam and allow downloads to complete. Do not copy Workshop payloads into the repository.

## CO-OP clients report missing mods

Regenerate/reinstall CO-OP:

```bash
./scripts/install-local.sh coop
```

Verify every player receives the host's Workshop set before joining.

## Dedicated server will not start

```bash
./scripts/validate-mods.sh
bash -n scripts/*.sh scripts/lib/*.sh
./scripts/generate-config.sh server
```

Confirm `.env` paths and that `start-server.sh` exists under `PZ_SERVER_DIR`.

## A mod broke after an upstream update

1. Stop/exit cleanly.
2. Preserve a backup of the affected save/world.
3. Demote the mod for the affected target in `mods/manifest.tsv` on a feature branch.
4. Generate the safer profile.
5. Test on a copy/new disposable world before returning to production.

Removing a mod from a list does not guarantee persistent world data disappears; restore the matching pre-change backup if necessary.

## Steam Workshop online validation fails

Steam can rate-limit automated requests. `validate-mods.sh --online` is advisory; structural validation does not prove current gameplay compatibility.
