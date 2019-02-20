Clear-Host

<#
## Build out my home lab
## After vCenter deployment
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

$DC = "Quebec"
$Clusters = @("Mgmt", "vSAN")
$esxhosts = @("host1")
[Int32]$uplinks = 2
$vDSName = "Prod-vDS"
$vDSPG = @("DvPG-VMTRAFFIC99", "DvPG-VMTRAFFIC50", "DvPG-NFS30","DvPG-NESTED-MGMT99","DvPG-NESTED-vSAN50", "DvPG-NESTED30")
[int]$VLAN = @(99,50,30,99,50,30) 

$Folder = Get-Folder -NoRecursion

New-Datacenter -Location $Folder -Name $DC

Write-Host "Adding hosts(s) to the datacenter:"$DC -ForegroundColor Green
    try
        {
            for($i=0; $i -lt $esxhosts.length; $i++) {
                Add-VMHost -Name $esxhosts[$i] -Location $DC -Credential(Get-Credential) -Force
            }
        }
    catch
        {
            Write-Error -Message "Could not add host to datacenter:"$DC
        }


<# Create cluster(s) #>
Write-Host "Creating Cluster(s)"
Write-Host "---------------------------------------------------------------------------------------------------"
for($b=0; $b -lt $Clusters.Length; $b++) {

    New-Cluster -Location $DC -Name $Clusters[$b] -DRSEnabled -DRSMode FullyAutomated -HAEnabled -HAAdmissionControlEnabled
}

<# Add host(s) to a cluster #>
Write-Host "Adding Host(s)"
Write-Host "---------------------------------------------------------------------------------------------------"
for($d=0; $d -lt $esxhosts.Lenght; $d++) {

    Move-VMHost -VMHost $esxhosts[$d] -Destination "Mgmt"
 }
 
 
<# Create the vDS#>
Write-Host "Creating vDS"
Write-Host "---------------------------------------------------------------------------------------------------"
New-VDSwitch -Name $vDSName -Location $DC -LinkDiscoveryProtocol "CDP" -LinkDiscoveryProtocolOperation Both -NumUplinkPorts $uplinks -ContactName "FRJB"

<# Create our PG(s) #>
Write-Host "Creating PG(s)"
Write-Host "---------------------------------------------------------------------------------------------------"
for($c=0; $c -lt $vDSPG.Length; $c++) {
    Get-VDSwitch -Name $vDSName | New-VDPortgroup -Name $vDSPG[$c] -VlanId $VLAN[$c]
}

<#Add hosts to vDS and use vmnic 1#>
Write-Host "Adding Host(s) to vDS"
Write-Host "---------------------------------------------------------------------------------------------------"
for($a=0; $a -lt $esxhosts.Length; $a++) {
    Get-VDSwitch -Name $vDSName | Add-VDSwitchVMHost -VMHost $esxhosts[$a]
    $hostAdapter = Get-VMHost $esxhost[$a] | Get-VMHostNetworkAdapter -Physical -Name vmnic1
    Get-VDSwitch $vDSName | Add-VDSwitchPhysicalNetworkAdapter -VMHostNetworkAdapter $hostAdapter -Confirm:$false

}

