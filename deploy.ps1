<#
.SYNOPSIS
    Build, sign, install ATFilter driver and setup ETW session.
#>

param(
    [string]$ProjectPath = (Split-Path -Parent $MyInvocation.MyCommand.Path)
)

Write-Host "=== Enabling test-signing mode ==="
bcdedit /set TESTSIGNING ON

Write-Host "=== Building driver (run in WDK build environment) ==="
Push-Location $ProjectPath
build
Pop-Location

Write-Host "=== Signing driver ==="
$sysPath = Join-Path $ProjectPath "objfre_x64\ATFilter.sys"
signtool sign /v /a $sysPath

Write-Host "=== Installing driver ==="
# Ensure the .cat file is present and signed
devcon install (Join-Path $ProjectPath "ATFilter.inf") Root\SerialPort

Write-Host "=== Installing ETW manifest ==="
wevtutil im (Join-Path $ProjectPath "ATFilter.manifest")

Write-Host "=== Starting ETW session ==="
$guid = "b1c0ffee-1234-5678-abcd-1234567890ab"
logman start ATFilterTrace -p $guid 0x1 -ets

Write-Host "Deployment complete. Check Event Viewer under Applications and Services Logs -> ATFilterChannel"
