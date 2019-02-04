
#Filename:            automate-vm.ps1
#Author:              Fabian Brash
#Date:                07-24-2017
#Modified:            07-24-2017
#Purpose:             Migrate a VM to a new datastore



<#________   ________   ________
|\   __  \ |\   __  \ |\   ____\
\ \  \|\  \\ \  \|\  \\ \  \___|_
 \ \   _  _\\ \   ____\\ \_____  \
  \ \  \\  \|\ \  \___| \|____|\  \
   \ \__\\ _\ \ \__\      ____\_\  \
    \|__|\|__| \|__|     |\_________\
                         \|_________|#>


Clear-Host

$vCenter = "your vcenter"


try
    {
        Import-Module -Name VMware.VimAutomation.Core -ErrorAction Stop
    }
catch
    {
        Write-Error -Message "VmWare core automation module could not be loaded..."
    }


Connect-ViServer -Server $vCenter

$NewDatastore = Get-Datastore -Name 'yourstorage'
$TheVM = Get-VM -Name 'vmtomigrate'

try
{
  Move-VM -VM $TheVM -datastore $NewDatastore -ErrorAction Stop
  Write-Host "The Following VM was migrated succesfully" $TheVM
}
catch
{
  Write-Error -Message "Something went wrong..."
}
