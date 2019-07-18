Clear-Host

#Import-Module -Name HPOneView.420

Import-Module -Name HPOneView.410

$BLArray=@()

#Connect-HPOVMgmt -Hostname DNS_OR_IP
#Connect-HPOVMgmt -Hostname DNS_OR_IP


$BLServers = Get-HPOVServer | Select *


#$BLServers


$BLServers | % {


    $BLArray +=$_ | Select-Object serverName, name, @{n='WWPN';e={($_.portMap.deviceSlots.physicalPorts.virtualPorts | Select-Object -ExpandProperty wwpn)}}, @{n='WWNN';e={($_.portMap.deviceSlots.physicalPorts.virtualPorts | Select-Object -ExpandProperty wwnn)}}
    #$BLServers | Select-Object serverName, name, @{n='WWNN';e={($_.portMap.deviceSlots.physicalPorts.virtualPorts | Select-Object -ExpandProperty wwnn)}}, @{n='WWPN';e={($_.portMap.deviceSlots.physicalPorts.virtualPorts | Select-Object -ExpandProperty wwpn)}} | ft -AutoSize
    # ,@{n='WWNN';e={($_.portMap.deviceSlots.physicalPorts.virtualPorts | Select-Object -Property wwnn)}, @{n='WWPN';e={($_.portMap.deviceSlots.physicalPorts.virtualPorts | Select-Object -Property wwpn)}}}}
    
    <#$BLArray+=$_.serverName
    $BLArray+=$_.name
    $BLArray+=$_.portMap.deviceSlots.physicalPorts.virtualPorts | Select-Object wwpn,wwnn#>

}


$BLArray | Export-Csv -Path C:\file.csv -NoTypeInformation -Delimiter : 
#$BLArray | Out-File -FilePath C:\file.log
#$BLArray



#Disconnect-HPOVMgmt
