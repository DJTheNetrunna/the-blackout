# Knox Nightmare Live Playtest Matrix

CI can validate files and control flow, but it cannot claim a real Project Zomboid gameplay pass.

## Required extreme-horror scenarios

These seven scenarios are mandatory before the Stable-first BLIND experience can be called gameplay-verified.

| Scenario | Evidence to record | Status |
|---|---|---|
| Night walk outside a safehouse | sunset departure, navigation choices, return condition, fear/frustration notes | NOT_RUN |
| Enter a dark building | hesitation point, light/noise choice, interior breach behavior | NOT_RUN |
| Sleep through suspicious audio | cue timing, wake/panic behavior, whether the warning was legible | NOT_RUN |
| Drive into heavy fog or storm | visibility, sound, exit-from-vehicle decision, recoverability | NOT_RUN |
| Return to a previously cleared building | evidence of change without obvious scripted repetition | NOT_RUN |
| Power failure during routine activity | light scarcity, route change, safehouse response | NOT_RUN |
| Save, exit, reload, and continue | mod persistence, world integrity, no obvious errors | NOT_RUN |

## BLIND / SOLO

| Test | Status |
|---|---|
| New character creation | NOT_RUN |
| Initial spawn | NOT_RUN |
| Daytime exploration | NOT_RUN |
| Night exploration | NOT_RUN |
| Sleep + wake events | NOT_RUN |
| Dark residential interior | NOT_RUN |
| Large commercial building | NOT_RUN |
| Thunderstorm | NOT_RUN |
| Heavy fog | NOT_RUN |
| Electricity shutoff | NOT_RUN |
| Water shutoff | NOT_RUN |
| Vehicle use | NOT_RUN |
| Screamer encounter | NOT_RUN |
| Reactive Sound Event | NOT_RUN |
| Horde Night | NOT_RUN |
| Clean save/exit/reload | NOT_RUN |
| Mod loading after restart | NOT_RUN |

Record the current [horror scorecard](HORROR-SCORECARD.md) after the seven scenarios. BLIND must be tested before reading the spoiler document.

## CO-OP

Add two-client join/rejoin, cell separation, event synchronization, special-zombie sync, sleep behavior, host restart and Steam Workshop update testing.

## SERVER

Add multiple populated cells, tick/memory observations, update cycle, clean shutdown, backup/restore and rejoin.

A target only becomes gameplay-verified after these tests run on the actual current B42.20.x client/server.
