Clear-Host

try {
    Import-Module -Name VMware.VimAutomation.Core
	}
	
catch{

    Write-Error -Message "Could not load VMware.VimAutomation.Core module..."
	}
	

$vc = "vcenter"
$user = "user@vsphere.local"

Connect-VIServer -Server $vc -User $user

$theVM = "test2"

$vmHashTable = @{

    "Name" = "test2"
}


$PwrdOn = Get-VM -Name $theVM

<# IF our VM is on Power it off #>
if($PwrdOn.PowerState -eq "PoweredOn") {

    Stop-VM -VM $theVM -Confirm:$false
 }
 
 
 <## Now that's out of the way let's reconfigure it#>
 
 $vmview = Get-VM -Name $theVM | Get-View
 $vmConfigSpec = New-Object VMware.Vim.VirtualMachineConfigSpec
 
 $vmConfigSpec.MemoryHotAddEnabled = $true
 $vmConfigSpec.CpuHotAddEnabled = $true

 Get-View -ViewType VirtualMachine -Filter $vmHashTable

 $vmview.ReconfigVM($vmConfigSpec)
 
 
 ##Let's enable EFI

 $vm = Get-VM -Name $theVM


 $spec1 = New-Object VMware.Vim.VirtualMachineConfigSpec
 $spec1.Firmware = [VMware.Vim.GuestOsDescriptorFirmwareType]::efi
 $vm.ExtensionData.ReconfigVM($spec1)



 ###New let's set Secureboot
 

 $spec = New-Object VMware.Vim.VirtualMachineConfigSpec
 $bootOptions = New-Object VMware.Vim.VirtualMachineBootOptions
 $bootOptions.EfiSecureBootEnabled = $true
 $spec.BootOptions = $bootOptions
 $vm.ExtensionData.ReconfigVM($spec)

 Start-Sleep -Seconds 2
 
 <##Now that's all done let's start up our VM#>
 Start-VM -VM $theVM -Confirm:$false
 
 
 
 

