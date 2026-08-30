# Performance

## Baseline

Start with the `core` profile and measure before adding candidates.

Recommended practices:

- SSD/NVMe storage for the server and cachedir.
- Keep backups on a separate path if possible.
- Avoid stacking multiple zombie-movement/migration frameworks.
- Keep `ZombiesCountBeforeDelete` at the Build 42 default unless a verified reason exists to change it.
- Increase JVM heap deliberately rather than consuming all host memory; leave RAM for Linux filesystem cache and other services.
- Test worst-case behavior with multiple players in different populated cells.

## Population tuning

Build 42 population multipliers differ from older B41-era guides. The supplied profile uses B42-style values and keeps the advanced population keys under `ZombieConfig`.

If tick time becomes unstable, reduce in this order:

1. `PopulationPeakMultiplier`
2. `PopulationMultiplier`
3. `FollowSoundDistance`
4. frequency/size of event mods
5. number of optional content mods

Do not fix performance by disabling backups, clean shutdowns, or validation.
