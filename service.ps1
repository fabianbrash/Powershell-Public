

###WINDOWS SERVICES##########

$SvcName = "service"


Get-Service $SvcName
Start-Service $SvcName
Restart-Service $SvcName


Get-Service | where name -like "*serv*"

$SvcStatus = Get-Service $SvcName

if($SvcStatus.Status -eq "running") {

  Write-Host "Running"
 }
 
 
 ####IF A SERVICE IS DISABLED##########
 
 Set-Service -Name $SvcName -StartupType Automatic | Manual | Disabled

Set-Service -Name W32Time -StartupType Manual
Start-Service W32Time
