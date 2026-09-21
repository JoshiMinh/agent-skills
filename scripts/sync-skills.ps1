[CmdletBinding()]
param(
    [string[]]$Target,
    [switch]$DryRun,
    [switch]$Check,
    [switch]$NoPrune,
    [switch]$TakeOverIdenticalCopies
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Get-NormalizedPath([string]$Path) {
    return [IO.Path]::GetFullPath($Path).TrimEnd([IO.Path]::DirectorySeparatorChar, [IO.Path]::AltDirectorySeparatorChar)
}

function Test-PathWithin([string]$Path, [string]$Parent) {
    $normalizedPath = Get-NormalizedPath $Path
    $normalizedParent = (Get-NormalizedPath $Parent) + [IO.Path]::DirectorySeparatorChar
    return $normalizedPath.StartsWith($normalizedParent, [StringComparison]::OrdinalIgnoreCase)
}

function Get-LinkTarget([System.IO.FileSystemInfo]$Item) {
    if ($Item.LinkType -notin @('Junction', 'SymbolicLink') -or -not $Item.Target) {
        return $null
    }

    $targets = @($Item.Target)
    return Get-NormalizedPath ([string]$targets[0])
}

function Test-EquivalentCopy([string]$SourcePath, [string]$CopyPath) {
    $sourceFiles = @(Get-ChildItem -LiteralPath $SourcePath -File -Recurse | ForEach-Object {
        $_.FullName.Substring($SourcePath.Length).TrimStart('\', '/')
    } | Sort-Object)
    $copyFiles = @(Get-ChildItem -LiteralPath $CopyPath -File -Recurse | ForEach-Object {
        $_.FullName.Substring($CopyPath.Length).TrimStart('\', '/')
    } | Sort-Object)
    if (@(Compare-Object $sourceFiles $copyFiles).Count -ne 0) { return $false }

    $textExtensions = @('.md', '.txt', '.json', '.yaml', '.yml', '.ps1', '.sh')
    foreach ($relativePath in $sourceFiles) {
        $sourceFile = Join-Path $SourcePath $relativePath
        $copyFile = Join-Path $CopyPath $relativePath
        if ((Get-FileHash -LiteralPath $sourceFile -Algorithm SHA256).Hash -eq (Get-FileHash -LiteralPath $copyFile -Algorithm SHA256).Hash) {
            continue
        }

        if ([IO.Path]::GetExtension($sourceFile) -notin $textExtensions) { return $false }
        $sourceText = ([IO.File]::ReadAllText($sourceFile)) -replace "`r`n", "`n"
        $copyText = ([IO.File]::ReadAllText($copyFile)) -replace "`r`n", "`n"
        if ($sourceText -ne $copyText) { return $false }
    }

    return $true
}

function Invoke-Action([string]$Description, [scriptblock]$Action) {
    if ($DryRun -or $Check) {
        Write-Output "WOULD $Description"
        return
    }

    & $Action
    Write-Output "DONE  $Description"
}

function Ensure-AntigravityRegistration([psobject]$TargetConfig, [string]$SourcePath) {
    $registrationProperty = $TargetConfig.PSObject.Properties['registration_path']
    if (-not $registrationProperty -or -not $registrationProperty.Value) { return $false }

    $registrationPath = Get-NormalizedPath ([Environment]::ExpandEnvironmentVariables($registrationProperty.Value))
    $registrationDirectory = Split-Path -Parent $registrationPath
    $sourceEntryPath = $SourcePath.Replace('\\', '/')
    if (Test-Path -LiteralPath $registrationPath -PathType Leaf) {
        try {
            $configuration = Get-Content -LiteralPath $registrationPath -Raw | ConvertFrom-Json
        } catch {
            throw "Cannot safely update invalid JSON registration file: $registrationPath"
        }
    } else {
        $configuration = [pscustomobject]@{ entries = @() }
    }

    if (-not $configuration.PSObject.Properties['entries']) {
        $configuration | Add-Member -NotePropertyName entries -NotePropertyValue @()
    }

    $registered = @($configuration.entries | Where-Object {
        $_.path -and ((Get-NormalizedPath $_.path) -eq $SourcePath)
    })
    if ($registered.Count -gt 0) { return $false }

    $description = "register $sourceEntryPath in $registrationPath"
    if ($DryRun -or $Check) {
        Write-Host "WOULD $description"
    } else {
        if (-not (Test-Path -LiteralPath $registrationDirectory -PathType Container)) {
            New-Item -ItemType Directory -Path $registrationDirectory -Force | Out-Null
        }
        $configuration.entries = @($configuration.entries) + [pscustomobject]@{ path = $sourceEntryPath }
        $configuration | ConvertTo-Json -Depth 10 | Set-Content -LiteralPath $registrationPath -Encoding utf8
        Write-Host "DONE  $description"
    }
    return $true
}

$repoRoot = Get-NormalizedPath (Join-Path $PSScriptRoot '..')
$sourceRoot = Get-NormalizedPath (Join-Path $repoRoot 'skills')
$configPath = Join-Path $repoRoot 'config\targets.json'

if (-not (Test-Path -LiteralPath $sourceRoot -PathType Container)) {
    throw "Source skill directory not found: $sourceRoot"
}

$config = Get-Content -LiteralPath $configPath -Raw | ConvertFrom-Json
$availableTargets = @($config.targets.psobject.Properties.Name)
$selectedTargets = if ($Target) {
    @($Target | ForEach-Object { $_ -split ',' } | ForEach-Object { $_.Trim() } | Where-Object { $_ })
} else {
    $availableTargets
}
$unknownTargets = @($selectedTargets | Where-Object { $_ -notin $availableTargets })
if ($unknownTargets) {
    throw "Unknown target(s): $($unknownTargets -join ', '). Available: $($availableTargets -join ', ')"
}

$skills = @(Get-ChildItem -LiteralPath $sourceRoot -Directory | Where-Object {
    Test-Path -LiteralPath (Join-Path $_.FullName 'SKILL.md') -PathType Leaf
})
if ($skills.Count -eq 0) {
    throw "No skill directories containing SKILL.md were found in $sourceRoot"
}

$desiredNames = [Collections.Generic.HashSet[string]]::new([StringComparer]::OrdinalIgnoreCase)
foreach ($skill in $skills) { [void]$desiredNames.Add($skill.Name) }
$drift = $false

foreach ($targetName in $selectedTargets) {
    $targetConfig = $config.targets.PSObject.Properties[$targetName].Value
    $targetPath = Get-NormalizedPath ([Environment]::ExpandEnvironmentVariables($targetConfig.path))
    Write-Output "`n[$targetName] $targetPath"

    if (Ensure-AntigravityRegistration $targetConfig $sourceRoot) { $drift = $true }

    if (-not (Test-Path -LiteralPath $targetPath -PathType Container)) {
        $drift = $true
        Invoke-Action "create directory $targetPath" { New-Item -ItemType Directory -Path $targetPath -Force | Out-Null }
    }

    foreach ($skill in $skills) {
        $sourcePath = Get-NormalizedPath $skill.FullName
        $destination = Join-Path $targetPath $skill.Name

        if (-not (Test-Path -LiteralPath $destination)) {
            $drift = $true
            Invoke-Action "link $destination -> $sourcePath" { New-Item -ItemType Junction -Path $destination -Target $sourcePath | Out-Null }
            continue
        }

        $existing = Get-Item -Force -LiteralPath $destination
        $linkTarget = Get-LinkTarget $existing
        if ($linkTarget -eq $sourcePath) {
            Write-Output "OK    $skill"
            continue
        }

        if ($linkTarget -and (Test-PathWithin $linkTarget $sourceRoot)) {
            $drift = $true
            Invoke-Action "repair managed link $destination -> $sourcePath" {
                Remove-Item -LiteralPath $destination -Force
                New-Item -ItemType Junction -Path $destination -Target $sourcePath | Out-Null
            }
            continue
        }

        if ($TakeOverIdenticalCopies -and -not $linkTarget -and (Test-EquivalentCopy $sourcePath $destination)) {
            $drift = $true
            Invoke-Action "replace identical copy $destination with link -> $sourcePath" {
                Remove-Item -LiteralPath $destination -Recurse -Force
                New-Item -ItemType Junction -Path $destination -Target $sourcePath | Out-Null
            }
            continue
        }

        $drift = $true
        Write-Output "COLLISION $destination exists but is not a managed link. It was left untouched. Use -TakeOverIdenticalCopies only when it is an equivalent copied installation."
    }

    if (Test-Path -LiteralPath $targetPath -PathType Container) {
        foreach ($existing in Get-ChildItem -LiteralPath $targetPath -Directory -Force) {
            if ($desiredNames.Contains($existing.Name)) { continue }

            $linkTarget = Get-LinkTarget $existing
            if (-not $linkTarget -or -not (Test-PathWithin $linkTarget $sourceRoot)) { continue }

            $drift = $true
            if ($NoPrune) {
                Write-Output "STALE $($existing.FullName) (use sync without -NoPrune to remove)"
            } else {
                Invoke-Action "remove stale managed link $($existing.FullName)" { Remove-Item -LiteralPath $existing.FullName -Force }
            }
        }
    }
}

if ($Check -and $drift) {
    exit 1
}
