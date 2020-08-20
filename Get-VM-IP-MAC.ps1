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

$vc = "vc_ip_or_dns"

#$vcConn = Connect-VIServer -Server $vc


$theCluster = "Lab"
$Data = @()
$VMs = Get-Cluster -Name $theCluster | Get-VM

<#foreach($VM in $VMs) {
    
        
    $Data+=$VM.Name
    $Data+=$VM.MemoryGB
    $Data+=$VM.NumCpu
    $Data+=$VM.guest.IPAddress[0]
    $Data+=(Get-NetworkAdapter -VM $VM | Select-Object -ExpandProperty MacAddress)
    $Data+=(Get-NetworkAdapter -VM $VM | Select-Object -ExpandProperty NetworkName)

}

$Data | Format-Table -AutoSize

#>


$Data = foreach($VM in $VMs) {
    
     [PSCustomObject]@{
         Name =                               $VM.Name
         MemoryGB =                           $VM.MemoryGB
         CPU =                                $VM.NumCpu
         IP =                                 $VM.guest.IPAddress[0]
         MAC =                                (Get-NetworkAdapter -VM $VM | Select-Object -ExpandProperty MacAddress | Select-Object -First 1)
         Network =                            (Get-NetworkAdapter -VM $VM | Select-Object -ExpandProperty NetworkName | Select-Object -First 1)
     }

}

#$Data | Format-Table -AutoSize
$Data | Export-Csv -LiteralPath C:\VM_IPS_MAC.csv -NoTypeInformation
