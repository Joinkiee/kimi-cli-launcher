# Update Kimi Code CLI to the latest version if a newer one exists.
# Called by kimi-launch.cmd before every launch; silent when up to date.
$kimiExe = Join-Path $env:USERPROFILE ".kimi-code\bin\kimi.exe"
$downloadBase = "https://code.kimi.com/kimi-code"

try {
    # latest.json is the rollout manifest the CLI's own update preflight reads;
    # the plain-text /latest endpoint is the documented fallback.
    $latest = ""
    try {
        $manifest = Invoke-RestMethod -Uri "$downloadBase/latest.json" -TimeoutSec 10
        $latest = [string]$manifest.version
    } catch {
        $latest = ""
    }
    if (-not $latest) {
        $latest = (Invoke-WebRequest -Uri "$downloadBase/latest" -UseBasicParsing -TimeoutSec 10).Content
        if ($latest -is [byte[]]) { $latest = [System.Text.Encoding]::UTF8.GetString($latest) }
        $latest = $latest.Trim()
    }
    if (-not $latest) { exit 0 }

    $current = ""
    if (Test-Path $kimiExe) {
        $current = ((& $kimiExe --version) | Out-String).Trim()
    }

    if ($latest -eq $current) {
        Write-Host "   [OK] Kimi CLI is up to date ($current)"
        exit 0
    }

    Write-Host "   [..] Updating Kimi CLI: $current -> $latest"
    Invoke-RestMethod "$downloadBase/install.ps1" | Invoke-Expression
    Write-Host "   [OK] Kimi CLI updated to $latest"
} catch {
    Write-Host "   [WARN] update check failed ($($_.Exception.Message)); starting current version."
}
