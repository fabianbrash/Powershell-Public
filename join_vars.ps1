Clear-Host

$vc = "https://vcsa/"
$api = "apiexplorer"
$vc_endpoint = "rest/vcenter"
$vm_endpoint = "/vm"
$date = "11-2018"
$name = "backup-"

$vc+$api

#$name = Read-Host "Enter Name"

$name+$date
Write-Host $name$date

##The above method using Write-Host must convert it to a string, from now on I will use the + to concat
##multiple variables

$vc+$vc_endpoint+$vm_endpoint
