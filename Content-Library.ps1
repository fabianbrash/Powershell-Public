Clear-Host

try {
    Import-Module -Name VMware.VimAutomation.Core
	}
	
catch{

    Write-Error -Message "Could not load VMware.VimAutomation.Core module..."
	}

Set-PowerCLIConfiguration -DefaultVIServerMode Multiple -Confirm:$false

$vc = "vc"
$user = "user@vsphere.local"

Connect-VIServer -Server $vc -User $user

<# If you have VC's in linked mode, connect with the below instead
Connect-VIServer -Server $vc -User $user -AllLinked #>


$CL = Get-ContentLibraryItem

$CL

Write-Host "------------------------------------------------------------------------------------------------------------"

$ISO = Get-ContentLibraryItem -ItemType "ISO" -Name "MyISO*"

$ISO

Write-Host "-----------------------------------------------------------------------------------------------------------"

$OURISO = Get-ContentLibraryItem -Name "MyISO.iso"

$OURISO

<##### Now let's mount this to a VM ###>

$VM = "test2"

####Shutdown VM first why???
$PwrOn = Get-VM -Name $VM

if($PwrOn.PowerState -eq "PoweredOn") {

    Stop-VM -VM $VM -Confirm:$false
}

#$cd = Get-CDDrive -VM $VM -Name "CD/DVD drive 2"
$cd = Get-CDDrive -VM $VM

#$cd

Remove-CDDrive -CD $cd -Confirm:$false

####Shutdown VM first why???
##Stop-VM -VM $VM -Confirm:$false

Get-VM -Name $VM | New-CDDrive -ContentLibraryIso $OURISO -Verbose

##Start VM back up##
Start-VM -VM $VM

Write-Host "--------------------------------------------------------------------------------------------------------"

$newcd = Get-VM -Name $VM | Get-CDDrive
Start-Sleep -Seconds 25
Set-CDDrive -CD $newcd -NoMedia -Confirm:$false
