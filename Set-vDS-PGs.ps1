Clear-Host

try {
    Import-Module -Name VMware.VimAutomation.Core
	}
	
catch{

    Write-Error -Message "Could not load VMware.VimAutomation.Core module..."
	}



Set-PowerCLIConfiguration -DefaultVIServerMode Multiple -Scope User -Confirm:$false | Out-Null

<# Do this for long running tasks 12.5 Hours for the script to complete #>
Set-PowerCLIConfiguration -WebOperationTimeoutSeconds 45000 -Scope User -Confirm:$false | Out-Null

Set-PowerCLIConfiguration -Scope User -ParticipateInCEIP $false -Confirm:$false | Out-Null

Set-PowerCLIConfiguration -InvalidCertificateAction Ignore -Scope User -Confirm:$false | Out-Null

$vc = ""


function setPGs {
  
  param()

  Connect-VIServer -Server $vc

  $csvData = @(Import-Csv -Path "C:\Desktop\new_7_0_vcenters_pg.csv")

  $names = @($csvData.Name.Split(','))

  $vdSwitch = @($csvData.VDSwitch.Split(','))

  $vlanID = @($csvData.VLAN_ID.Split(','))

  $portBinding = @($csvData.PortBinding.Split(','))


  for($i=0; $i -lt $names.Count; $i++) {
  
    Get-VDSwitch -Name $vdSwitch[$i] | New-VDPortgroup -Name $names[$i] -PortBinding $portBinding[$i] -VlanId $vlanID[$i]
  }

Disconnect-VIServer * -Force -Confirm:$false
}

setPGs
