Clear-Host

try {
    Import-Module -Name VMware.VimAutomation.Core
	}
	
catch{

    Write-Error -Message "Could not load VMware.VimAutomation.Core module..."
	}


Set-PowerCLIConfiguration -DefaultVIServerMode Multiple -Confirm:$false | Out-Null

$vc = "vc"

$Cred = Import-Clixml -Path C:\cred.Cred
Connect-VIServer -Server $vc -Credential $Cred

$vm = Get-VM -Name "W"

$file = "[N3-LOCAL] VMware-ESXi-6.7U1-RollupISO.iso"

$vms = Get-Cluster -Name "vSAN" | Get-VM

$vms | ft

Get-CDDrive -VM $vms | Set-CDDrive -IsoPath $file -Connected $true -Confirm:$false
