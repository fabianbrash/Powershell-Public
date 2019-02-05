#Filename:            VMware_VM_Change_PG.ps1
#Author:              Fabian Brash
#Date:                08-17-2017
#Modified:            08-17-2017
#Purpose:             Change the PG of a VM



<#________   ________   ________
|\   __  \ |\   __  \ |\   ____\
\ \  \|\  \\ \  \|\  \\ \  \___|_
 \ \   _  _\\ \   ____\\ \_____  \
  \ \  \\  \|\ \  \___| \|____|\  \
   \ \__\\ _\ \ \__\      ____\_\  \
    \|__|\|__| \|__|     |\_________\
                         \|_________|#>

Clear-Host

try {
  Import-Module -Name VMware.VimAutomation.Core -ErrorAction Stop
}
catch {
  Write-Error -Message "There was an error loading module VMware.VimAutomation.Core"
}

$VC = 'lab-vcsa-01.lab.org'

Connect-ViServer -Server $VC

$TheVM = 'thevm'
$PG = 'portgroup'

try {
  Get-NetworkAdapter -VM $TheVM | Set-NetworkAdapter -NetworkName $PG -Confirm:$false
  Write-Host "The PortGroup for VM" $TheVM "Has been changed to" $PG
}
catch {
  Write-Error -Message "There was an issue setting the PortGroup on the following VM" $TheVM
}
