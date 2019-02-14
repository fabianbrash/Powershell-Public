Clear-Host

<#
## REF:https://www.vmware.com/support/developer/converter-sdk/conv60_apireference/vim.vm.ConfigSpec.html
#>


try {

    Import-Module VMware.VimAutomation.Core -ErrorAction Stop
}

catch {
    Write-Error -Message "VMware core automation module could not be loaded..."
}

####Ignore Certificate issues this resolves an issue with New-VM in PowerCLI 11.0 but I'm certain for 
##peace of mind just do this by default

Set-PowerCLIConfiguration -InvalidCertificateAction Ignore -confirm:$false


<## Note the above "fix" did not work for me what did work was setting -ErrorAction SilentlyContinue##>

<# VARS #>
$vc = "vc"

Connect-VIServer -Server $vc

$theVM = "specVM"

$vm = Get-VM -Name $theVM


$spec = New-Object VMware.Vim.VirtualMachineConfigSpec
$spec.CpuHotAddEnabled = $true
$spec.MemoryHotAddEnabled = $true
$spec.MemoryReservationLockedToMax = $true
$spec.NumCPUs = 6
$spec.NumCoresPerSocket = 3
$spec.CpuHotRemoveEnabled = $true
$spec.Firmware = "efi"
$spec.MemoryMB = 4096
$vm.ExtensionData.ReconfigVM($spec)
