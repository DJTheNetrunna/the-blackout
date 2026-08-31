Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$script:RepoRoot = (Resolve-Path (Join-Path $PSScriptRoot '..\..')).Path

function Write-Utf8NoBom {
    param([Parameter(Mandatory)][string]$Path, [Parameter(Mandatory)][string[]]$Lines)
    $parent = Split-Path -Parent $Path
    if ($parent) { New-Item -ItemType Directory -Force -Path $parent | Out-Null }
    [System.IO.File]::WriteAllLines($Path, $Lines, [System.Text.UTF8Encoding]::new($false))
}

function Read-KnoxFlatConfig {
    param([Parameter(Mandatory)][string]$Path)
    if (-not (Test-Path -LiteralPath $Path)) { throw "Missing config: $Path" }
    $result = [ordered]@{}
    foreach ($line in Get-Content -LiteralPath $Path) {
        $trimmed = $line.Trim()
        if (-not $trimmed -or $trimmed.StartsWith('#')) { continue }
        $eq = $trimmed.IndexOf('=')
        if ($eq -lt 1) { continue }
        $key = $trimmed.Substring(0, $eq).Trim()
        $value = $trimmed.Substring($eq + 1).Trim()
        $result[$key] = $value
    }
    return $result
}

function Merge-KnoxConfig {
    param([Parameter(Mandatory)][ValidateSet('solo','coop','server')][string]$Target)
    $base = Read-KnoxFlatConfig (Join-Path $script:RepoRoot 'config\sandbox\base.cfg')
    $overlay = Read-KnoxFlatConfig (Join-Path $script:RepoRoot "config\profiles\$Target.cfg")
    foreach ($key in $overlay.Keys) { $base[$key] = $overlay[$key] }
    return $base
}

function ConvertTo-KnoxLuaValue {
    param([Parameter(Mandatory)][string]$Value)
    if ($Value -match '^(true|false)$' -or $Value -match '^-?[0-9]+(?:\.[0-9]+)?$') { return $Value }
    return '"' + $Value.Replace('\','\\').Replace('"','\"') + '"'
}

function Write-KnoxLua {
    param([Parameter(Mandatory)]$Config, [Parameter(Mandatory)][string]$Path)
    $rootLines = [System.Collections.Generic.List[string]]::new()
    $tables = [ordered]@{}

    foreach ($rawKey in $Config.Keys) {
        $key = if ($rawKey -eq 'Version') { 'VERSION' } else { [string]$rawKey }
        $value = ConvertTo-KnoxLuaValue ([string]$Config[$rawKey])
        $dot = $key.IndexOf('.')
        if ($dot -ge 1) {
            $table = $key.Substring(0, $dot)
            $subkey = $key.Substring($dot + 1)
            if (-not $tables.Contains($table)) { $tables[$table] = [System.Collections.Generic.List[string]]::new() }
            $tables[$table].Add("        $subkey = $value,")
        } else {
            $rootLines.Add("    $key = $value,")
        }
    }

    $lines = [System.Collections.Generic.List[string]]::new()
    $lines.Add('SandboxVars = {')
    foreach ($line in $rootLines) { $lines.Add($line) }
    foreach ($table in $tables.Keys) {
        $lines.Add("    $table = {")
        foreach ($line in $tables[$table]) { $lines.Add($line) }
        $lines.Add('    },')
    }
    $lines.Add('}')
    Write-Utf8NoBom -Path $Path -Lines $lines.ToArray()
}

function Get-KnoxManifestRows {
    param([Parameter(Mandatory)][ValidateSet('solo','coop','server')][string]$Target)
    $manifest = Join-Path $script:RepoRoot 'mods\manifest.tsv'
    $rows = Import-Csv -LiteralPath $manifest -Delimiter "`t"
    return @($rows | Where-Object { $_.$Target -eq 'approved' } | Sort-Object { [int]$_.load_order })
}

function Set-IniValue {
    param([Parameter(Mandatory)][string[]]$Lines, [Parameter(Mandatory)][string]$Key, [Parameter(Mandatory)][string]$Value)
    $pattern = '^' + [regex]::Escape($Key) + '=.*$'
    return @($Lines | ForEach-Object { if ($_ -match $pattern) { "$Key=$Value" } else { $_ } })
}

function Invoke-KnoxConfigure {
    [CmdletBinding()]
    param([Parameter(Mandatory)][ValidateSet('solo','coop','server')][string]$Target)

    $outDir = Join-Path $script:RepoRoot ".generated\$Target"
    New-Item -ItemType Directory -Force -Path $outDir | Out-Null
    $presetName = "Knox Nightmare - $($Target.ToUpper()).cfg"
    $presetPath = Join-Path $outDir $presetName

    $config = Merge-KnoxConfig -Target $Target
    $cfgLines = @($config.Keys | ForEach-Object { "$_=$($config[$_])" })
    Write-Utf8NoBom -Path $presetPath -Lines $cfgLines

    $luaPath = Join-Path $outDir 'KnoxNightmare_SandboxVars.lua'
    Write-KnoxLua -Config $config -Path $luaPath

    $rows = Get-KnoxManifestRows -Target $Target
    $workshop = @($rows | ForEach-Object { $_.workshop_id })
    $mods = @($rows | ForEach-Object { $_.mod_id })
    Write-Utf8NoBom -Path (Join-Path $outDir 'WORKSHOP_IDS.txt') -Lines $workshop
    Write-Utf8NoBom -Path (Join-Path $outDir 'MOD_IDS.txt') -Lines $mods
    Write-Utf8NoBom -Path (Join-Path $outDir 'WORKSHOP_URLS.txt') -Lines @($workshop | ForEach-Object { "https://steamcommunity.com/sharedfiles/filedetails/?id=$_" })

    $iniPath = $null
    if ($Target -ne 'solo') {
        $template = Join-Path $script:RepoRoot 'config\server\KnoxNightmare.ini'
        $iniLines = @(Get-Content -LiteralPath $template)
        $iniLines = Set-IniValue -Lines $iniLines -Key 'WorkshopItems' -Value ($workshop -join ';')
        $iniLines = Set-IniValue -Lines $iniLines -Key 'Mods' -Value ($mods -join ';')
        if ($Target -eq 'coop') {
            $iniLines = Set-IniValue -Lines $iniLines -Key 'PublicName' -Value 'The Blackout - Knox Nightmare CO-OP'
            $iniLines = Set-IniValue -Lines $iniLines -Key 'MaxPlayers' -Value '8'
        }
        $suffix = (Get-Culture).TextInfo.ToTitleCase($Target)
        $iniPath = Join-Path $outDir "KnoxNightmare-$suffix.ini"
        Write-Utf8NoBom -Path $iniPath -Lines $iniLines
    }

    [pscustomobject]@{
        Target = $Target
        OutputDirectory = $outDir
        Preset = $presetPath
        SandboxLua = $luaPath
        Ini = $iniPath
        WorkshopIds = $workshop
        ModIds = $mods
    }
}

function Get-SteamRootCandidates {
    $roots = [System.Collections.Generic.List[string]]::new()
    if ($env:KNOX_STEAM_ROOT) { $roots.Add($env:KNOX_STEAM_ROOT) }

    foreach ($spec in @(
        @{ Path='HKCU:\Software\Valve\Steam'; Name='SteamPath' },
        @{ Path='HKLM:\SOFTWARE\WOW6432Node\Valve\Steam'; Name='InstallPath' },
        @{ Path='HKLM:\SOFTWARE\Valve\Steam'; Name='InstallPath' }
    )) {
        try {
            $value = (Get-ItemProperty -Path $spec.Path -Name $spec.Name -ErrorAction Stop).($spec.Name)
            if ($value) { $roots.Add([string]$value) }
        } catch { }
    }

    $programFilesX86 = ${env:ProgramFiles(x86)}
    if ($programFilesX86) { $roots.Add((Join-Path $programFilesX86 'Steam')) }
    if ($env:ProgramFiles) { $roots.Add((Join-Path $env:ProgramFiles 'Steam')) }

    return @($roots | Where-Object { $_ } | Select-Object -Unique)
}

function Get-KnoxLocalPaths {
    [CmdletBinding()]
    param()

    $candidates = [System.Collections.Generic.List[string]]::new()
    if ($env:KNOX_PZ_STEAMAPPS) { $candidates.Add($env:KNOX_PZ_STEAMAPPS) }

    foreach ($root in Get-SteamRootCandidates) {
        $candidates.Add((Join-Path $root 'steamapps'))
        $vdf = Join-Path $root 'steamapps\libraryfolders.vdf'
        if (Test-Path -LiteralPath $vdf) {
            foreach ($line in Get-Content -LiteralPath $vdf) {
                if ($line -match '"path"\s+"([^"]+)"') {
                    $library = $Matches[1].Replace('\\','\')
                    $candidates.Add((Join-Path $library 'steamapps'))
                }
            }
        }
    }

    $steamApps = $null
    foreach ($candidate in @($candidates | Select-Object -Unique)) {
        if ((Test-Path -LiteralPath (Join-Path $candidate 'appmanifest_108600.acf')) -or
            (Test-Path -LiteralPath (Join-Path $candidate 'common\ProjectZomboid'))) {
            $steamApps = $candidate
            break
        }
    }
    if (-not $steamApps) { throw 'Project Zomboid Steam library not detected. Set KNOX_PZ_STEAMAPPS to the correct steamapps folder and retry.' }

    $gameDir = if ($env:KNOX_PZ_GAME_DIR) { $env:KNOX_PZ_GAME_DIR } else { Join-Path $steamApps 'common\ProjectZomboid' }
    $workshopDir = if ($env:KNOX_PZ_WORKSHOP_DIR) { $env:KNOX_PZ_WORKSHOP_DIR } else { Join-Path $steamApps 'workshop\content\108600' }
    $dataDir = if ($env:KNOX_PZ_DATA_DIR) { $env:KNOX_PZ_DATA_DIR } else { Join-Path $env:USERPROFILE 'Zomboid' }

    [pscustomobject]@{
        SteamApps = $steamApps
        GameDirectory = $gameDir
        WorkshopDirectory = $workshopDir
        DataDirectory = $dataDir
    }
}

function Backup-KnoxLocalSaves {
    [CmdletBinding()]
    param([Parameter(Mandatory)][string]$DataDirectory)
    $saves = Join-Path $DataDirectory 'Saves'
    if (-not (Test-Path -LiteralPath $saves)) { return $null }

    $backupRoot = if ($env:KNOX_BACKUP_ROOT) { $env:KNOX_BACKUP_ROOT } else { Join-Path $env:USERPROFILE 'knox-nightmare\local-backups' }
    New-Item -ItemType Directory -Force -Path $backupRoot | Out-Null
    $stamp = (Get-Date).ToUniversalTime().ToString('yyyyMMdd-HHmmss')
    $archive = Join-Path $backupRoot "local-saves-$stamp.zip"
    Compress-Archive -LiteralPath $saves -DestinationPath $archive -CompressionLevel Optimal
    $hash = (Get-FileHash -Algorithm SHA256 -LiteralPath $archive).Hash.ToLowerInvariant()
    Write-Utf8NoBom -Path "$archive.sha256" -Lines @("$hash  $([IO.Path]::GetFileName($archive))")
    return $archive
}

function Copy-KnoxFileSafely {
    param([Parameter(Mandatory)][string]$Source, [Parameter(Mandatory)][string]$Destination, [Parameter(Mandatory)][string]$BackupCategory)
    $parent = Split-Path -Parent $Destination
    New-Item -ItemType Directory -Force -Path $parent | Out-Null
    if (Test-Path -LiteralPath $Destination) {
        $same = ((Get-FileHash -Algorithm SHA256 -LiteralPath $Source).Hash -eq (Get-FileHash -Algorithm SHA256 -LiteralPath $Destination).Hash)
        if (-not $same) {
            $backupRoot = if ($env:KNOX_BACKUP_ROOT) { $env:KNOX_BACKUP_ROOT } else { Join-Path $env:USERPROFILE 'knox-nightmare\local-backups' }
            $destBackup = Join-Path $backupRoot $BackupCategory
            New-Item -ItemType Directory -Force -Path $destBackup | Out-Null
            $stamp = (Get-Date).ToUniversalTime().ToString('yyyyMMdd-HHmmss')
            Copy-Item -LiteralPath $Destination -Destination (Join-Path $destBackup "$([IO.Path]::GetFileName($Destination)).$stamp.bak")
        }
    }
    Copy-Item -LiteralPath $Source -Destination $Destination -Force
}

function Install-KnoxLocal {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][ValidateSet('solo','coop')][string]$Target,
        [switch]$SkipSaveBackup
    )

    $paths = Get-KnoxLocalPaths
    if (-not (Test-Path -LiteralPath $paths.GameDirectory) -and -not (Test-Path -LiteralPath (Join-Path $paths.SteamApps 'appmanifest_108600.acf'))) {
        throw "Project Zomboid installation not found in $($paths.SteamApps)"
    }

    $backup = $null
    if (-not $SkipSaveBackup) { $backup = Backup-KnoxLocalSaves -DataDirectory $paths.DataDirectory }
    $generated = Invoke-KnoxConfigure -Target $Target

    $presetDir = Join-Path $paths.DataDirectory 'Sandbox Presets'
    $presetDestination = Join-Path $presetDir ([IO.Path]::GetFileName($generated.Preset))
    Copy-KnoxFileSafely -Source $generated.Preset -Destination $presetDestination -BackupCategory 'presets'

    $referenceDir = Join-Path $paths.DataDirectory "KnoxNightmare\$Target"
    New-Item -ItemType Directory -Force -Path $referenceDir | Out-Null
    foreach ($name in @('WORKSHOP_IDS.txt','MOD_IDS.txt','WORKSHOP_URLS.txt')) {
        Copy-Item -LiteralPath (Join-Path $generated.OutputDirectory $name) -Destination (Join-Path $referenceDir $name) -Force
    }

    if ($Target -eq 'coop') {
        $serverDir = Join-Path $paths.DataDirectory 'Server'
        Copy-KnoxFileSafely -Source $generated.Ini -Destination (Join-Path $serverDir 'KnoxNightmare-Coop.ini') -BackupCategory 'server-config'
        Copy-KnoxFileSafely -Source $generated.SandboxLua -Destination (Join-Path $serverDir 'KnoxNightmare-Coop_SandboxVars.lua') -BackupCategory 'server-config'
    }

    $missing = [System.Collections.Generic.List[string]]::new()
    foreach ($id in $generated.WorkshopIds) {
        if (-not (Test-Path -LiteralPath (Join-Path $paths.WorkshopDirectory $id))) {
            $missing.Add("https://steamcommunity.com/sharedfiles/filedetails/?id=$id")
        }
    }
    $missingPath = Join-Path $referenceDir 'MISSING_WORKSHOP_URLS.txt'
    if ($missing.Count -gt 0) {
        Write-Utf8NoBom -Path $missingPath -Lines $missing.ToArray()
    } elseif (Test-Path -LiteralPath $missingPath) {
        Remove-Item -LiteralPath $missingPath -Force
    }

    [pscustomobject]@{
        Target = $Target
        Paths = $paths
        Preset = $presetDestination
        Backup = $backup
        MissingWorkshopUrls = $missing.ToArray()
    }
}

Export-ModuleMember -Function Invoke-KnoxConfigure, Get-KnoxLocalPaths, Backup-KnoxLocalSaves, Install-KnoxLocal
