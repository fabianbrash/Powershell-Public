Clear-Host

try {
    Import-Module -Name VMware.VimAutomation.Core
	}
	
catch{

    Write-Error -Message "Could not load VMware.VimAutomation.Core module..."
	}


$Cred = Import-Clixml -Path C:\cred.Cred
$vc = "vc"

Connect-VIServer -Server $vc -Credential $Cred


$iHost = Read-Host "Enter host to retrieve net config"

$TheHost = Get-VMHost -Name $iHost

Get-VMHostNetworkAdapter -VMHost $TheHost -VMKernel


Write-Host "------------------------------------------------------------------------------------------------------------------------------"

Get-VirtualPortGroup -VMHost $TheHost
