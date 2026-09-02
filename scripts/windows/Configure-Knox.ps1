[CmdletBinding()]
param(
    [Parameter(Position=0)]
    [ValidateSet('blind','solo','coop','server')]
    [string]$Target = 'solo'
)

$ErrorActionPreference = 'Stop'
Import-Module (Join-Path $PSScriptRoot 'KnoxNightmare.psm1') -Force

$result = Invoke-KnoxConfigure -Target $Target
Write-Host "[knox-nightmare] Generated $Target profile in $($result.OutputDirectory)"
Write-Host "Preset: $($result.Preset)"
Write-Host "Mods:   $($result.ModIds.Count)"
