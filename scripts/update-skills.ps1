[CmdletBinding()]
param(
    [string[]]$Target,
    [switch]$Check,
    [switch]$NoPrune,
    [switch]$TakeOverIdenticalCopies,
    [switch]$SkipPull
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$repoRoot = [IO.Path]::GetFullPath((Join-Path $PSScriptRoot '..'))
$syncScript = Join-Path $PSScriptRoot 'sync-skills.ps1'

if (-not $SkipPull) {
    & git -C $repoRoot pull --ff-only
    if ($LASTEXITCODE -ne 0) {
        throw 'git pull --ff-only failed; no skill links were changed.'
    }
}

$syncArguments = @('-NoProfile', '-ExecutionPolicy', 'Bypass', '-File', $syncScript)
foreach ($targetName in $Target) {
    $syncArguments += '-Target'
    $syncArguments += $targetName
}
if ($Check) { $syncArguments += '-Check' }
if ($NoPrune) { $syncArguments += '-NoPrune' }
if ($TakeOverIdenticalCopies) { $syncArguments += '-TakeOverIdenticalCopies' }

& powershell @syncArguments
exit $LASTEXITCODE
