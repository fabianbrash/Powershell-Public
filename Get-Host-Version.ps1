Clear-Host

try {
    Import-Module -Name VMware.VimAutomation.Core
	}
	
catch{

    Write-Error -Message "Could not load VMware.VimAutomation.Core module..."
	}


Set-PowerCLIConfiguration -DefaultVIServerMode Multiple -Confirm:$false | Out-Null

<# Do this for long vMotions 12.5 Hours for the script to complete #>
Set-PowerCLIConfiguration -WebOperationTimeoutSeconds 45000 -Confirm:$false | Out-Null


Connect-VIServer -Server $vc

# why doesn't this work?? $host = Get-VMHost -Name "host"

$esxcli = Get-EsxCli -VMHost "host"

$esxcli.system.version.get().version+ " Update"+$esxcli.system.version.get().update



Write-Host "---------------------------------------------------------------------------------------------------------------------------------------------"
Write-Host "`t`tvSphere SOAP API"
Write-Host "---------------------------------------------------------------------------------------------------------------------------------------------"

$vmhost = Get-VmHost -Name "host"

$esxi_version = $vmhost.ExtensionData.Config.Product.Version
$esxi_build = $vmhost.ExtensionData.Config.Product.Build
$esxi_update_level = (Get-AdvancedSetting -Entity $vmhost -Name Misc.HostAgentUpdateLevel).Value

Write-Host "`tHost:    $vmhost"
Write-Host "`tVersion: $esxi_version"
Write-Host "`tUpdate:  $esxi_update_level"
Write-Host "`tBuild:   $esxi_build"

