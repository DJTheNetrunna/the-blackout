# Easy install and update

The root launchers are the normal way to install Knox Nightmare. The lower-level scripts remain available for development and dedicated-server administration.

## Windows

### Install from a ZIP

1. On GitHub, choose **Code → Download ZIP**.
2. Extract the ZIP completely. Do not run the launcher from inside the compressed-folder preview.
3. Double-click `KnoxNightmare.bat`.
4. Choose `1` for BLIND (recommended), `2` for SOLO, or `3` for hosted CO-OP.
5. Approve the missing-mod helper when prompted, subscribe to every listed Workshop item, and wait for Steam downloads to finish.
6. Launch Project Zomboid and create a new world with the installed Knox Nightmare preset.

Windows uses a process-only PowerShell execution-policy bypass. It does not weaken the machine-wide PowerShell policy.

### Install with Git

```powershell
git clone https://github.com/DJTheNetrunna/the-blackout.git
Set-Location .\the-blackout
.\KnoxNightmare.bat
```

Using Git enables the built-in updater.

## Linux / Steam Deck

Run Steam Deck commands from Desktop Mode.

```bash
git clone https://github.com/DJTheNetrunna/the-blackout.git
cd the-blackout
./knox-nightmare
```

If a ZIP extraction removed executable permissions:

```bash
chmod +x knox-nightmare
./knox-nightmare
```

## Menu

```text
1) Install BLIND (recommended maximum fear)
2) Install SOLO
3) Install hosted CO-OP
4) Update BLIND
5) Update SOLO
6) Update hosted CO-OP
7) System check
8) Exit
```

The install path automatically:

- detects the Steam library containing Project Zomboid;
- backs up existing saves;
- generates the selected profile;
- installs the sandbox preset;
- preserves unrelated worlds and host configurations;
- checks downloaded Workshop items;
- creates one browser-friendly missing-mod page when subscriptions are needed.

## Updating

For Git installations, choose **Update** in the menu or run:

```bash
./knox-nightmare update blind
```

```powershell
.\KnoxNightmare.bat update blind
```

The updater performs these operations in order:

1. Detect Project Zomboid.
2. Back up local saves.
3. Confirm that this is the official Knox Nightmare Git repository on `main`.
4. Refuse to continue if repository files have local changes.
5. Fetch and fast-forward from `origin/main`; it never force-pushes, resets, or discards files.
6. Regenerate and reinstall the selected preset and mod references.
7. Report newly missing Workshop subscriptions.

If the project was downloaded as a ZIP, download a new ZIP and extract it to a new folder. Running the new launcher's normal install option safely refreshes the preset without editing existing saves.

## Command-line shortcuts

Linux / Steam Deck:

```bash
./knox-nightmare install solo
./knox-nightmare install blind
./knox-nightmare install coop
./knox-nightmare update solo
./knox-nightmare doctor
```

Windows:

```powershell
.\KnoxNightmare.bat install solo
.\KnoxNightmare.bat install blind
.\KnoxNightmare.bat install coop
.\KnoxNightmare.bat update solo
.\KnoxNightmare.bat doctor
```

Add `--no-open` on Linux or `-NoOpen` when calling the PowerShell script directly to suppress the Workshop-page prompt during automation.

## If detection fails

Run **System check** first. Advanced path overrides remain documented in [`INSTALL.md`](INSTALL.md) and [`WINDOWS.md`](WINDOWS.md).

Do not point Knox Nightmare at a Build 41 world. Always make a new Build 42.20.x world.
