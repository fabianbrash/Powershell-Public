Clear-Host

<# Let's speed up our downloads.. #>
$ProgressPreference = 'SilentlyContinue' 

Write-Output "[TASK 1] Downloading file(s)"
<# This assumes Microsoft doesn't change this link #>
Invoke-WebRequest -URI https://go.microsoft.com/fwlink/?linkid=2088631 -OutFile net48.exe

Write-Output "[TASK 2] Installing .NET 4.8.x"
Write-Output "NOTE THE MACHINE WILL REBOOT AUTOMATICALLY..."
Start-Sleep -Seconds 5

Start-Process net48.exe -ArgumentList "/q" -Wait -Verb Runas
