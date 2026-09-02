[CmdletBinding()]
param(
    [Parameter(Position=0)]
    [ValidateSet('menu','install','update','doctor','help')]
    [string]$Action = 'menu',

    [Parameter(Position=1)]
    [ValidateSet('solo','coop')]
    [string]$Target = 'solo',

    [switch]$NoOpen
)

$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest
$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot '..\..')).Path
Import-Module (Join-Path $PSScriptRoot 'KnoxNightmare.psm1') -Force

function Show-KnoxHelp {
    @'
Knox Nightmare easy installer

Double-click KnoxNightmare.bat for the menu, or use:
  .\KnoxNightmare.bat install solo
  .\KnoxNightmare.bat install coop
  .\KnoxNightmare.bat update solo
  .\KnoxNightmare.bat doctor

Updates back up saves, safely fast-forward the Git repository, and reinstall
the selected preset. Existing Project Zomboid worlds are never modified.
'@ | Write-Host
}

function Open-KnoxWorkshopHelper {
    param(
        [Parameter(Mandatory)][ValidateSet('solo','coop')][string]$Profile,
        [Parameter(Mandatory)][string[]]$Urls,
        [switch]$SkipOpen
    )
    if ($Urls.Count -eq 0) { return }

    $paths = Get-KnoxLocalPaths
    $helper = Join-Path $paths.DataDirectory "KnoxNightmare\$Profile\INSTALL-MISSING-MODS.html"
    $lines = [System.Collections.Generic.List[string]]::new()
    $lines.Add('<!doctype html><html lang="en"><meta charset="utf-8">')
    $lines.Add('<meta name="viewport" content="width=device-width,initial-scale=1">')
    $lines.Add('<title>Knox Nightmare - Missing Mods</title>')
    $lines.Add('<style>body{font:18px system-ui;max-width:850px;margin:3rem auto;padding:0 1rem;background:#0b0b0d;color:#eee}a{color:#ff4d67}li{margin:.8rem 0}</style>')
    $lines.Add('<h1>Install the missing Knox Nightmare mods</h1>')
    $lines.Add('<p>Open each link, select <strong>Subscribe</strong>, and wait for Steam to finish downloading before starting Project Zomboid.</p><ol>')
    foreach ($url in $Urls) {
        if ($url -match '^https://steamcommunity\.com/sharedfiles/filedetails/\?id=[0-9]+$') {
            $safe = [System.Net.WebUtility]::HtmlEncode($url)
            $lines.Add("<li><a href=`"$safe`">$safe</a></li>")
        }
    }
    $lines.Add('</ol><p>You can close this page after Steam finishes.</p></html>')
    [System.IO.File]::WriteAllLines($helper, $lines, [System.Text.UTF8Encoding]::new($false))
    Write-Host "[knox-nightmare] Missing-mod helper: $helper"

    if (-not $SkipOpen) {
        $answer = Read-Host 'Open the missing-mod page now? [Y/n]'
        if ([string]::IsNullOrWhiteSpace($answer) -or $answer -match '^(y|yes)$') {
            Start-Process -FilePath $helper
        }
    }
}

function Invoke-KnoxInstallEasy {
    param([Parameter(Mandatory)][ValidateSet('solo','coop')][string]$Profile, [switch]$SkipBackup)
    $result = Install-KnoxLocal -Target $Profile -SkipSaveBackup:$SkipBackup
    Write-Host "[knox-nightmare] Installed $($Profile.ToUpper()) preset: $($result.Preset)"
    if ($result.Backup) { Write-Host "[knox-nightmare] Existing saves backed up: $($result.Backup)" }
    Open-KnoxWorkshopHelper -Profile $Profile -Urls @($result.MissingWorkshopUrls) -SkipOpen:$NoOpen
    Write-Host '[knox-nightmare] READY: launch Project Zomboid and create a NEW world.'
}

function Invoke-GitChecked {
    param([Parameter(Mandatory)][string[]]$Arguments)
    & git -C $repoRoot @Arguments
    if ($LASTEXITCODE -ne 0) { throw "Git command failed: git $($Arguments -join ' ')" }
}

function Update-KnoxRepository {
    if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
        throw 'Git is required for automatic updates. Download the newest ZIP from GitHub if this copy was installed without Git.'
    }
    & git -C $repoRoot rev-parse --is-inside-work-tree *> $null
    if ($LASTEXITCODE -ne 0) {
        throw 'This is a ZIP copy, so it cannot self-update. Download the newest ZIP from GitHub, extract it, and run KnoxNightmare.bat again.'
    }

    $branch = (& git -C $repoRoot branch --show-current).Trim()
    if ($branch -ne 'main') { throw "Safe update requires the main branch; current branch is '$branch'." }
    $origin = (& git -C $repoRoot remote get-url origin).Trim()
    if ($origin -notin @('https://github.com/DJTheNetrunna/the-blackout.git','git@github.com:DJTheNetrunna/the-blackout.git')) {
        throw 'Origin is not the official Knox Nightmare repository; refusing to pull.'
    }
    $dirty = (& git -C $repoRoot status --porcelain --untracked-files=normal) -join "`n"
    if ($dirty) { throw 'Repository has local changes. Save or commit them before updating; nothing was pulled.' }

    Write-Host '[knox-nightmare] Checking GitHub for Knox Nightmare updates...'
    Invoke-GitChecked -Arguments @('fetch','origin','main')
    Invoke-GitChecked -Arguments @('merge','--ff-only','origin/main')
}

function Update-KnoxEasy {
    param([Parameter(Mandatory)][ValidateSet('solo','coop')][string]$Profile)
    $paths = Get-KnoxLocalPaths
    $backup = Backup-KnoxLocalSaves -DataDirectory $paths.DataDirectory
    if ($backup) { Write-Host "[knox-nightmare] Existing saves backed up: $backup" }
    Update-KnoxRepository
    Import-Module (Join-Path $PSScriptRoot 'KnoxNightmare.psm1') -Force
    Invoke-KnoxInstallEasy -Profile $Profile -SkipBackup
    Write-Host '[knox-nightmare] UPDATE COMPLETE: code, preset, and mod list are current.'
}

function Test-KnoxSystem {
    Write-Host 'Knox Nightmare system check'
    Write-Host "Repository: $repoRoot"
    if ((Get-Command git -ErrorAction SilentlyContinue) -and (Test-Path (Join-Path $repoRoot '.git'))) {
        $commit = (& git -C $repoRoot rev-parse --short HEAD).Trim()
        Write-Host "Git update: available ($commit)"
    } else {
        Write-Warning 'Git update unavailable (ZIP/manual update mode).'
    }
    $paths = Get-KnoxLocalPaths
    Write-Host 'Project Zomboid: detected'
    Write-Host "Game:       $($paths.GameDirectory)"
    Write-Host "Workshop:   $($paths.WorkshopDirectory)"
    Write-Host "User data:  $($paths.DataDirectory)"
}

function Show-KnoxMenu {
    while ($true) {
        Write-Host ''
        Write-Host 'KNOX NIGHTMARE'
        Write-Host '  1) Install SOLO (recommended)'
        Write-Host '  2) Install hosted CO-OP'
        Write-Host '  3) Update SOLO'
        Write-Host '  4) Update hosted CO-OP'
        Write-Host '  5) System check'
        Write-Host '  6) Exit'
        switch (Read-Host 'Choose [1-6]') {
            '1' { Invoke-KnoxInstallEasy -Profile solo }
            '2' { Invoke-KnoxInstallEasy -Profile coop }
            '3' { Update-KnoxEasy -Profile solo }
            '4' { Update-KnoxEasy -Profile coop }
            '5' { Test-KnoxSystem }
            '6' { return }
            default { Write-Warning 'Choose a number from 1 to 6.' }
        }
    }
}

try {
    switch ($Action) {
        'menu' { Show-KnoxMenu }
        'install' { Invoke-KnoxInstallEasy -Profile $Target }
        'update' { Update-KnoxEasy -Profile $Target }
        'doctor' { Test-KnoxSystem }
        'help' { Show-KnoxHelp }
    }
}
catch {
    [Console]::Error.WriteLine("[knox-nightmare] ERROR: $($_.Exception.Message)")
    exit 1
}
