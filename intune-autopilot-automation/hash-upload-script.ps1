# hash-upload-script.ps1

<#
.SYNOPSIS
Extracts Windows Autopilot device hash and uploads it to Microsoft Endpoint Manager via Graph API.

.DESCRIPTION
This script is designed to automate the device registration process into Windows Autopilot.
It:
  1. Extracts the hardware hash using Get-WindowsAutopilotInfo.ps1
  2. Authenticates with Microsoft Graph API
  3. Uploads the hash to the target tenant
  4. Optionally logs results locally or to Azure

Author: Darius Tatu
#>

# PARAMETERS (you'll parameterize these in final version)
$clientId = "YOUR_APP_ID"
$tenantId = "YOUR_TENANT_ID"
$clientSecret = "YOUR_SECRET"
$deviceName = $env:COMPUTERNAME

# Step 1: Get Autopilot hash
Write-Host "Extracting device hash..."
.\Get-WindowsAutopilotInfo.ps1 -OutputFile "autopilot.csv"

# Step 2: Get token
Write-Host "Authenticating with Graph..."
$body = @{
    grant_type    = "client_credentials"
    scope         = "https://graph.microsoft.com/.default"
    client_id     = $clientId
    client_secret = $clientSecret
}
$tokenResponse = Invoke-RestMethod -Method Post -Uri "https://login.microsoftonline.com/$tenantId/oauth2/v2.0/token" -Body $body
$authHeader = @{
    'Authorization' = "Bearer $($tokenResponse.access_token)"
    'Content-Type'  = 'application/json'
}

# Step 3: Upload device hash
Write-Host "Uploading hash to Intune..."
$csv = Import-Csv ".\autopilot.csv"
foreach ($device in $csv) {
    $payload = @{
        serialNumber = $device.SerialNumber
        hardwareIdentifier = $device.HardwareHash
        groupTag = "Autopilot"
    } | ConvertTo-Json -Depth 3

    Invoke-RestMethod -Uri "https://graph.microsoft.com/beta/deviceManagement/windowsAutopilotDeviceIdentities" `
                      -Method Post -Headers $authHeader -Body $payload
}

Write-Host "Done. Device uploaded."

