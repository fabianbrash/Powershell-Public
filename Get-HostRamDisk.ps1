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


$vcCred = Get-Credential


$connection = Connect-VIServer -Server $vc -Credential $vcCred


$vmHosts = Get-VMHost

foreach($vmHost in $vmHosts) {

    $esxcli = Get-EsxCli -VMHost $vmHost -V2
    $results = $esxcli.system.visorfs.ramdisk.list.Invoke()

    $vmHost.Name
    $results | Select-Object -Property MountPoint, Free, RamdiskName | Where-Object{[int]$_.Free -lt 20} | Format-Table -AutoSize

    Write-Output "======================================================================================================"
}



Disconnect-VIServer * -Force -Confirm:$false
