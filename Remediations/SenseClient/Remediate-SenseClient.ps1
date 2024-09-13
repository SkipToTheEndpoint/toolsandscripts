<#
    .SYNOPSIS
        Remediation script to install the Microsoft Sense (Defender for Endpoint) Client.
   
    .NOTES
        Author: James Robinson | SkipToTheEndpoint | https://skiptotheendpoint.co.uk
        Version: v1
        Release Date: 13/09/24
#>

Try {
    Write-Host "Installing MS Sense Client..."
    Add-WindowsCapability -Online -Name Microsoft.Windows.Sense.Client~~~~
    Exit 0
}
Catch {
    Write-Error "$($_.Exception.Message)"
    Exit 1
}