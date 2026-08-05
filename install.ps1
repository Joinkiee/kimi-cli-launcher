# Install the Kimi Code Start Menu shortcut for the current user.
$ErrorActionPreference = "Stop"

$scriptDir = if ($PSScriptRoot) { $PSScriptRoot } else { Get-Location }

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
    if (-not (Test-Path $kimiExe)) {
        Write-Host "Warning: Kimi Code CLI is still missing at $kimiExe."
        Write-Host "The shortcut is created anyway, but it will not work until the CLI is installed."
    }
}

# Step 2: copy the icon to a stable location.
$iconDir = Join-Path $env:LOCALAPPDATA "kimi-code-launcher"
New-Item -ItemType Directory -Force $iconDir | Out-Null
$iconPath = Join-Path $iconDir "kimi.ico"
Copy-Item (Join-Path $scriptDir "kimi.ico") $iconPath -Force

# Also install the mode launcher and updater used by the shortcuts and the context menu.
$launcherPath = Join-Path $iconDir "kimi-launch.cmd"
Copy-Item (Join-Path $scriptDir "kimi-launch.cmd") $launcherPath -Force
Copy-Item (Join-Path $scriptDir "update-kimi.ps1") (Join-Path $iconDir "update-kimi.ps1") -Force

# Step 3: create the Start Menu shortcut.
$startMenu = Join-Path $env:APPDATA "Microsoft\Windows\Start Menu\Programs"
$shortcutPath = Join-Path $startMenu "Kimi CLI.lnk"

# Remove old entries: the pre-rename one and the split-out mode shortcut
# (modes are now picked from a menu inside the single "Kimi CLI" entry).
$oldShortcutPaths = @(
    (Join-Path $startMenu "Kimi Code.lnk"),
    (Join-Path $startMenu "Kimi CLI (Auto + K3 Max).lnk")
)
foreach ($oldShortcutPath in $oldShortcutPaths) {
    if (Test-Path $oldShortcutPath) {
        Remove-Item $oldShortcutPath -Force
    }
}

# The single shortcut goes through kimi-launch.cmd with no mode, so it shows the
# mode menu, checks for CLI updates, asks new vs. previous chat, and picks the
# terminal (wt.exe or cmd.exe).
$shell = New-Object -ComObject WScript.Shell
$shortcut = $shell.CreateShortcut($shortcutPath)
$shortcut.TargetPath = $launcherPath
$shortcut.Arguments = ""
$shortcut.IconLocation = $iconPath
$shortcut.Description = "AI coding assistant in your terminal"
$shortcut.WorkingDirectory = $env:USERPROFILE
$shortcut.Save()

# Step 4: right-click context menu for folders (current user only, no admin needed).
$menuRoots = @(
    "HKCU:\Software\Classes\Directory\Background\shell\KimiCLI",
    "HKCU:\Software\Classes\Directory\shell\KimiCLI"
)
$menuEntries = @(
    @{ Key = "1AutoMax"; Label = "Auto + K3 Max (1M)";    Mode = "auto-max" },
    @{ Key = "2Auto";    Label = "Auto (default model)";  Mode = "auto" },
    @{ Key = "3Yolo";    Label = "Yolo (skip approvals)"; Mode = "yolo" },
    @{ Key = "4Plan";    Label = "Plan mode";             Mode = "plan" },
    @{ Key = "5Manual";  Label = "Manual (default)";      Mode = "manual" }
)
foreach ($root in $menuRoots) {
    if (Test-Path $root) { Remove-Item $root -Recurse -Force }
    New-Item -Path $root -Force | Out-Null
    Set-ItemProperty -Path $root -Name "MUIVerb" -Value "Kimi CLI"
    Set-ItemProperty -Path $root -Name "Icon" -Value $iconPath
    Set-ItemProperty -Path $root -Name "SubCommands" -Value ""
    foreach ($entry in $menuEntries) {
        $sub = Join-Path $root ("shell\" + $entry.Key)
        New-Item -Path "$sub\command" -Force | Out-Null
        Set-ItemProperty -Path $sub -Name "MUIVerb" -Value $entry.Label
        Set-ItemProperty -Path $sub -Name "Icon" -Value $iconPath
        Set-ItemProperty -Path "$sub\command" -Name "(Default)" -Value ('"' + $launcherPath + '" ' + $entry.Mode + ' "%V"')
    }
}

Write-Host "Done. Look for 'Kimi CLI' in your Start Menu - it asks which mode to use on launch."
Write-Host "Right-click inside a folder (or on a folder) to find the 'Kimi CLI' submenu."
Write-Host "Every launch checks for a Kimi CLI update and asks new chat vs. previous chats."
