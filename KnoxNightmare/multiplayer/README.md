# Knox Nightmare — CO-OP

CO-OP targets Project Zomboid's normal **Host** workflow / Steam-hosted games on Linux and Windows.

## Install — Linux / Steam Deck

```bash
./scripts/install-local.sh coop
```

## Install — Windows 10/11

```powershell
.\scripts\windows\Install-Local.ps1 coop
```

Both installers detect the real Steam library, back up local saves, generate the CO-OP sandbox from the same shared base as SOLO/SERVER, and install isolated Knox Nightmare host files.

Linux normally receives:

```text
~/Zomboid/Sandbox Presets/Knox Nightmare - COOP.cfg
~/Zomboid/Server/KnoxNightmare-Coop.ini
~/Zomboid/Server/KnoxNightmare-Coop_SandboxVars.lua
~/Zomboid/KnoxNightmare/coop/{WORKSHOP_IDS,MOD_IDS,WORKSHOP_URLS}.txt
```

Windows normally receives the equivalent files under:

```text
%USERPROFILE%\Zomboid\Sandbox Presets\
%USERPROFILE%\Zomboid\Server\
%USERPROFILE%\Zomboid\KnoxNightmare\coop\
```

Existing host/server settings with other names are untouched. If a previous KnoxNightmare-Coop file exists and differs, it is backed up before replacement.

## Normal Host UI

1. Subscribe to missing Workshop items in Steam.
2. Launch Project Zomboid.
3. Choose **Host**.
4. Open **Manage Settings** and select the Knox Nightmare CO-OP server profile if shown; otherwise create/select `KnoxNightmare-Coop` and verify its generated files are under the local `Zomboid/Server/` directory.
5. Verify the Mods/Workshop list matches the generated CO-OP reference files.
6. Start a **new** hosted world rather than attaching Knox Nightmare to an old campaign.
7. Invite players through Steam after the host reaches the world.

## CO-OP default mods

- Dynamic Evolution Z
- LED Lantern
- Surviving the Storm
- Special Zombies Framework
- Special Zombies #01 — Screamer
- Hark's Horde Night Revamped

Reactive Sound Events is held out of default B42.20 CO-OP because current upstream/community discussion still asks for stable B42.20 MP updates. Afraid of Monsters remains a CO-OP candidate.

## CO-OP tuning

- 8% sprinters.
- peak population 1.4.
- MaxPlayers generated as 8 for the hosted profile.
- HHNR horde size applies per player; keep event sizes conservative because four players can multiply the total active horde substantially.

## Synchronization gate

Before promoting a candidate, test two clients: join, separate cells, special event, sleep, save, clean host shutdown, restart/rejoin, mod update, and rollback.
