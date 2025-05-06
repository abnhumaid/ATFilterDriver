<#
.SYNOPSIS
    Create a test code‑signing cert (if needed) and sign ATFilter.sys for test‑signing mode.
#>

param(
    [string]$certName     = "TestCert",
    [string]$sysFile      = "C:\ATFilter\ATFilter.sys",
    [string]$signtoolPath = C:\Users\AHDev\Downloads\SignTool-10.0.22621.6\SignTool-10.0.22621.6\Downloads\Archives\Windows Kits\10\bin\10.0.26100.0\x64\signtool.exe"
)

# 1. Check or create certificate
$cert = Get-ChildItem Cert:\CurrentUser\My |
        Where-Object { $_.Subject -eq "CN=$certName" }

if (-not $cert) {
    Write-Host "🔧 Certificate '$certName' not found. Creating..."
    $cert = New-SelfSignedCertificate `
        -Type CodeSigningCert `
        -Subject "CN=$certName" `
        -CertStoreLocation Cert:\CurrentUser\My
    Write-Host "✅ Certificate '$certName' created."
} else {
    Write-Host "✅ Certificate '$certName' already exists."
}

# 2. Sign the .sys file
if (Test-Path $sysFile) {
    Write-Host "✍️  Signing file: $sysFile"
    & $signtoolPath sign `
        /n $certName `
        /fd SHA256 `
        /tr http://timestamp.digicert.com `
        /td SHA256 `
        $sysFile
    Write-Host "✅ Signing completed."
} else {
    Write-Host "❌ File not found: $sysFile"
}
