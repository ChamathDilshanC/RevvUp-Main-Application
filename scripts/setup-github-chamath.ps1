# RevvUp — Create GitHub repos under ChamathDilshanC (NOT Cursor Agent / other accounts)
# Prerequisites: gh auth login  →  select account ChamathDilshanC
# Usage:  .\scripts\setup-github-chamath.ps1

$ErrorActionPreference = "Stop"
$Root = Split-Path -Parent $PSScriptRoot
Set-Location $Root

$ExpectedUser = "ChamathDilshanC"
$GitName = "Chamath Dilshan"
$GitEmail = "150304779+ChamathDilshanC@users.noreply.github.com"

$ActiveUser = gh api user --jq .login
if ($ActiveUser -ne $ExpectedUser) {
    Write-Host ""
    Write-Host "ERROR: GitHub CLI is logged in as '$ActiveUser', not '$ExpectedUser'." -ForegroundColor Red
    Write-Host "Run:  gh auth login" -ForegroundColor Yellow
    Write-Host "Then select GitHub.com -> Login with browser -> account ChamathDilshanC" -ForegroundColor Yellow
    Write-Host "Verify:  gh api user --jq .login" -ForegroundColor Yellow
    exit 1
}

gh auth setup-git | Out-Null

function Invoke-GitCommit {
    param([string]$Path, [string]$Message)
    Push-Location $Path
    $status = git status --porcelain
    if ($status) {
        git add -A
        git -c "user.name=$GitName" -c "user.email=$GitEmail" commit -m $Message
        Write-Host "Committed in ${Path}: $Message" -ForegroundColor Green
    }
    Pop-Location
}

function Publish-Repo {
    param(
        [string]$Path,
        [string]$RepoName,
        [string]$Description
    )
    Push-Location $Path
    $remote = "https://github.com/${ExpectedUser}/${RepoName}.git"

    if (git remote | Select-String -Pattern "^origin$") {
        git remote set-url origin $remote
    } else {
        git remote add origin $remote
    }

    $exists = $false
    try {
        gh repo view "${ExpectedUser}/${RepoName}" 1>$null 2>$null
        $exists = $true
    } catch { $exists = $false }

    if (-not $exists) {
        Write-Host "Creating ${ExpectedUser}/${RepoName} ..." -ForegroundColor Cyan
        gh repo create $RepoName --source=. --public --remote=origin --description $Description --push
    } else {
        Write-Host "Pushing to existing ${ExpectedUser}/${RepoName} ..." -ForegroundColor Cyan
        git push -u origin main
    }
    Pop-Location
}

Write-Host "=== 1/3 revvup-frontend ===" -ForegroundColor Cyan
Invoke-GitCommit -Path "$Root\revvup-frontend" -Message "feat: Expo SDK 52, NativeWind v4, and tab navigation"
Publish-Repo -Path "$Root\revvup-frontend" -RepoName "revvup-frontend" -Description "RevvUp mobile app — React Native, Expo, NativeWind"

Write-Host "=== 2/3 revvup-backend ===" -ForegroundColor Cyan
Invoke-GitCommit -Path "$Root\revvup-backend" -Message "fix: pydantic compatibility and local dev scripts"
Publish-Repo -Path "$Root\revvup-backend" -RepoName "revvup-backend" -Description "RevvUp API — FastAPI serverless on Vercel"

Write-Host "=== 3/3 main-application (submodules) ===" -ForegroundColor Cyan

# Ensure .gitmodules points to ChamathDilshanC
@"
[submodule "revvup-frontend"]
	path = revvup-frontend
	url = https://github.com/ChamathDilshanC/revvup-frontend.git
[submodule "revvup-backend"]
	path = revvup-backend
	url = https://github.com/ChamathDilshanC/revvup-backend.git
"@ | Set-Content -Path "$Root\.gitmodules" -Encoding utf8

git submodule sync --recursive
Set-Location "$Root\revvup-frontend"
git remote set-url origin "https://github.com/ChamathDilshanC/revvup-frontend.git"
Set-Location "$Root\revvup-backend"
git remote set-url origin "https://github.com/ChamathDilshanC/revvup-backend.git"
Set-Location $Root

Invoke-GitCommit -Path $Root -Message "chore: link submodules to ChamathDilshanC and add workspace config"
Publish-Repo -Path $Root -RepoName "main-application" -Description "RevvUp main app — git submodules (frontend + backend)"

Write-Host ""
Write-Host "Done. Repositories:" -ForegroundColor Green
Write-Host "  https://github.com/ChamathDilshanC/main-application"
Write-Host "  https://github.com/ChamathDilshanC/revvup-frontend"
Write-Host "  https://github.com/ChamathDilshanC/revvup-backend"
Write-Host ""
Write-Host "Clone: git clone --recursive https://github.com/ChamathDilshanC/main-application.git"
