
Clear-Host

try {
    Import-Module -Name VMware.VimAutomation.Core
	}
	
catch{

    Write-Error -Message "Could not load VMware.VimAutomation.Core module..."
	}



#$user = "user@vsphere.local"
$Cred = Import-Clixml -Path C:\cred.Cred

$vc = "vcsa"

Connect-VIServer -Server $vc -Credential $Cred


$TheHost = Get-VMHost -Name "host1"
$TheHosts = @("host1")
$VSSName = "vSwitch1"
$VSSName1 = "vSwitch2"
$VSSName2 = "vSwitch3"
$VSSPG = "Nested-MGMT99"
$VSSPG_VMO = "Nested-VMO900"
$VSSPG_VSAN = "Nested-VSAN901"


$TheHosts | % {


###Our Nested MGMT switch, this can be removed as the MGMT switch will be built manually####
New-VirtualSwitch -VMHost $_ -Name $VSSName -Mtu 1500 -Confirm:$false

$VSS = Get-VirtualSwitch -VMHost $_ -Name $VSSName

New-VirtualPortGroup -Name $VSSPG -VirtualSwitch $VSS -VLanId 99 -Confirm:$false

Get-VirtualSwitch -Name $VSSName | Get-SecurityPolicy | Set-SecurityPolicy -AllowPromiscuous $true
Get-VirtualSwitch -Name $VSSName | Get-SecurityPolicy | Set-SecurityPolicy -MacChanges $true
Get-VirtualSwitch -Name $VSSName | Get-SecurityPolicy | Set-SecurityPolicy -ForgedTransmits $true

#Add our vMotion switch

New-VirtualSwitch -VMHost $_ -Name $VSSName1 -Mtu 1500 -Confirm:$false

$VSS1 = Get-VirtualSwitch -VMHost $_ -Name $VSSName1

New-VirtualPortGroup -Name $VSSPG_VMO -VirtualSwitch $VSS1 -VLanId 900 -Confirm:$false

Get-VirtualSwitch -Name $VSSName1 | Get-SecurityPolicy | Set-SecurityPolicy -AllowPromiscuous $true
Get-VirtualSwitch -Name $VSSName1 | Get-SecurityPolicy | Set-SecurityPolicy -MacChanges $true
Get-VirtualSwitch -Name $VSSName1 | Get-SecurityPolicy | Set-SecurityPolicy -ForgedTransmits $true

#Add our vSAN switch and PG

New-VirtualSwitch -VMHost $_ -Name $VSSName2 -Mtu 1500 -Confirm:$false

$VSS2 = Get-VirtualSwitch -VMHost $_ -Name $VSSName2

New-VirtualPortGroup -Name $VSSPG_VSAN -VirtualSwitch $VSS2 -VLanId 901 -Confirm:$false

Get-VirtualSwitch -Name $VSSName2 | Get-SecurityPolicy | Set-SecurityPolicy -AllowPromiscuous $true
Get-VirtualSwitch -Name $VSSName2 | Get-SecurityPolicy | Set-SecurityPolicy -MacChanges $true
Get-VirtualSwitch -Name $VSSName2 | Get-SecurityPolicy | Set-SecurityPolicy -ForgedTransmits $true

}
