# RevvUp — Publish all repos to ChamathDilshanC ONLY
# Prerequisites: gh auth login  ->  account ChamathDilshanC
# Usage:  .\scripts\setup-github-chamath.ps1

$ErrorActionPreference = "Stop"
$Root = Split-Path -Parent $PSScriptRoot
Set-Location $Root

$Owner = "ChamathDilshanC"
$GitName = "Chamath Dilshan"
$GitEmail = "150304779+ChamathDilshanC@users.noreply.github.com"

$ActiveUser = gh api user --jq .login
if ($ActiveUser -ne $Owner) {
    Write-Host "ERROR: Logged in as '$ActiveUser'. Run: gh auth login  (select $Owner)" -ForegroundColor Red
    exit 1
}

gh auth setup-git | Out-Null

function Invoke-GitCommit {
    param([string]$Path, [string]$Message)
    Push-Location $Path
    if (git status --porcelain) {
        git add -A
        git -c "user.name=$GitName" -c "user.email=$GitEmail" commit -m $Message
    }
    Pop-Location
}

function Publish-Submodule {
    param([string]$Path, [string]$RepoName, [string]$Description)
    Push-Location $Path
    $remote = "https://github.com/${Owner}/${RepoName}.git"
    if (git remote | Select-String "^origin$") { git remote set-url origin $remote }
    else { git remote add origin $remote }

    $exists = $false
    try { gh repo view "${Owner}/${RepoName}" | Out-Null; $exists = $true } catch { }

    if (-not $exists) {
        gh repo create "${Owner}/${RepoName}" --public --description $Description
    }
    git push -u origin main --force
    Write-Host "OK: ${Owner}/${RepoName}" -ForegroundColor Green
    Pop-Location
}

Write-Host "=== revvup-frontend ===" -ForegroundColor Cyan
Invoke-GitCommit "$Root\revvup-frontend" "docs: update main-application links"
Publish-Submodule "$Root\revvup-frontend" "revvup-frontend" "RevvUp mobile — React Native, Expo, NativeWind"

Write-Host "=== revvup-backend ===" -ForegroundColor Cyan
Invoke-GitCommit "$Root\revvup-backend" "docs: update main-application links"
Publish-Submodule "$Root\revvup-backend" "revvup-backend" "RevvUp API — FastAPI serverless on Vercel"

Write-Host "=== main-application ===" -ForegroundColor Cyan
@"
[submodule "revvup-frontend"]
	path = revvup-frontend
	url = https://github.com/ChamathDilshanC/revvup-frontend.git
[submodule "revvup-backend"]
	path = revvup-backend
	url = https://github.com/ChamathDilshanC/revvup-backend.git
"@ | Set-Content "$Root\.gitmodules" -Encoding utf8NoBOM

git submodule sync --recursive
Push-Location "$Root\revvup-frontend"; git remote set-url origin "https://github.com/ChamathDilshanC/revvup-frontend.git"; Pop-Location
Push-Location "$Root\revvup-backend"; git remote set-url origin "https://github.com/ChamathDilshanC/revvup-backend.git"; Pop-Location

Invoke-GitCommit $Root "chore: RevvUp monorepo — submodules on ChamathDilshanC"

$mainRemote = "https://github.com/${Owner}/main-application.git"
if (git remote | Select-String "^origin$") { git remote set-url origin $mainRemote }
else { git remote add origin $mainRemote }

$mainExists = $false
try { gh repo view "${Owner}/main-application" | Out-Null; $mainExists = $true } catch { }

if (-not $mainExists) {
    gh repo create "${Owner}/main-application" --public --description "RevvUp — main app (frontend + backend submodules)"
}
git push -u origin main --force

Write-Host ""
Write-Host "Done (ChamathDilshanC only):" -ForegroundColor Green
Write-Host "  https://github.com/ChamathDilshanC/main-application"
Write-Host "  https://github.com/ChamathDilshanC/revvup-frontend"
Write-Host "  https://github.com/ChamathDilshanC/revvup-backend"
