# Stable-first Horror Director

Knox Nightmare does not include a hidden custom spawner that cheats threats into view. Its director is a design contract coordinating the approved evolution, weather, sound-scene, special-infected, migration, and periodic-pressure systems.

| State | Player experience | Allowed pressure | Exit condition |
|---|---|---|---|
| **CALM** | Ordinary survival, incomplete information | Ambient world change, scarcity, distant cues | Time, travel, or risk raises tension |
| **UNEASE** | Something feels wrong | Weather shift, ambiguous sound, migration signs | Cue resolves or escalates |
| **WARNING** | Evidence of nearby danger | Repeated cues, worsening visibility, activity change | Player disengages or commits |
| **THREAT** | Immediate tactical danger | Pursuit, interior breach, rare special threat | Escape, containment, or escalation |
| **CRISIS** | Multiple systems compound | Horde/event pressure, bad weather, resource failure | Hard cap, successful escape, or event end |
| **RECOVERY** | Consequences and relief | No new forced crisis; world remains dangerous | A meaningful calm interval completes |

## Rules

- CALM and RECOVERY are required. Constant crisis destroys anticipation.
- Warnings should often be ambiguous and sometimes harmless, but never lie so often that the player stops caring.
- Extreme incidents must be rare enough to remain memorable.
- Noise, light, travel, and shelter choices should create consequences that the player can understand in hindsight.
- A profile may reduce simulation load before weakening darkness, uncertainty, or sound design.
- Only one major behavior authority is enabled by default. Candidates are isolated rather than stacked.
- No event may edit or convert an existing save during installation.

## Implementation boundary

The current build approximates this arc through approved Workshop systems and shared sandbox pressure. It does not claim perfect cross-mod scheduling or a guaranteed state machine. The seven live horror tests in [`PLAYTEST.md`](PLAYTEST.md) are the evidence gate; until they are run, this remains a validated design and configuration, not a claimed gameplay result.
