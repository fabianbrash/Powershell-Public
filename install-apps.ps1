Clear-Host

try {
    Import-Module -Name VMware.VimAutomation.Core
	}
	
catch{

    Write-Error -Message "Could not load VMware.VimAutomation.Core module..."
	}
	

$vc = "vc"
$user = "user@vsphere.local"

Connect-VIServer -Server $vc -User $user


$CL = Get-ContentLibraryItem


$ISO = Get-ContentLibraryItem -ItemType "ISO" -Name "TheISO*"

$OURISO = Get-ContentLibraryItem -Name "TheISO.iso"

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

Get-VM -Name $VM | New-CDDrive -ContentLibraryIso $OURISO

##Start VM back up##
Start-VM -VM $VM


Start-Sleep -Seconds 10
##Now let's do something with our mounted CD/DVD

##Our D: Drive is mounted this will be different in each environment###
$InstallPath = "D:\Apps\McAfee\"
$Installer = "FramePkg.exe /INSTALL=AGENT /SILENT"

$installerScript = '& D:\Apps\McAfee\FramePkg.exe /INSTALL=AGENT /SILENT'
#$testscript = 'Get-Process winlogon'
Invoke-VMScript -VM $VM -ScriptText $installerScript -GuestCredential (Get-Credential) -ScriptType Powershell
 
$newcd = Get-VM -Name $VM | Get-CDDrive



Start-Sleep -Seconds 45
Set-CDDrive -CD $newcd -NoMedia -Confirm:$false
