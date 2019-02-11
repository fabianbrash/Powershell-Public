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
 
 <## [VMware.Vim.GuestOsDescriptorFirmwareType]::efi 
 ## Static Member operator ::
 ## Calls the static properties operator and methods of a .NET Framework class. 
 ## To find the static properties and methods of an object, use the Static parameter of the Get-Member cmdlet.
 ## [datetime]::now
 #>

 $spec1 = New-Object VMware.Vim.VirtualMachineConfigSpec
 $spec1.Firmware = [VMware.Vim.GuestOsDescriptorFirmwareType]::efi
 $vm.ExtensionData.ReconfigVM($spec1)



 ###New let's set Secureboot
 

 $spec = New-Object VMware.Vim.VirtualMachineConfigSpec
 $bootOptions = New-Object VMware.Vim.VirtualMachineBootOptions
 $bootOptions.EfiSecureBootEnabled = $true
 $spec.BootOptions = $bootOptions
 $vm.ExtensionData.ReconfigVM($spec)


 ###SET VBS note the VM must be on harware version 14

 $VMHWVersion = Get-VM -Name $theVM | Select -ExpandProperty Version

 if(-not($VMHWVersion -eq "v14") ) {
     
     Write-Host "WRONG HW VERSION MUST BE ON HW 14....SETTING NOW..." -ForegroundColor Cyan
     #Throw "WRONG VERSION MUST BE ON HW 14"
     Set-VM -VM $vm -Version v14 -confirm:$false <#Deprecated method#>
     <#Set-VM -VM $vm -HardwareVersion v14 -confirm:$false#> <#Preferred method#>
 }

 <# Note because "NestedHVEnabled" is apart of VirtualMachineConfigSpec we can just assign it a value
 ## while VbsEnabled & VvtEnabled is apart of VirtualMachineFlagInfo so we have to create an object
 ## first and then assign it a value, I need to get used to doing this more, it is very powerful
 #>

 $spec3 = New-Object VMware.Vim.VirtualMachineConfigSpec
 $spec3.NestedHVEnabled = $true
 $spec3.Flags = New-Object VMware.Vim.VirtualMachineFlagInfo
 $spec3.Flags.VbsEnabled = $true
 $spec3.Flags.VvtdEnabled = $true
 $vm.ExtensionData.ReconfigVM($spec3)
 
 
 Start-Sleep -Seconds 2
 
 <##Now that's all done let's start up our VM#>
 Start-VM -VM $theVM -Confirm:$false
 
 
 
 

