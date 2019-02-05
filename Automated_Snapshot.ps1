<###FileName:    Automated_Snapshot.ps1
<###Author:      Fabian Brash
<###Usage:       Automate snapshot deletions in vCenter
###>



Clear-Host


try {
        Import-Module -Name VMware.VimAutomation.Core -ErrorAction Stop
    }

catch {
        Write-Error -Message "Error loading core VMware module"
      }



$vCenter = 'lab-vcsa-01.lab.org'

Connect-VIServer -Server $vCenter

$theVM = 'lab-mgmt-01'
$VMArray = @('lab-mgmt-01', 'lab-dc-01', 'lab-win10-01', 'crypto-01')
$Reason = "Snapshot Array test"

foreach($vms in $VMArray) {
    try {
        
          New-Snapshot -VM $vms -Name $Reason -Description $Reason -ErrorAction Stop
        }

    catch {

          Write-Error -Message "There was error creating the snapshot"

           }
}

