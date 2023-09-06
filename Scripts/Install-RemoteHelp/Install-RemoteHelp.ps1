<#
    .SYNOPSIS
        Evergreen installer for the Intune Remote Help application.
   
    .NOTES
        Author: James Robinson | SkipToTheEndpoint | https://skiptotheendpoint.co.uk
        Version: v1
        Release Date: 21/07/23

        Intune Info:
        Install Command:    %windir%\SysNative\WindowsPowershell\v1.0\powershell.exe -noprofile -executionpolicy bypass -file .\Install-RemoteHelp.ps1
        Detection Rule:     File - C:\Program Files\Remote Help\RemoteHelp.exe
#>

# Import required assemblies - Required due to WebClient deprecation: https://learn.microsoft.com/en-us/dotnet/core/compatibility/networking/6.0/webrequest-deprecated
Add-Type -AssemblyName System.Net.Http

function Start-Logging {
    $LogFile = "$($env:ProgramData)\Microsoft\IntuneManagementExtension\Logs\Install-RemoteHelp.log"
    
    # Set transcript logging path
    Start-Transcript -Path $LogFile -Append -Verbose
    Write-Host "Current script timestamp: $(Get-Date -f yyyy-MM-dd_HH-mm)"
}  

function Get-File {
    Param(
        [parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$URL,

        [parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$Path,

        [parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$Name
    )
    Begin {
        # Create httpClient object
        $httpClient = New-Object System.Net.Http.HttpClient
        $response = $httpClient.GetAsync($URL)
        $response.Wait()
    }
    Process {
        # Create path if it doesn't exist
        If (-not(Test-Path -Path $Path)) {
            New-Item -Path $Path -ItemType Directory -Force | Out-Null
        }
        # Create file stream
        $outputFileStream = [System.IO.FileStream]::new((Join-Path -Path $Path -ChildPath $Name), [System.IO.FileMode]::Create, [System.IO.FileAccess]::Write)
        # Download file
        $downloadTask = $response.Result.Content.CopyToAsync($outputFileStream)
        $downloadTask.Wait()
        # Close the file stream
        $outputFileStream.Close()
    }
    End {
        # Dispose of httpClient object
        $httpClient.Dispose()
    }
}

function Get-RemoteHelp {
    Write-Host "Downloading latest RemoteHelp Installer"
    $RemHelpURL = "https://aka.ms/downloadremotehelp"

    # Use Invoke-WebRequest to get the response. The `-MaximumRedirection 0` ensures there's no automatic redirection.
    Try {
        $Response = Invoke-WebRequest -Uri $RemHelpURL -MaximumRedirection 0 -ErrorAction SilentlyContinue
    }
    Catch {
        # If a redirection occurs, catch the response regardless
        $Response = $_.Exception.Response
    }
    # Get the location header from the response
    Write-Host "File location: $($Response.Headers.Location)"
    $LocationUrl = $Response.Headers.Location
    # Get the filename from the location header
    Write-Host "File name: $($FileName)"
    $FileName = Split-Path -Path $Response.Headers.Location -Leaf

    Get-File -URL $LocationUrl -Path "$env:TEMP" -Name $FileName
}

function Install-RemoteHelp {
    Write-Host "Installing: $($Installer)"
    Try {
        $Proc = Start-Process $env:TEMP\$FileName -ArgumentList "/quiet acceptTerms=1 enableAutoUpdates=1" -Wait -PassThru -ErrorAction Stop
    }
    Catch {
        Write-Error "$($_.Exception.Message)"
    }
}

# MAIN
Start-Logging

Get-RemoteHelp
Install-RemoteHelp

If ($Proc.ExitCode -eq '0') {
    Write-Host "SUCCESS: Install succeeded with exit code: $($Proc.ExitCode)"
    Exit $($Proc.ExitCode)
}

Else {
    Write-Host "FAILURE: Install failed with exit code: $($Proc.ExitCode)"
    Exit $($Proc.ExitCode)
}

Stop-Transcript
