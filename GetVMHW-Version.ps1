<###FileName:    GetVMHW-Version.ps1
<###Author:      Fabian Brash
<###Usage:       Find all VM's in a cluster with a specific HW Version
<###REF:         https://blogs.vmware.com/PowerCLI/2011/11/vm-tools-and-virtual-hardware-versions.html
###>



Clear-Host


try {
        Import-Module -Name VMware.VimAutomation.Core -ErrorAction Stop
    }

catch {
        Write-Error -Message "Error loading core VMware module"
      }


$vCenter55 = 'VC'
$Cluster55 = 'YourCluster'

Connect-VIServer -Server $vCenter55

Write-Host ""

$ClusterObjects = Get-Cluster $Cluster55 | Get-VM | Select Name, Version 

foreach($CObjects in $ClusterObjects) {

    if($CObjects.Version -eq 'v7') {
        Write-Host $CObjects.Name
    }

}

