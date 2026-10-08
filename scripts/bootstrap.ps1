param([switch]$CheckOnly)
$ErrorActionPreference = 'Stop'

function Test-Node {
    if (-not (Get-Command node -ErrorAction SilentlyContinue)) { return $false }
    $version = & node --version
    return $LASTEXITCODE -eq 0 -and [version]($version.TrimStart('v')) -ge [version]'22.12.0' -and [bool](Get-Command npm.cmd -ErrorAction SilentlyContinue)
}
function Test-Python {
    foreach ($candidate in @('python3', 'python', 'py')) {
        if (Get-Command $candidate -ErrorAction SilentlyContinue) {
            & $candidate -c 'import sys,venv,ensurepip; sys.exit(0 if sys.version_info >= (3,10) else 1)' 2>$null
            if ($LASTEXITCODE -eq 0) { return $true }
        }
    }
    return $false
}
function Install-Required($package) {
    if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
        throw 'Install Microsoft App Installer (https://aka.ms/getwinget), then run this command again.'
    }
    & winget install --id $package --exact --source winget
    if ($LASTEXITCODE -ne 0) { throw "Installation failed: $package" }
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
    $remote = & git -C $target remote get-url origin
    if ($LASTEXITCODE -ne 0 -or $remote -ne $repo) { throw 'This folder belongs to a different repository.' }
    $branch = & git -C $target branch --show-current
    if ($LASTEXITCODE -ne 0 -or $branch -ne 'main') { throw 'Switch this repository to main before updating.' }
    $changes = & git -C $target status --porcelain
    if ($LASTEXITCODE -ne 0 -or $changes) { throw 'Local changes exist. Commit or move them before updating.' }
    & git -C $target pull --ff-only origin main
} else {
    & git clone $repo $target
}
if ($LASTEXITCODE -ne 0) { throw 'Could not download the project.' }
Push-Location $target
try { & npm.cmd start } finally { Pop-Location }
