# Installation

## Requirements

- 64-bit Linux host
- `bash`, `tar`, `gzip`
- `curl` or `wget`
- enough storage for Project Zomboid Dedicated Server, saves, backups, and Workshop content
- outbound HTTPS access to Steam/Valve services

The installer downloads Valve SteamCMD into the deployment root rather than assuming a distro-specific SteamCMD package.

## Install

```bash
git clone https://github.com/DJTheNetrunna/the-blackout.git
cd the-blackout
cp config/examples/knox-nightmare.env.example .env
$EDITOR .env
./scripts/install.sh
```

`install.sh` will:

1. create the local deployment directories;
2. obtain SteamCMD if needed;
3. install/update Project Zomboid Dedicated Server App `380870`;
4. generate the selected server configuration;
5. copy the sandbox config into the configured cachedir;
6. run static validation.

## First boot

```bash
./scripts/launch-server.sh
```

If an administrator password is requested, enter it interactively. Do not place it in `.env`, shell history, or Git.

## Firewall

Build 42 dedicated servers commonly use UDP `16261` and `16262`. Open/forward them only when hosting beyond the LAN, and match your actual `KnoxNightmare.ini` values.

## Fedora note

The repository does not require the RPM Fusion SteamCMD package; the bundled installer path avoids distro packaging differences.

## Upgrade from Build 41

Do not overwrite a Build 41 world with Build 42. Preserve the B41 cachedir as an archive and create a fresh Build 42.20 world unless a specifically tested migration procedure is documented later.
