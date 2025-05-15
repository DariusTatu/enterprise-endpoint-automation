# hash-upload-script.ps1

<#
.SYNOPSIS
Extracts Windows Autopilot device hash and uploads it to Intune via Graph API using group tag assignment.

.DESCRIPTION
This script:
- Authenticates with Graph API via client credentials flow
- Extracts device hash using Get-WindowsAutopilotInfo.ps1
- Uploads to Autopilot service with pre-defined Group Tag

Author: Darius Tatu
#>

# Load config
$configPath = ".\config.json"
if (-not (Test-Path $configPath)) {
    Write-Error "Missing config.json file. Aborting."
    exit 1
}
$config = Get-Content $configPath | ConvertFrom-Json

$clientId = $config.client_id
$tenantId = $config.tenant_id
$clientSecret = $config.client_secret

# Auth with Graph API
Write-Host "Authenticating with Microsoft Graph..." -ForegroundColor Cyan
$body = @{
    grant_type    = "client_credentials"
    scope         = "https://graph.microsoft.com/.default"
    client_id     = $clientId
    client_secret = $clientSecret
}
try {
    $tokenResponse = Invoke-RestMethod -Method Post -Uri "https://login.microsoftonline.com/$tenantId/oauth2/v2.0/token" -Body $body
    $accessToken = $tokenResponse.access_token
    $headers = @{
        'Authorization' = "Bearer $accessToken"
        'Content-Type'  = 'application/json'
    }
}
catch {
    Write-Error "Failed to authenticate with Graph. $_"
    exit 1
}

# Extract hash
Write-Host "Extracting hardware hash..." -ForegroundColor Cyan
$autopilotTool = ".\Get-WindowsAutopilotInfo.ps1"
if (-not (Test-Path $autopilotTool)) {
    Write-Error "Missing Get-WindowsAutopilotInfo.ps1. Place it in the same directory."
    exit 1
}
.\Get-WindowsAutopilotInfo.ps1 -OutputFile "autopilot.csv"

# Parse and upload
$csv = Import-Csv ".\autopilot.csv"
foreach ($device in $csv) {
    Write-Host "Uploading device: $($device.SerialNumber)" -ForegroundColor Yellow
    $payload = @{
        serialNumber = $device.SerialNumber
        hardwareIdentifier = $device.HardwareHash
        groupTag = "win-global-std"
    } | ConvertTo-Json -Depth 3

    try {
        Invoke-RestMethod -Uri "https://graph.microsoft.com/beta/deviceManagement/windowsAutopilotDeviceIdentities" `
                          -Method Post -Headers $headers -Body $payload
        Write-Host "Upload successful for $($device.SerialNumber)" -ForegroundColor Green
    }
    catch {
        Write-Warning "Upload failed for $($device.SerialNumber): $_"
    }
}

Write-Host "Upload complete." -ForegroundColor Cyan
