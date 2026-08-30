# Knox Nightmare Sandbox Settings

Build 42 format: `Version/VERSION = 6`.

## Shared source

`config/sandbox/base.cfg` is the shared human-readable preset source. Target overlays are:

- `config/profiles/solo.cfg`
- `config/profiles/coop.cfg`
- `config/profiles/server.cfg`

`configure-knox.sh` merges them and renders both normal menu `.cfg` and server Lua forms.

## Core horror values

| Setting | Shared/target value | Intent |
|---|---:|---|
| `NightDarkness` | 1 | Pitch-black nights |
| `NightLength` | 2 | Long nights |
| `ZombieLore.Speed` | 4 | B42 random-speed band |
| `ZombieLore.SprinterPercentage` | SOLO 12 / CO-OP 8 / SERVER 6 | Rare but meaningful sprinters |
| `ZombieLore.ActiveOnly` | 2 | Night-focused activity |
| `ZombieConfig.FollowSoundDistance` | 200 | Noise is strategically expensive |
| `RedistributeHours` | 6 | Frequent migration |
| `PopulationPeakDay` | 21 | Early escalation |
| `MultiHitZombies` | false | No arcade multi-hit |
| `Map.AllowMiniMap` | false | Navigation uncertainty |

## Scarcity

B42 numeric loot multipliers are used directly. Food is 0.45, medical 0.30, ranged weapons 0.18, ammunition 0.20 and tools 0.35. Loot respawn is disabled.

## Vehicles

Vehicles are very low frequency (`CarSpawnRate=2`), often locked, poor condition, usually nearly empty, and fuel stations can begin empty with a deliberately low fuel range.

## Utilities

Water and electricity use a two-week modifier baseline. Test actual shutoff behavior on a fresh B42.20 world because the game combines category dropdowns and advanced modifier values.

## Weather

Natural climate/fog cycles remain enabled at full visual intensity. The build prefers dangerous *events* over permanent bad weather; SOLO/CO-OP use Surviving the Storm to make rain/snow/thunder consequential.
