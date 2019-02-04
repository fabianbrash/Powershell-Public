Clear-Host

try {
    Import-Module -Name VMware.VimAutomation.Core
	}
	
catch{

    Write-Error -Message "Could not load VMware.VimAutomation.Core module..."
	}
	

$vc = "vcenter"

Connect-VIServer -Server $vc

$vm = "test"

$props = Get-VM -Name $vm | Select-Object *

$props 

Write-Host "------------------------------------------------------------------------------"

####Note the syntax below is a inline Hashtable

$VMprops = Get-View -ViewType VirtualMachine -filter @{"Name"="test"}

$VMprops

Write-Host "------------------------------------------------------------------------------"
Write-Host "Config props"
$VMprops.Config
Write-Host "------------------------------------------------------------------------------"

Write-Host "------------------------------------------------------------------------------"
Write-Host "Capability props"
$VMprops.Capability
Write-Host "------------------------------------------------------------------------------"
