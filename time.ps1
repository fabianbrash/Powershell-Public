Clear-Host

[Int]$StartTime=0
[Int]$EndTime=0

[Int]$StartTime = Get-Date | Select-Object -ExpandProperty Second

#$StartTime = Get-Date -DisplayHint Time
#$StartTime = Get-Date -Format "HH:mm:ss"
#$StartTime

Start-Sleep -Seconds 36

#$EndTime = Get-Date -DisplayHint Time
[Int]$EndTime = Get-Date | Select-Object -ExpandProperty Second
#$EndTime = Get-Date -Format "HH:mm:ss"

$ElapsedTime = ($EndTime - $StartTime)

Write-Host "Script ran in" $ElapsedTime "Seconds"
