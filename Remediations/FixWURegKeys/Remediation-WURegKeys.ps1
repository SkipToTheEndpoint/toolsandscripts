<#
    .SYNOPSIS
        Remediation script for WUfB service breaking or service affecting registry keys.
   
    .NOTES
        Author: James Robinson | SkipToTheEndpoint | https://skiptotheendpoint.co.uk
        Version: v1
        Release Date: 21/07/23
#>

$ErrorActionPreference = 'Stop'

$KeysToRemove = @(
'HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\DisableDualScan'
'HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\DoNotConnectToWindowsUpdateInternetLocations'
'HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU\NoAutoUpdate'
'HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU\AutoInstallMinorUpdates'
'HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AutoRestartDeadlinePeriodInDays'
'HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AutoRestartNotificationSchedule'
'HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AutoRestartRequiredNotificationDismissal'
'HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\BranchReadinessLevel'
'HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU\EnableFeaturedSoftware'
'HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\EngagedRestartDeadline'
'HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\EngagedRestartSnoozeSchedule'
'HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\EngagedRestartTransitionSchedule'
'HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU\IncludeRecommendedUpdates'
'HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU\NoAUAsDefaultShutdownOption'
'HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU\NoAUShutdownOption'
'HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU\NoAutoRebootWithLoggedOnUsers'
'HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\PauseFeatureUpdatesStartTime'
'HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\PauseQualityUpdatesStartTime'
'HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU\RebootRelaunchTimeout'
'HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU\RebootRelaunchTimeoutEnabled'
'HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU\RebootWarningTimeout'
'HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU\RebootWarningTimeoutEnabled'
'HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU\RescheduleWaitTime'
'HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU\RescheduleWaitTimeEnabled'
'HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\ScheduleImminentRestartWarning'
'HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\ScheduleRestartWarning'
'HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\SetAutoRestartDeadline'
'HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\SetAutoRestartNotificationConfig'
'HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\SetAutoRestartNotificationDisable'
'HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\SetAutoRestartRequiredNotificationDismissal'
'HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\SetEDURestart'
'HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\SetEngagedRestartTransitionSchedule'
'HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\SetRestartWarningSchd'
)

Try {
    ForEach ($Key in $KeysToRemove) {
        Remove-Item -Path $Key -Force
        }
    Exit 0
}

Catch {
    Write-Error "$($_.Exception.Message)"
    Exit 1
}