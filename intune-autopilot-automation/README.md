# Intune Autopilot Automation

## 🔄 hash-upload-script.ps1

This script automates Windows Autopilot device hash upload using Microsoft Graph API.

### Features
- Extracts hardware hash using Microsoft’s official `Get-WindowsAutopilotInfo.ps1`
- Authenticates via client credentials flow
- Uploads device details to the tenant
- Supports group tagging for dynamic profile assignment

### Use Case
✅ Enterprises scaling their Windows deployments and aiming for full Zero Touch provisioning.

### Dependencies
- Azure App Registration with Graph API permissions (`DeviceManagementServiceConfig.ReadWrite.All`)
- `Get-WindowsAutopilotInfo.ps1` must be downloaded or preinstalled on device

### Next Improvements
- Add logging to Azure Monitor or Log Analytics
- Modularize for reuse in deployment pipelines (MDT/ConfigMgr)

### Author
[Darius Tatu](https://www.linkedin.com/in/dariustatu)

