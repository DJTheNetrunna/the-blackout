# PROJECT ZOMBOID — KNOX NIGHTMARE
## Autonomous Horror Sandbox + Modpack Builder

### GitHub project homes

Use these repositories as part of the project workflow:

- **Public Project / Server Repo:** `DJTheNetrunna/the-blackout`
  - Primary public-facing Project Zomboid project.
  - Store safe-to-share server configs, documentation, modpack manifests, changelogs, setup guides, website/server material, and reusable automation.
  - Never commit passwords, Steam credentials, private IPs, tokens, private admin data, or secrets.

- **Private Zomboid Hub:** `DJTheNetrunna/zomboid-hub`
  - Private operational/control repo for Project Zomboid work.
  - Store internal notes, experiments, compatibility research, admin tooling, private configuration templates, testing logs, and other material that should not be public.
  - Still do not commit credentials or secrets unless they are represented only as placeholders and excluded securely.

When the agent creates or modifies files, determine whether each artifact belongs in the public `the-blackout` repo, private `zomboid-hub` repo, or both. Keep the two synchronized where appropriate without leaking private information into the public repository.

Before changing either repository:
1. Inspect the existing repository structure.
2. Preserve existing work.
3. Work on the repository's default branch unless a safer feature branch is needed.
4. Use clear commits.
5. Record what changed.
6. Never overwrite unrelated work.

---

You are acting as an expert Project Zomboid Build 42 modpack designer, Linux administrator, Steam Workshop researcher, dedicated-server administrator, survival-horror game designer, GitHub maintainer, and compatibility tester.

Your mission is to transform my Project Zomboid installation into the **scariest, most immersive, oppressive survival-horror experience possible while remaining fair enough to actually play long-term**.

Target feeling:

**Project Zomboid × The Walking Dead × 28 Days Later × Silent Hill × Resident Evil × The Last of Us × Dying Light × STALKER**

Do NOT simply make zombie population absurdly high.

Fear should come from uncertainty, darkness, sound, isolation, weather, scarcity, environmental storytelling, unpredictable infected behavior, dangerous interiors, and the knowledge that nighttime changes the rules.

## Current game target

First detect my exact Project Zomboid version.

Target current stable **Build 42.20.x or newer Build 42 stable**.

Never assume a Build 41 mod works on Build 42.

Before installing anything, verify:
- Build compatibility
- Date last updated
- Workshop ID
- Mod ID
- Dependencies
- Required libraries
- Known incompatibilities
- Single-player compatibility
- Multiplayer compatibility
- Dedicated-server compatibility
- Recent user reports
- Whether the mod is abandoned
- Whether a maintained Build 42 fork exists

Prefer mods explicitly supporting my exact version.

## Safety / rollback

Before changing anything, back up:
- Saves
- Sandbox presets
- Server INI files
- SandboxVars.lua
- Spawn configuration
- Mod configuration
- Workshop configuration
- Existing mod list

Never destroy my current world.

Create a separate preset/server called **KnoxNightmare**.

Create rollback documentation and scripts where practical.

## Horror design philosophy

The world should initially appear survivable, then gradually collapse.

Daylight should provide temporary relief. Night should feel genuinely dangerous. Buildings should be frightening to enter. Forests should not feel completely safe. Driving at night should be dangerous. Power failure should radically change gameplay.

Use unpredictability rather than constant jumpscares. Silence should sometimes be more frightening than noise.

## Visual atmosphere

Favor:
- Deep night darkness
- Limited visibility
- Heavy fog events
- Storms
- Rain
- Overcast skies
- Dense mist
- Dark interiors
- Flashlight dependence
- Vehicle-headlight dependence

Evaluate current Build 42 horror/environment mods such as:
- Bleak World - Horror [B42]
- The Fog [B42], only if current compatibility is acceptable
- Other maintained B42 darkness/weather/lighting mods

Do not stack conflicting shader or weather mods.

## Nightmare night system

Night must mechanically change gameplay.

Research current B42 options including **They Fear the Light** and maintained alternatives.

Desired behavior:
- Day: mostly shamblers/fast shamblers
- Dusk: warning period
- Night: faster, more alert, more aggressive infected
- Small percentage of sprinters
- Dawn: relief

Do NOT make every zombie a permanent sprinter.

Prefer native Build 42 functionality when it is more stable than a mod.

## Special infected

Research current B42-compatible systems for rare:
- Screamers
- Sprinters
- Crawlers hidden among corpses
- Durable infected
- Dormant/hibernating infected
- Highly perceptive infected

A screamer should be an event, not background noise.

Research maintained current versions/forks of:
- Special Zombies #01 - Screamer
- Hibernating Zombies
- Other Build 42 special infected systems

Reject unreliable multiplayer mods unless clearly flagged.

## Building horror

Unknown buildings should be stressful.

Favor:
- Dark interiors
- Door ambushes
- Bathroom/closet ambushes
- Dormant infected
- Broken lighting
- Blood/corpse scenes
- Survivor scenes
- Environmental storytelling
- Rare alarms

Avoid cheap constant spawning directly behind the player.

## Audio horror

Research current B42-compatible audio/meta-event mods.

Desired sounds:
- Distant screaming
- Gunshots
- Crashes
- Dogs
- Sirens
- Doors/impacts
- Zombie activity
- Thunder
- Wind
- Strange environmental sounds
- Radio transmissions

Investigate maintained versions or replacements for systems such as:
- Reactive Sound Events
- Ultimate Horror Sounds

Some sounds should have real world consequences.

## Weather as threat

Research **Surviving the Storm [B41/B42]** or a better maintained B42 equivalent.

Storms, thunder, rain, and fog should affect survival and zombie behavior without happening constantly.

## Sandbox baseline

Inspect current Build 42 sandbox variable names before editing.

Target roughly:
- Population: High
- Peak Population: Very High
- Peak Day: 21–35
- Urban focused distribution; wilderness not completely safe
- Respawn: Low to moderate
- Migration: Enabled
- Memory: Normal to Long
- Hearing: Normal to Good
- Sight: Normal
- Strength: Normal
- Toughness: Normal, with rare stronger variants
- Day speed: Shamblers/Fast Shamblers
- Night speed: Fast Shamblers plus rare Sprinters or equivalent dynamic behavior
- Blood: High
- Corpse danger: Meaningful

## Night

Nights should be extremely dark.

Streetlights provide temporary security before electricity fails. After the grid dies, flashlights, batteries, generators, and headlights become critical.

Night travel should be a major decision.

## Power and water

Water shutoff: random, approximately 0–14 days.

Electricity shutoff: random, approximately 0–14 days.

Generators should exist but not be abundant. Fuel and maintenance should matter.

## Loot

Use scarcity:
- Food: Rare / Extremely Rare
- Medical: Extremely Rare
- Ammo: Extremely Rare
- Firearms: Extremely Rare
- Melee: Rare
- Tools: Rare
- Survival gear: Rare
- Flashlights: Uncommon but obtainable
- Batteries: Uncommon
- Fuel: Scarce
- Vehicle parts: Scarce

Avoid pure-RNG impossibility.

## Vehicles

Configure:
- Low condition
- Low fuel
- Rare working vehicles
- Mechanical problems
- Scarce replacement parts
- Scarce fuel

A working car should feel valuable, not useless.

## Map/navigation

Consider disabling:
- Minimap
- Starting map knowledge
- Automatic map revelation

Physical maps, notes, and landmarks should matter.

## Character survival

No overpowered starter traits, free military arsenal, huge backpack, or automatic survival kit.

XP should be vanilla or slightly slower. Death should matter without becoming pure grind.

## Infection

Keep bites terrifying and lethal. Preserve enough uncertainty that injuries still create drama.

## UI

Avoid mods that reveal:
- Exact enemy locations
- Zombies through walls
- Perfect loot locations
- Constant radar
- Precise danger zones

Immersion > omniscience.

## Modpack rules

Aim for approximately **20–45 carefully chosen mods**.

Organize into:
- Core frameworks
- Horror atmosphere
- Zombie behavior
- Audio
- Weather
- Survival difficulty
- World/environment
- Vehicles
- Immersion
- UI/QoL
- Maps if appropriate
- Performance fixes

Reject redundant or abandoned mods when maintained replacements exist.

## Mod installation

If terminal and Steam access are available, actually install chosen mods.

For every Workshop item record:
- Title
- Workshop URL
- Workshop ID
- Mod ID
- Dependencies
- Load order
- Version/build compatibility
- Installation result

For dedicated servers, generate valid current Build 42 WorkshopItems and Mods configuration.

Do not guess Mod IDs from Workshop titles. Read metadata.

Never expose Steam credentials in shell history.

## Conflict detection

Check for:
- Duplicate libraries
- Duplicate weather systems
- Duplicate zombie speed controllers
- Map conflicts
- Vehicle conflicts
- Shader conflicts
- Sound conflicts
- Obsolete Build 41 mods
- Missing dependencies
- Incorrect Mod IDs
- Workshop IDs incorrectly used as Mod IDs

Resolve conflicts before testing.

## Performance

Watch for:
- Lua errors
- FPS degradation
- Memory growth
- Server tick issues
- Zombie simulation overload
- Sound-event spam
- Excessive vehicle spawning
- Map loading problems

Do not replace horror design with thousands of zombies.

## Horror pacing

### Early game
- Civilization collapsing
- Electricity may still work
- Distant events occur
- Resources limited
- Streets somewhat navigable

### Mid game
- Utilities fail
- Fuel matters
- Night travel becomes very dangerous
- Zombies migrate
- Storms/darkness matter
- Safe locations feel less certain

### Late game
- World feels abandoned
- Supply runs require planning
- Vehicles/generators are precious
- Confidence becomes dangerous

## Playtest

Create a temporary test world and test:
- Daytime urban exploration
- Nighttime urban exploration
- Dark residential building
- Large commercial building
- Thunderstorm
- Heavy fog
- Night driving
- Power outage
- Firearm discharge
- House alarm
- Special infected encounter
- Large migrating group
- Sleeping through nighttime events

Test for Lua/runtime errors before approving.

## Horror score

Rate 1–10:
- Darkness
- Audio tension
- Interior danger
- Night danger
- Scarcity
- Weather
- Zombie unpredictability
- Exploration anxiety
- Immersion
- Performance
- Overall fear

Target **overall fear 9/10+** and **frustration 6/10 or lower**.

## Files to create

Create a project folder such as `KnoxNightmare/` containing:
- README.md
- MODLIST.md
- WORKSHOP_IDS.txt
- MOD_IDS.txt
- DEPENDENCIES.md
- COMPATIBILITY.md
- SANDBOX_SETTINGS.md
- CHANGELOG.md
- ROLLBACK.md
- install-mods.sh if appropriate
- backup.sh
- restore.sh
- Config backups
- Final server/sandbox configuration

## GitHub publishing workflow

After local testing:

### `DJTheNetrunna/the-blackout`
Publish only safe-to-share material such as:
- `README.md`
- `docs/`
- `config/examples/`
- `mods/MODLIST.md`
- Workshop and Mod ID manifests
- Compatibility notes
- Public install/update scripts
- Changelog
- Website/server documentation

### `DJTheNetrunna/zomboid-hub`
Store internal operational material such as:
- Testing logs
- Private admin notes
- Compatibility research
- Experimental configurations
- Internal server-management scripts
- Rollback snapshots/manifests
- Project planning

Never commit secrets to either repo.

If a file contains private operational information, put it only in `zomboid-hub` or sanitize it before publishing to `the-blackout`.

Commit changes with descriptive messages and include a final list of commits/repositories updated.

## Final report

Return:

**KNOX NIGHTMARE STATUS**

- Game version detected
- Number of mods installed
- Number rejected
- Backup location
- Preset/server name
- Major horror systems enabled
- Night behavior
- Special infected behavior
- Weather behavior
- Loot difficulty
- Power/water settings
- Compatibility warnings
- Files changed
- Files created
- GitHub repositories updated
- Commit IDs or links if available
- How to launch

Then provide:

**TOP 10 THINGS THAT WILL PROBABLY KILL ME**

based specifically on the finished configuration.

## Critical rule

Do not merely recommend a mod list and stop.

**Research → verify → backup → download → install → configure → dependency-check → conflict-check → test → document → commit appropriate files to GitHub.**

If one step is blocked, complete everything else and provide the exact command/action needed for the blocked step.

Never claim a mod was downloaded, installed, tested, or working unless it was actually verified.

The objective is not simply to make Project Zomboid harder.

The objective is:

> **Make me afraid to leave the house after dark.**
