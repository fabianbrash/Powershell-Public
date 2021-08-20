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

function getPG {

  param(
  [Parameter(Mandatory=$false)]
  [String]$fileAndPath
  )

Connect-VIServer -Server $vc

$data = Get-VDPortgroup | Select-Object -Property Name, Datacenter, VDSwitch, IsUpLink, VlanConfiguration, PortBinding | Where-Object {$_.IsUplink -ne 'True'}


#Get-VDSwitch -Name "LAB-vDS" | New-VDPortgroup -Name "LAB-vDS-AUTO-4001" -NumPorts 8 -PortBinding Static -VlanId 4001


#Get-VDPortgroup | Select-Object -Property Name, Datacenter, VDSwitch, IsUpLink, VlanConfiguration, PortBinding | Where-Object {$_.IsUplink -ne 'True'} | Format-Table -AutoSize

$VLAN = @{n='VLAN ID';e={$_.VlanConfiguration | Select-Object -ExpandProperty VlanId}}

if($fileAndPath) {
    $data | Select-Object Name, VDSwitch, $VLAN, PortBinding, Datacenter | Export-Csv -Path $fileAndPath -NoTypeInformation
}
else{ $data | Select-Object Name, VDSwitch, $VLAN, PortBinding, Datacenter | Format-Table -AutoSize }


Disconnect-VIServer * -Force -Confirm:$false

}

getPG -fileAndPath "C:\Desktop\pgs.csv"
