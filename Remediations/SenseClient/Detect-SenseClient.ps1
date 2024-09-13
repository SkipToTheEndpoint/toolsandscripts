<#
    .SYNOPSIS
        Detection script to check if the Microsoft Sense (Defender for Endpoint) Client is installed.
        More info: https://support.microsoft.com/en-us/topic/kb5043950-windows-11-version-24h2-support-2fd719b6-8c26-469f-99fe-832eb1b702d7
   
    .NOTES
        Author: James Robinson | SkipToTheEndpoint | https://skiptotheendpoint.co.uk
        Version: v1
        Release Date: 13/09/24
#>

$Sense = Get-WindowsCapability -Online | Where-Object { $_.Name -eq 'Microsoft.Windows.Sense.Client~~~~' }

If ($Sense.State -eq 'Installed'){
    Write-Host "MS Sense Client Installed"
    Exit 0
}

Else {
    Write-Host "MS Sense Client Not Installed"
    Exit 1
}