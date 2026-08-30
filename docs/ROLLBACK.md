# Rollback

## Before any risky change

```bash
./scripts/backup.sh
```

A backup includes the PZ `Server/` and `Saves/` trees under the configured cachedir and receives a SHA-256 sidecar.

## Restore

```bash
./scripts/restore.sh ~/knox-nightmare/backups/knox-nightmare-YYYYmmdd-HHMMSS.tar.gz
```

The restore script:

1. validates the archive and optional checksum;
2. rejects absolute/path-traversal archive entries;
3. makes a safety backup unless disabled;
4. extracts into the configured cachedir.

The server must be stopped before restore.

## Mod rollback

The mod manifest is version-controlled. Revert the relevant Git commit, regenerate the profile, then restore the matching world backup if the mod change altered persistent world data.
