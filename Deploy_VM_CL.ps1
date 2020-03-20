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
$vc = "tdctlvcsa01.alexander.io"
$theHost = "lbhpesxi01.alexander.io"
$VMName = @("ubuntu-0", "ubuntu-1", "ubuntu-2", "ubuntu-3")

## I probably need to move this also and get an object of the folder
$folder = "Staging"

Connect-VIServer -Server $vc

<#IF ANY RESOURCE IS AVAILABLE ACROSS MULTIPLE DATACENTERS AND CLUSTERS UNDER THAT YOU MUST USE
 -Location
 #>
<# -Location IS VERY VERY IMPORTANT AS THE DATASTORE IS VISIBLE TO MULTIPLE VCENTERS AND CLUSTERS#>
$Datastore = Get-Datastore -Name "HP-NVME" -Location "LDC"
$sPG = Get-VirtualPortgroup -Name "VMTraffic50"

$Content_Library_Item = "ubuntu1804template-1"
#$GuestSpec = Get-OSCustomizationSpec -Name "CustomSpec-ContentLibrary-automation"


$sVMData = @{

    location = $folder
    Datastore = $Datastore
    VMHost = $theHost
    DiskStorageFormat = "Thin"
 }


 foreach($VM in $VMName) {

    try{
        Get-ContentLibraryItem -Name $Content_Library_Item | New-VM -Name $VM @sVMData -ErrorAction SilentlyContinue
        #Set-VM -VM $VMName -OSCustomizationSpec $GuestSpec -confirm:$false
        Get-NetworkAdapter -VM $VM | Set-NetworkAdapter -NetworkName $sPG -StartConnected $true -confirm:$false
        
   }
   catch{
       Write-Error -Message "Error Deploying $VM from Content Library"
   }
   Start-VM -VM $VM -confirm:$false ##why
 }


