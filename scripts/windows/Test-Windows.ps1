$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest

function Assert-True {
    param([bool]$Condition, [string]$Message)
    if (-not $Condition) { throw "ASSERT FAILED: $Message" }
}

$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot '..\..')).Path
$configure = Join-Path $PSScriptRoot 'Configure-Knox.ps1'
$detect = Join-Path $PSScriptRoot 'Detect-Local.ps1'
$easy = Join-Path $PSScriptRoot 'Knox-Nightmare.ps1'
$tmp = Join-Path ([System.IO.Path]::GetTempPath()) ("knox-nightmare-win-" + [guid]::NewGuid().ToString('N'))

try {
    $steamApps = Join-Path $tmp 'Steam\steamapps'
    $gameDir = Join-Path $steamApps 'common\ProjectZomboid'
    $workshop = Join-Path $steamApps 'workshop\content\108600'
    $dataDir = Join-Path $tmp 'User\Zomboid'
    $existingSave = Join-Path $dataDir 'Saves\Sandbox\ExistingWorld'
    $backupRoot = Join-Path $tmp 'Backups'

    New-Item -ItemType Directory -Force -Path $gameDir, $workshop, $existingSave | Out-Null
    Set-Content -LiteralPath (Join-Path $steamApps 'appmanifest_108600.acf') -Value 'mock' -Encoding utf8
    Set-Content -LiteralPath (Join-Path $existingSave 'map.bin') -Value 'existing-save' -Encoding utf8

    $env:KNOX_PZ_STEAMAPPS = $steamApps
    $env:KNOX_PZ_GAME_DIR = $gameDir
    $env:KNOX_PZ_WORKSHOP_DIR = $workshop
    $env:KNOX_PZ_DATA_DIR = $dataDir
    $env:KNOX_BACKUP_ROOT = $backupRoot

    $detected = (& $detect -Json | ConvertFrom-Json)
    Assert-True ($detected.SteamApps -eq $steamApps) 'Steam library override was not detected'
    Assert-True ($detected.WorkshopDirectory -eq $workshop) 'Workshop directory was not detected'

    & $configure blind | Out-Null
    $blindOut = Join-Path $repoRoot '.generated\blind'
    $blindPreset = Join-Path $blindOut 'Knox Nightmare - BLIND.cfg'
    $blindMods = Join-Path $blindOut 'MOD_IDS.txt'
    Assert-True (Test-Path -LiteralPath $blindPreset) 'BLIND preset was not generated'
    Assert-True ((Get-Content -LiteralPath $blindPreset) -contains 'Map.AllowWorldMap=false') 'BLIND world-map lock missing'
    Assert-True ((Get-Content -LiteralPath $blindPreset) -contains 'ZombieLore.SprinterPercentage=5') 'BLIND rare sprinter percentage missing'

    & $configure solo | Out-Null
    $soloOut = Join-Path $repoRoot '.generated\solo'
    $soloPreset = Join-Path $soloOut 'Knox Nightmare - SOLO.cfg'
    $soloMods = Join-Path $soloOut 'MOD_IDS.txt'
    Assert-True (Test-Path -LiteralPath $soloPreset) 'SOLO preset was not generated'
    Assert-True ((Get-Content -LiteralPath $soloPreset) -contains 'ZombieLore.SprinterPercentage=5') 'SOLO rare sprinter percentage missing'
    Assert-True ((Get-Content -LiteralPath $blindMods -Raw) -eq (Get-Content -LiteralPath $soloMods -Raw)) 'BLIND and SOLO mod selection drifted'
    Assert-True ((Get-Content -LiteralPath $soloMods) -contains 'BleakWorldHorror') 'Bleak World missing from Windows SOLO profile'
    Assert-True ((Get-Content -LiteralPath $soloMods) -contains 'ZCTWS') 'Zombies Crash Through Windows missing from Windows SOLO profile'
    Assert-True (-not ((Get-Content -LiteralPath $soloMods) -contains 'afraidofmonsterszombies')) 'Conflicting Afraid of Monsters leaked into Windows SOLO profile'

    foreach ($id in Get-Content -LiteralPath (Join-Path $blindOut 'WORKSHOP_IDS.txt')) {
        if ($id) { New-Item -ItemType Directory -Force -Path (Join-Path $workshop $id) | Out-Null }
    }
    $missingTestId = (Get-Content -LiteralPath (Join-Path $blindOut 'WORKSHOP_IDS.txt') | Select-Object -First 1)
    Remove-Item -LiteralPath (Join-Path $workshop $missingTestId) -Recurse -Force

    & $easy doctor | Out-Null
    & $easy install blind -NoOpen | Out-Null
    Assert-True ((Get-Content -LiteralPath (Join-Path $existingSave 'map.bin') -Raw).Trim() -eq 'existing-save') 'Existing save was modified'
    Assert-True (Test-Path -LiteralPath (Join-Path $dataDir 'Sandbox Presets\Knox Nightmare - BLIND.cfg')) 'BLIND preset was not installed'
    $helper = Join-Path $dataDir 'KnoxNightmare\blind\INSTALL-MISSING-MODS.html'
    Assert-True (Test-Path -LiteralPath $helper) 'Missing-Workshop helper was not created'
    Assert-True ((Get-Content -LiteralPath $helper -Raw) -match "id=$missingTestId") 'Missing-Workshop helper omitted the missing mod'
    Assert-True (@(Get-ChildItem -LiteralPath $backupRoot -Filter 'local-saves-*.zip').Count -ge 1) 'Local save backup was not created'
    Assert-True (@(Get-ChildItem -LiteralPath $backupRoot -Filter 'local-saves-*.zip.sha256').Count -ge 1) 'Backup SHA256 sidecar was not created'

    & $configure coop | Out-Null
    $coopOut = Join-Path $repoRoot '.generated\coop'
    foreach ($id in Get-Content -LiteralPath (Join-Path $coopOut 'WORKSHOP_IDS.txt')) {
        if ($id) { New-Item -ItemType Directory -Force -Path (Join-Path $workshop $id) | Out-Null }
    }
    & $easy install coop -NoOpen | Out-Null
    Assert-True (Test-Path -LiteralPath (Join-Path $dataDir 'Server\KnoxNightmare-Coop.ini')) 'CO-OP INI was not installed'
    Assert-True (Test-Path -LiteralPath (Join-Path $dataDir 'Server\KnoxNightmare-Coop_SandboxVars.lua')) 'CO-OP sandbox Lua was not installed'

    Write-Host '[knox-nightmare] Windows BLIND + SOLO + CO-OP lifecycle tests passed'
}
finally {
    Remove-Item Env:KNOX_PZ_STEAMAPPS -ErrorAction SilentlyContinue
    Remove-Item Env:KNOX_PZ_GAME_DIR -ErrorAction SilentlyContinue
    Remove-Item Env:KNOX_PZ_WORKSHOP_DIR -ErrorAction SilentlyContinue
    Remove-Item Env:KNOX_PZ_DATA_DIR -ErrorAction SilentlyContinue
    Remove-Item Env:KNOX_BACKUP_ROOT -ErrorAction SilentlyContinue
    if (Test-Path -LiteralPath $tmp) { Remove-Item -LiteralPath $tmp -Recurse -Force }
}
