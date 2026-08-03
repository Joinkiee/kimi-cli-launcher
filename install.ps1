# Install the Kimi Code Start Menu shortcut for the current user.
$ErrorActionPreference = "Stop"

Set-Location $PSScriptRoot

$kimiExe = Join-Path $env:USERPROFILE ".kimi-code\bin\kimi.exe"
$kimiInstallUrl = "https://code.kimi.com/kimi-code/install.ps1"

# Step 1: make sure Kimi Code CLI is installed.
if (-not (Test-Path $kimiExe)) {
    Write-Host "Kimi Code CLI is not installed on this system."
    Write-Host "This script can install it from the official Kimi site only:"
    Write-Host "  $kimiInstallUrl"
    $answer = Read-Host "Install Kimi Code CLI now? [y/N]"
    if ($answer -match '^(y|yes)$') {
        Invoke-RestMethod $kimiInstallUrl | Invoke-Expression
    } else {
        Write-Host "Skipped. The shortcut needs Kimi Code CLI to work."
    }
}

# Step 2: copy the icon to a stable location.
$iconDir = Join-Path $env:LOCALAPPDATA "kimi-code-launcher"
New-Item -ItemType Directory -Force $iconDir | Out-Null
$iconPath = Join-Path $iconDir "kimi.ico"
Copy-Item "kimi.ico" $iconPath -Force

# Step 3: create the Start Menu shortcut.
$startMenu = Join-Path $env:APPDATA "Microsoft\Windows\Start Menu\Programs"
$shortcutPath = Join-Path $startMenu "Kimi Code.lnk"

# Prefer Windows Terminal; fall back to the classic console host.
$wt = Join-Path $env:LOCALAPPDATA "Microsoft\WindowsApps\wt.exe"
if (Test-Path $wt) {
    $target = $wt
    $arguments = "--title `"Kimi Code`" `"$kimiExe`""
} else {
    $target = Join-Path $env:SystemRoot "System32\cmd.exe"
    $arguments = "/k `"$kimiExe`""
}

$shell = New-Object -ComObject WScript.Shell
$shortcut = $shell.CreateShortcut($shortcutPath)
$shortcut.TargetPath = $target
$shortcut.Arguments = $arguments
$shortcut.IconLocation = $iconPath
$shortcut.Description = "AI coding assistant in your terminal"
$shortcut.WorkingDirectory = $env:USERPROFILE
$shortcut.Save()

Write-Host "Done. Look for 'Kimi Code' in your Start Menu."
