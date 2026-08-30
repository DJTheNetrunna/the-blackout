# Troubleshooting

## Server will not start

```bash
./scripts/validate-mods.sh
bash -n scripts/*.sh scripts/lib/*.sh
```

Confirm `.env` paths and that `start-server.sh` exists under `PZ_SERVER_DIR`.

## Clients report missing mods

Regenerate configuration from the manifest:

```bash
./scripts/generate-config.sh core
```

Then stop the server cleanly, run:

```bash
./scripts/update-mods.sh
```

and restart.

## A mod broke after an upstream update

1. Stop the server.
2. Back up immediately.
3. Move the mod from `approved/candidate` to `hold` in the manifest on a feature branch.
4. Generate a safer profile.
5. Test on a copy of the world before production.

## World behaves differently after changing mods

Workshop content can add persistent items/zones/data. Removing a mod from the INI does not guarantee a save is clean. Restore the pre-change backup if the world becomes unstable.

## Steam Workshop page validation fails

Steam may rate-limit or block automated requests. `--online` validation is advisory; local manifest/config validation remains authoritative for structure, not upstream runtime behavior.
