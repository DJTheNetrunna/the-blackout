# CO-OP config

CO-OP configuration is generated rather than hand-maintained:

```bash
scripts/configure-knox.sh coop
```

It merges `config/sandbox/base.cfg` with `config/profiles/coop.cfg`, then derives the hosted Workshop/Mod list from `mods/manifest.tsv`.
