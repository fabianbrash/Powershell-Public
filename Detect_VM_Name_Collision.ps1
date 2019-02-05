
Clear-Host

try
    {
        Import-Module -Name VMware.VimAutomation.Core -ErrorAction Stop
    }
catch
    {
        Write-Error -Message "VmWare core automation module could not be loaded..."
    }

    try
        {
            Import-Module -Name VMware.VimAutomation.Vds -ErrorAction Stop
        }
    catch
        {
            Write-Error -Message "VMware core networking automation module could not be loaded..."
        }


$VCSAUser1 = "User"
$vCenter = "vcenter"


Connect-ViServer -Server $vCenter -User $VCSAUser1
   


$VMObjects = Get-VM


function CheckVMObjects($TheVM) {

  if($VMObjects.Name -eq $TheVM) {

    Throw "VM already exists"
    Exit
  }

  else {
  Write-Host "No Name Collision detected..." -ForegroundColor Green
  }

}

$TestVM = 'thevm'

CheckVMObjects $TestVM
