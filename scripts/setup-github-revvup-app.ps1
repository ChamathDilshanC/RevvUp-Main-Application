# RevvUp — Publish main + submodules to ChamathDilshanC (revvup-app umbrella)
# Prerequisites: gh auth login
# Usage: .\scripts\setup-github-revvup-app.ps1

$ErrorActionPreference = "Stop"
$Root = Split-Path -Parent $PSScriptRoot
Set-Location $Root

$Owner = "ChamathDilshanC"
$MainRepo = "revvup-app"
$GitName = "Chamath Dilshan"
$GitEmail = "150304779+ChamathDilshanC@users.noreply.github.com"

if ((gh api user --jq .login) -ne $Owner) {
    Write-Host "ERROR: gh must be logged in as $Owner" -ForegroundColor Red
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

function Publish-Repo {
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
    Write-Host "OK: https://github.com/${Owner}/${RepoName}" -ForegroundColor Green
    Pop-Location
}

Write-Host "=== revvup-frontend ===" -ForegroundColor Cyan
Invoke-GitCommit "$Root\revvup-frontend" "feat: multi-role screens (auth/client/owner) and OwnerTabs navigation"
Publish-Repo "$Root\revvup-frontend" "revvup-frontend" "RevvUp mobile - React Native, Expo, NativeWind"

Write-Host "=== revvup-backend ===" -ForegroundColor Cyan
Invoke-GitCommit "$Root\revvup-backend" "feat: owner-isolated /owner/bikes routes and showrooms API"
Publish-Repo "$Root\revvup-backend" "revvup-backend" "RevvUp API - FastAPI on Vercel"

Write-Host "=== revvup-app (main) ===" -ForegroundColor Cyan
@"
[submodule "revvup-frontend"]
	path = revvup-frontend
	url = https://github.com/ChamathDilshanC/revvup-frontend.git
[submodule "revvup-backend"]
	path = revvup-backend
	url = https://github.com/ChamathDilshanC/revvup-backend.git
"@ | Set-Content "$Root\.gitmodules" -Encoding UTF8

git submodule sync --recursive
Invoke-GitCommit $Root "chore: RevvUp multi-vendor architecture - submodules and READMEs"

$mainRemote = "https://github.com/${Owner}/${MainRepo}.git"
if (git remote | Select-String "^origin$") { git remote set-url origin $mainRemote }
else { git remote add origin $mainRemote }

$mainExists = $false
try { gh repo view "${Owner}/${MainRepo}" | Out-Null; $mainExists = $true } catch { }

if (-not $mainExists) {
    gh repo create "${Owner}/${MainRepo}" --public --description "RevvUp premium multi-showroom motorbike marketplace (submodules)"
}
git push -u origin main --force

Write-Host ""
Write-Host "Done:" -ForegroundColor Green
Write-Host "  https://github.com/${Owner}/${MainRepo}"
Write-Host "  https://github.com/${Owner}/revvup-frontend"
Write-Host "  https://github.com/${Owner}/revvup-backend"
