param([switch]$CheckOnly)
$ErrorActionPreference = 'Stop'

function Test-Node {
    $ErrorActionPreference = 'SilentlyContinue'
    $PSNativeCommandUseErrorActionPreference = $false
    if (-not (Get-Command node -ErrorAction SilentlyContinue)) { return $false }
    $version = & node --version 2>$null
    if ($LASTEXITCODE -ne 0 -or -not $version) { return $false }
    try {
        return [version]($version.TrimStart('v')) -ge [version]'22.12.0' -and [bool](Get-Command npm.cmd -ErrorAction SilentlyContinue)
    } catch { return $false }
}
function Test-Python {
    $ErrorActionPreference = 'SilentlyContinue'
    $PSNativeCommandUseErrorActionPreference = $false
    foreach ($candidate in @('python3', 'python', 'py')) {
        if (Get-Command $candidate -ErrorAction SilentlyContinue) {
            & $candidate -c 'import sys,venv,ensurepip; sys.exit(0 if sys.version_info >= (3,10) else 1)' 2>$null
            if ($LASTEXITCODE -eq 0) { return $true }
        }
    }
    return $false
}
function Invoke-Native {
    param([string]$Command, [string[]]$Arguments)
    $ErrorActionPreference = 'Continue'
    $PSNativeCommandUseErrorActionPreference = $false
    & $Command @Arguments
    if ($LASTEXITCODE -ne 0) { throw "$Command failed (exit code $LASTEXITCODE). See the output above." }
}
function Install-Required($package) {
    if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
        throw 'Install Microsoft App Installer (https://aka.ms/getwinget), then run this command again.'
    }
    Invoke-Native winget @('install', '--id', $package, '--exact', '--source', 'winget')
    $env:Path = [Environment]::GetEnvironmentVariable('Path', 'Machine') + ';' + [Environment]::GetEnvironmentVariable('Path', 'User') + ';' + $env:Path
}

$nodeReady = Test-Node
$pythonReady = Test-Python
$gitReady = [bool](Get-Command git -ErrorAction SilentlyContinue)
Write-Host "Node >=22.12 + npm: $nodeReady / Python >=3.10 + venv: $pythonReady / Git: $gitReady"
if ($CheckOnly) {
    if (-not ($nodeReady -and $pythonReady -and $gitReady)) { throw 'Required programs are missing.' }
    return
}
if (-not $nodeReady) { Install-Required 'OpenJS.NodeJS.LTS' }
if (-not $pythonReady) { Install-Required 'Python.Python.3.13' }
if (-not $gitReady) { Install-Required 'Git.Git' }
if (-not (Test-Node) -or -not (Test-Python) -or -not (Get-Command git -ErrorAction SilentlyContinue)) {
    throw 'Installation completed but programs are not on PATH. Open a new PowerShell window and run this command again.'
}

$repo = 'https://github.com/justpastmarch/mirae-campus.git'
$target = Join-Path (Get-Location) 'mirae-campus'
if (Test-Path -LiteralPath $target) {
    if (-not (Test-Path -LiteralPath (Join-Path $target '.git'))) { throw "$target already exists. Run from another folder." }
    $remote = Invoke-Native git @('-C', $target, 'remote', 'get-url', 'origin')
    if ($remote -ne $repo) { throw 'This folder belongs to a different repository.' }
    $branch = Invoke-Native git @('-C', $target, 'branch', '--show-current')
    if ($branch -ne 'main') { throw 'Switch this repository to main before updating.' }
    $changes = Invoke-Native git @('-C', $target, 'status', '--porcelain')
    if ($changes) { throw 'Local changes exist. Commit or move them before updating.' }
    Invoke-Native git @('-C', $target, 'pull', '--ff-only', 'origin', 'main')
} else {
    Invoke-Native git @('clone', $repo, $target)
}
Push-Location $target
try { Invoke-Native npm.cmd @('start') } finally { Pop-Location }
