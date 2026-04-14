param(
    [string]$HookScript
)

$ErrorActionPreference = 'Stop'

# Optional global off switch.
if ($env:SKIP_LOGGING -eq 'true') {
    exit 0
}

$scriptRel = $HookScript
if ([string]::IsNullOrWhiteSpace($scriptRel)) {
    $scriptRel = $env:HOOK_SCRIPT
}
if ([string]::IsNullOrWhiteSpace($scriptRel)) {
    Write-Output '[session-logger] HookScript and HOOK_SCRIPT are empty, skip.'
    exit 0
}

$pluginRoot = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)
$targetWin = Join-Path $pluginRoot ($scriptRel -replace '/', '\\')

if (-not (Test-Path $targetWin)) {
    Write-Output "[session-logger] target script not found: $targetWin"
    exit 0
}

$bashCmd = Get-Command bash -ErrorAction SilentlyContinue
if (-not $bashCmd) {
    Write-Output '[session-logger] bash not found on PATH, skip.'
    exit 0
}

$targetUnix = $targetWin -replace '\\', '/'
if ($targetUnix -match '^([A-Za-z]):/(.*)$') {
    $drive = $Matches[1].ToLowerInvariant()
    $rest = $Matches[2]
    $targetUnix = "/mnt/$drive/$rest"
}

# Keep UTF-8 when forwarding JSON stdin to bash/WSL to avoid Chinese text turning into '?'.
$utf8NoBom = [System.Text.UTF8Encoding]::new($false)
try {
    [Console]::InputEncoding = $utf8NoBom
    [Console]::OutputEncoding = $utf8NoBom
} catch {
    # Ignore when host does not allow changing console encoding.
}
$OutputEncoding = $utf8NoBom

$inputData = [Console]::In.ReadToEnd()
if ([string]::IsNullOrEmpty($inputData)) {
    $inputData = '{}'
}

$inputData | & bash $targetUnix
exit $LASTEXITCODE
