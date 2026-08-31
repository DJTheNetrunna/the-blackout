[CmdletBinding()]
param(
    [Parameter(Position=0)]
    [ValidateSet('solo','coop')]
    [string]$Target = 'solo',
    [switch]$SkipSaveBackup
)

$ErrorActionPreference = 'Stop'
Import-Module (Join-Path $PSScriptRoot 'KnoxNightmare.psm1') -Force

$result = Install-KnoxLocal -Target $Target -SkipSaveBackup:$SkipSaveBackup

Write-Host "[knox-nightmare] Installed $($Target.ToUpper()) preset: $($result.Preset)"
if ($result.Backup) { Write-Host "[knox-nightmare] Existing saves backed up: $($result.Backup)" }
Write-Host "[knox-nightmare] No existing Project Zomboid save was modified. Create a NEW Knox Nightmare world."

if ($result.MissingWorkshopUrls.Count -gt 0) {
    Write-Warning "Missing $($result.MissingWorkshopUrls.Count) Workshop item(s). Subscribe in Steam, let Steam finish downloading, then launch Project Zomboid."
    $result.MissingWorkshopUrls | ForEach-Object { Write-Host $_ }
} else {
    Write-Host '[knox-nightmare] All selected Workshop item directories are present.'
}
