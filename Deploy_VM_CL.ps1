<#
## Deploy VM from content library
#>


try {

    Import-Module VMware.VimAutomation.Core -ErrorAction Stop
}

catch {
    Write-Error -Message "VMware core automation module could not be loaded..."
}

####Ignore Certificate issues this resolves an issue with New-VM in PowerCLI 11.0 but I'm certain for peace of mind just do this by default

Set-PowerCLIConfiguration -InvalidCertificateAction Ignore -confirm:$false


<## Note the above "fix" did not work for me what did work was setting -ErrorAction SilentlyContinue##>

<# VARS #>
$vc = "vcsa"
$Host = "host"
$VMName = "pctw16automate"
$folder = "Staging"
$sPG = "VMTraffic50"

Connect-VIServer -Server $vc

<#IF ANY RESOURCE IS AVAILABLE ACROSS MULTIPLE DATACENTERS AND CLUSTERS UNDER THAT YOU MUST USE
 -Location
 #>
<# -Location IS VERY VERY IMPORTANT AS THE DATASTORE IS VISIBLE TO MULTIPLE VCENTERS AND CLUSTERS#>
$Datastore = Get-Datasore -Name "datastore1" -Location "DC1"

$Content_Library_Item = "18-10-Srv16-4K-EFI-OVA-VBS"
$GuestSpec = Get-OSCustomizationSpec -Name "CustomSpec-ContentLibrary-automation"


$sVMData = @{

    location = $folder
    Datastore = $Datastore
    VMHost = $Host

try{
     Get-ContentLibraryItem -Name $Content_Library_Item | New-VM -Name $VMName @sVMData -ErrorAction SilentlyContinue
     Set-VM -VM $VMName -OSCustomizationSpec $GuestSpec -confirm:$false
     Get-NetworkAdapter -VM $VMName | Set-NetworkAdapter -NetworkName $sPG -StartConnected $true -confirm:$false
     Start-VM $VMName -confirm:$false
}
catch{
    Write-Error -Message "Error Deploying VM from Content Library"
}

