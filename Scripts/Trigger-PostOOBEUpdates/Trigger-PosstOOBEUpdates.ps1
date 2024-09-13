<#
    .SYNOPSIS
        Script to trigger updates following an Autopilot deployment.
   
    .NOTES
        Author: James Robinson | SkipToTheEndpoint | https://skiptotheendpoint.co.uk
        Version: v1
        Release Date: 2024-08-31

        Intune Info:
        Sctipt type - Platform Script
        Assign to - Users
#>
$Script:LogFile = "PostOOBEUpdates.log"
$Script:LogsFolder = "$env:ProgramData\Microsoft\IntuneManagementExtension\Logs"

$ErrorActionPreference = [System.Management.Automation.ActionPreference]::SilentlyContinue

function Start-Logging {
    Start-Transcript -Path $LogsFolder\$LogFile -Append
    Write-Host "Current script timestamp: $(Get-Date -f yyyy-MM-dd_HH-mm)"
}

Start-Logging

Try {
    # Update MDE
    Write-Host "Triggering MDE Update..."
    Update-MpSignature

    # Update Store Apps
    Write-Host "Triggering Store App Updates..."
    Get-CimInstance -Namespace "Root\cimv2\mdm\dmmap" -ClassName "MDM_EnterpriseModernAppManagement_AppManagement01" | Invoke-CimMethod -MethodName UpdateScanMethod

    # Start WU Check
    Write-Host "Triggering Windows Update Check..."
    Start-Process USOClient.exe -ArgumentList "StartInteractiveScan" -NoNewWindow -Wait

    # Stop Logging and Exit
    Write-Host "Script complete."
    Stop-Transcript
    Exit 0
}
Catch {
    Write-Error "$($_.Exception.Message)"
    Exit 1
}