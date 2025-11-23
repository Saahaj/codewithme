# Script to push project to GitHub
# Make sure Git is installed before running this script

Write-Host "Setting up Git repository and pushing to GitHub..." -ForegroundColor Green

# Try to find git
$gitPath = $null
if (Get-Command git -ErrorAction SilentlyContinue) {
    $gitPath = "git"
} elseif (Test-Path "C:\Program Files\Git\bin\git.exe") {
    $gitPath = "C:\Program Files\Git\bin\git.exe"
} elseif (Test-Path "C:\Program Files (x86)\Git\bin\git.exe") {
    $gitPath = "C:\Program Files (x86)\Git\bin\git.exe"
} else {
    Write-Host "ERROR: Git is not installed or not found in PATH." -ForegroundColor Red
    Write-Host "Please install Git from https://git-scm.com/download/win" -ForegroundColor Yellow
    exit 1
}

# Initialize git repository if not already initialized
if (-not (Test-Path .git)) {
    Write-Host "Initializing Git repository..." -ForegroundColor Cyan
    & $gitPath init
}

# Add remote if not already added
$remoteExists = & $gitPath remote get-url origin 2>$null
if ($LASTEXITCODE -ne 0) {
    Write-Host "Adding remote repository..." -ForegroundColor Cyan
    & $gitPath remote add origin https://github.com/Saahaj/SigmaWebdevs.git
} else {
    Write-Host "Remote already exists. Updating..." -ForegroundColor Cyan
    & $gitPath remote set-url origin https://github.com/Saahaj/SigmaWebdevs.git
}

# Add all files
Write-Host "Adding files..." -ForegroundColor Cyan
& $gitPath add .

# Commit changes
Write-Host "Committing changes..." -ForegroundColor Cyan
& $gitPath commit -m "Initial commit: Story blog website"

# Push to GitHub
Write-Host "Pushing to GitHub..." -ForegroundColor Cyan
& $gitPath branch -M main
& $gitPath push -u origin main

if ($LASTEXITCODE -eq 0) {
    Write-Host "Successfully pushed to GitHub!" -ForegroundColor Green
} else {
    Write-Host "Push failed. You may need to authenticate." -ForegroundColor Yellow
    Write-Host "Try running: git push -u origin main" -ForegroundColor Yellow
}

