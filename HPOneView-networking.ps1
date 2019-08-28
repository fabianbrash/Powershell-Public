Clear-Host


#$HPModule                             ="HPOneView.420"
$HPModule5                             ="HPOneView.500" 

try {
Import-Module -Name $HPModule5
}

catch{
Write-Error -Message "Could not load module $HPModule5"
}

$MACS=@()

#Connect-HPOVMgmt -Hostname "ONE_VIEW_SERVER"

#| Where-Object {$_.serverName -notlike "PVC*"


<#
##While this is a great exercise the data returned for networking information can be erroneous
##Accurate network information for blades that are connected via Virtual Connect
##are located in Get-HPOVProfileConnectionList if it's a passthru and or a chassis server then the below should be accurate?
#>

function OneViewMACInfo() {

#| Select-Object -Property serverName, mpModel, model, name, @{n='MAC Addresses';e={(($_.portMap.deviceSlots.physicalPorts.virtualPorts | Select-Object -ExpandProperty mac) -join ",")}} | ft -AutoSize

    $BLServers                                                                   =Get-HPOVServer | Select * | Sort-Object serverName

       $MACS = foreach($mac in $BLServers) {

       [PSCustomObject]@{

               ServerName                                                        =$mac.serverName
               ILO                                                               =$mac.mpModel
               Model                                                             =$mac.model
               "Enclosure/Bay#"                                                  =$mac.name
               MacAddress                                                        =$mac.portMap.deviceSlots.physicalPorts.virtualPorts.mac -join ","                                

    }

 }

 $MACS | ft -AutoSize
}

    
OneViewMACInfo
