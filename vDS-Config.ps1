Clear-Host

<#
## Deploy and configure vDS
#>


try {

    Import-Module VMware.VimAutomation.Core -ErrorAction Stop
}

catch {
    Write-Error -Message "VMware core automation module could not be loaded..."
}


try {

    Import-Module VMware.VimAutomation.Vds -ErrorAction Stop
}

catch {
    Write-Error -Message "VMware core automation module could not be loaded..."
}

####Ignore Certificate issues this resolves an issue with New-VM in PowerCLI 11.0 but I'm certain for peace of mind just do this by default

Set-PowerCLIConfiguration -InvalidCertificateAction Ignore -confirm:$false


<## Note the above "fix" did not work for me what did work was setting -ErrorAction SilentlyContinue##>

<# VARS #>
$vc = "vc"

Connect-VIServer -Server $vc

$DC = Get-Datacenter -Name "DC"
$vDSName = "vds"
$vDSPG = @("dvPG-NESTED-vSAN99", "dvPG-VMTRAFFIC99", "dvPG-VMTRAFFIC50", "dvPG-NESTED-vSAN50")
[int]$VLAN = @(99,99,50,50) 

<# Create the vDS#>
New-VDSwitch -Name $vDSName -Location $DC -LinkDiscoveryProtocol "CDP" -LinkDiscoveryProtocolOperation Both -NumUplinkPorts 2 -ContactName "FRJB"

<# Create our PG #>

for($i = 0; $i -lt $vDSPG.Length; $i++) {
    Get-VDSwitch -Name $vDSName | New-VDPortgroup -Name $vDSPG[$i] -VlanId $VLAN[$i]
}

<#Add host to vDS and use vmnic 1#>

Get-VDSwitch -Name $vDSName | Add-VDSwitchVMHost -VMHost "host"
$hostAdapter = Get-VMHost "host" | Get-VMHostNetworkAdapter -Physical -Name vmnic1
Get-VDSwitch $vDSName | Add-VDSwitchPhysicalNetworkAdapter -VMHostNetworkAdapter $hostAdapter -Confirm:$false

