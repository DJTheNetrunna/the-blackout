# Sandbox Settings

Canonical file: `config/sandbox/KnoxNightmare_SandboxVars.lua`.

## Horror-critical values

| Setting | Value | Intent |
|---|---:|---|
| `NightDarkness` | 1 | Pitch-black nights |
| `NightLength` | 2 | Long nights |
| `ZombieLore.Speed` | 1 | Sprinter active speed |
| `ZombieLore.ActiveOnly` | 2 | Nocturnal full activity |
| `Zombies` | 3 | High Build 42 population tier |
| `PopulationMultiplier` | 1.2 | B42 high-density baseline |
| `PopulationPeakMultiplier` | 1.6 | Escalation after the opening weeks |
| `PopulationPeakDay` | 21 | Earlier pressure peak |
| `FollowSoundDistance` | 200 | Noise has strategic cost |
| `RedistributeHours` | 6 | Frequent migration |
| `RespawnHours` | 168 | Weekly refill cadence |
| `RespawnMultiplier` | 0.10 | Controlled long-run replenishment |

## Safety valve

If the server is too lethal or cannot maintain tick rate, first lower `PopulationPeakMultiplier`, then `PopulationMultiplier`, before weakening the nocturnal identity.
