<#
 #REF: https://www.shogan.co.uk/vmware/getting-and-setting-path-selection-policies-with-powercli/
 #>

Clear-Host

try {
    Import-Module -Name VMware.VimAutomation.Core
	}
	
catch{

    Write-Error -Message "Could not load VMware.VimAutomation.Core module..."
	}


Set-PowerCLIConfiguration -DefaultVIServerMode Multiple -Confirm:$false | Out-Null

<# Do this for long vMotions 12.5 Hours for the script to complete #>
Set-PowerCLIConfiguration -WebOperationTimeoutSeconds 45000 -Confirm:$false | Out-Null

$vc = "vc"
$PSP=@()


Connect-VIServer -Server $vc

$theHosts = Get-Datacenter -Name "dc1" | Get-VMHost

$i=0
$theHosts | % {

    $esxcli = Get-EsxCli -VMHost $_ -V2

    $PSP +=$esxcli.storage.nmp.device.list.Invoke() | Select-Object -Property Device, DeviceDisplayName, PathSelectionPolicy, StorageArrayType, @{n='VMHost';e={($theHosts[$i])}}

    $i++
}


 $PSP | Export-Csv -Path "C:\hosts-PSP.csv" -NoTypeInformation

#$PSP


#$esxcli = Get-EsxCli -VMHost $theHost -V2

#$esxcli.storage.nmp.device.list.Invoke() | Select-Object -Property Device, DeviceDisplayName, PathSelectionPolicy, StorageArrayType, @{n='VMHost';e={($theHost)}} | Export-Csv -Path "C:\hostPSP.csv" -NoTypeInformation

#$esxcli.storage.nmp.device.list.Invoke() | Select-Object -Property Device, DeviceDisplayName, PathSelectionPolicy, StorageArrayType, WorkingPaths, @{n='VMHost';e={($theHost)}}


#$PSP = Get-ScsiLun -VmHost $theHosts -LunType disk | Select-Object -Property CanonicalName, LunType, Model, Vendor, MultipathPolicy, VMHost | ft

#$PSP
