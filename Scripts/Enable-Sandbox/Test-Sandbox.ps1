$Sandbox = Get-WindowsOptionalFeature -FeatureName "Containers-DisposableClientVM" -Online
    
If ($Sandbox.State -eq "Enabled") {
    Write-Host "Sandbox is enabled"
    Exit 0
}
Else {
    Write-Host "Sandbox is not enabled"
    Exit 1
}
