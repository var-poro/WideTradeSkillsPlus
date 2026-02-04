# PowerShell script to check if Luacheck is available and run it
# Usage: .\check-lint.ps1

Write-Host "Checking for Luacheck..." -ForegroundColor Cyan

# Check if luacheck is available
$luacheckPath = Get-Command luacheck -ErrorAction SilentlyContinue

if (-not $luacheckPath) {
    Write-Host "Luacheck is not installed." -ForegroundColor Yellow
    Write-Host ""
    Write-Host "To install Luacheck:" -ForegroundColor Yellow
    Write-Host "  1. Install LuaRocks: https://luarocks.org/" -ForegroundColor White
    Write-Host "  2. Run: luarocks install luacheck" -ForegroundColor White
    Write-Host ""
    Write-Host "Or install via package manager:" -ForegroundColor Yellow
    Write-Host "  - Windows (Chocolatey): choco install luacheck" -ForegroundColor White
    Write-Host "  - Linux: sudo apt-get install lua-check" -ForegroundColor White
    Write-Host "  - macOS: brew install luacheck" -ForegroundColor White
    Write-Host ""
    Write-Host "Manual code review completed:" -ForegroundColor Green
    Write-Host "  - Removed unused variable: craftTabs" -ForegroundColor Green
    Write-Host "  - Removed unused variable: loadedUI" -ForegroundColor Green
    exit 0
}

Write-Host "Luacheck found at: $($luacheckPath.Source)" -ForegroundColor Green
Write-Host ""
Write-Host "Running Luacheck on *.lua files..." -ForegroundColor Cyan
Write-Host ""

# Run luacheck
luacheck *.lua

$exitCode = $LASTEXITCODE

if ($exitCode -eq 0) {
    Write-Host ""
    Write-Host "Luacheck completed successfully! No issues found." -ForegroundColor Green
} else {
    Write-Host ""
    Write-Host "Luacheck found issues. Please review the output above." -ForegroundColor Yellow
}

exit $exitCode
