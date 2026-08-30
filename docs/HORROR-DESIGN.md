# Knox Nightmare Horror Design

## Core loop

**daylight → scavenging pressure → sunset deadline → nocturnal pursuit → exhausted recovery**

Fear is driven by uncertainty, darkness, sound, scarcity, bad weather, interior risk, and periodic events rather than simply multiplying zombie counts.

## Shared vanilla layer

The pack remains frightening even if Workshop mods are temporarily disabled:

- pitch-black, long nights;
- B42 random zombie speed with a target-specific sprinter percentage;
- full zombie activity concentrated at night;
- frequent migration and long sound attraction distance;
- no minimap and a world map that requires light;
- scarce medicine, firearms, ammunition, tools, fuel and working vehicles;
- no starter kit and no multi-hit;
- utilities can fail during the opening weeks.

Using B42 `Speed=4` plus `SprinterPercentage` avoids the old all-sprinter baseline. SOLO uses 12%, CO-OP 8%, SERVER 6%.

## Profile philosophy

### SOLO

Maximum atmosphere. SP-first audio/physical-scene mods can be approved even when multiplayer support is incomplete.

### CO-OP

Keep the same night identity, but require current hosted-MP evidence and reduce simulation pressure.

### SERVER

Use the smallest dedicated-safe default mod surface and conservative population/sprinter pressure. Candidate mods require actual dedicated testing before promotion.

## Candidate rules

Compatibility is target-specific:

- `approved` — in that target's default build;
- `candidate` — generated only by a `*-lab` profile and tested on a disposable world;
- `hold` — known current uncertainty; not generated;
- `rejected` — inappropriate/incompatible for that target.

A great single-player horror mod is therefore not globally rejected merely because it is unreliable on a dedicated server.

## Fear without cheapness

- keep multi-hit off;
- preserve daytime escape routes;
- make darkness dangerous but learnable;
- let sounds create consequences;
- use rare screamers/horde events as incidents, not constant background spam;
- do not stack multiple unverified zombie-control frameworks;
- make resources scarce, not mathematically impossible.
