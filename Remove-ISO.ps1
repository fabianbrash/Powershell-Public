

Clear-Host

try {
    Import-Module -Name VMware.VimAutomation.Core
	}
	
catch{

    Write-Error -Message "Could not load VMware.VimAutomation.Core module..."
	}
  
  
 $vc = "vcsa"
 $Cred = Import-Clixml -Path C:\cred.cred
  
Connect-VIServer -Server $vc -Credential $Cred


$TheVm = Get-VM -Name "test"

Get-VM -Name $TheVm | Get-CDDrive | where-object {$_.IsoPath} | Set-CDDrive -NoMedia -Confirm:$false

 
 
 ###We should be able to do this as well
 
 
 Get-VM | Get-CDDrive | where-object {$_.IsoPath} | Set-CDDrive -NoMedia -Confirm:$false
 
 ##The above should get all VM's and set the CD-Drive to "Client Device" of course I would test the crap out of
 ##This if you will apply it to 100's of production VM's
