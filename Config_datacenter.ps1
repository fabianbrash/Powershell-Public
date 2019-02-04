
<#FileName:       Config_datacenter.ps1
  Author:         Fabian Brash
  Purpose:        Create initial datacenter config
  Created:        07-11-2018
  Modified:       07-12-2018
#>
             
                                  


    Clear-Host 

    try
        {
            Import-Module -Name VMware.VimAutomation.Core -ErrorAction Stop
        }
    catch
        {
            Write-Error -Message "Could not load core Vmware Modules..."
        }


    try
        {
            Import-Module -Name VMware.VimAutomation.Vds -ErrorAction Stop
        }

    catch
        {
            Write-Error -Message "VMware core networking automation module could not be loaded..."
        }

    $VC = 'lab-vcsa-01.corp.local'
    

    Connect-VIServer -Server $VC

    #VC variables
    #Get our root folder 
    $folder = Get-Folder -NoRecursion
    $DC = 'Lab'
    <#Host(s) to add to the DC note we could also pull this from a CSV file #>
    $esxhosts = @('IP_OR_DNS')
    [Int32]$uplinks = 2
    $DvPGVMKM = "DvPG-VMK-Mgmt"
    $DvPGVM = "DvPG-VMTraffic"

    Write-Host "Creating datacenter"$DC -ForegroundColor Green

    try {
        New-Datacenter -Location $folder -Name $DC

    }

    catch{
        Write-Error -Message "Error Deploying new Datacenter:"$DC
    }


    Write-Host "Adding hosts(s) to the datacenter:"$DC -ForegroundColor Green
    try
        {
            for($i=0; $i -lt $esxhosts.length; $i++) {
                Add-VMHost -Name $esxhosts[$i] -Location $DC -Credential(Get-Credential) -Force -ErrorAction Stop
            }
        }
    catch
        {
            Write-Error -Message "Could not add host to datacenter:"$DC
        }

    <# Let's create our vDS #>
    Write-Host "Creating new vDS:DSwitch" -ForegroundColor Green

    try {

        $myDC = Get-Datacenter -Name $DC

        New-VDSwitch -Name "DSwitch" -Location $myDC -LinkDiscoveryProtocol "CDP" -LinkDiscoveryProtocolOperation "Both" -Version "6.5.0" -NumUplinkPorts $uplinks
}

catch{
    Write-Error -Message "Could not create new vDS:DSwitch"
}

    <# let's create a couple of portgroups on the vDS #>
    Write-Host "Creating some portgroups:"$DvPGVMKM $DvPGVM -ForegroundColor Green
     try {
        Get-VDSwitch -Name "DSwitch" | New-VDPortGroup -Name $DvPGVMKM
        Get-VDSwitch -Name "DSwitch" | New-VDPortGroup -Name $DvPGVM
}

catch{
    Write-Error -Message "Could not deploy the following DvPG's:"$DvPGVMKM $DvPGVM
}


    Write-Host "All done..." -ForegroundColor Green
