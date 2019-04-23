Clear-Host

try {
    Import-Module -Name VMware.VimAutomation.Core
	}
	
catch{

    Write-Error -Message "Could not load VMware.VimAutomation.Core module..."
	}

Connect-VIServer -Server $vc  -Credential $vcCred


Get-Datacenter -Name "DC2" | Get-VMHost | Sort Name | Get-View | Select Name, @{N="Type";E={$_.Hardware.SystemInfo.Vendor+""+$_.Hardware.SystemInfo.Model}}, @{N="Processor Type";E={"Proc Type:"+$_.Hardware.CpuPkg[0].Description}} | ft -AutoSize


