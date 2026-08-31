[CmdletBinding()]
param([switch]$Json)

$ErrorActionPreference = 'Stop'
Import-Module (Join-Path $PSScriptRoot 'KnoxNightmare.psm1') -Force

$paths = Get-KnoxLocalPaths
if ($Json) {
    $paths | ConvertTo-Json -Depth 3
} else {
    Write-Host '[knox-nightmare] Windows local paths'
    Write-Host "SteamApps: $($paths.SteamApps)"
    Write-Host "Game:      $($paths.GameDirectory)"
    Write-Host "Workshop:  $($paths.WorkshopDirectory)"
    Write-Host "Data:      $($paths.DataDirectory)"
}
