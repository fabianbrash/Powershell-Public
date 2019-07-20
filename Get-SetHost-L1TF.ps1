<#
 REF:https://kb.vmware.com/s/article/56931
 #>


Clear-Host

try {
    Import-Module -Name VMware.VimAutomation.Core
	}
	
catch{

    Write-Error -Message "Could not load VMware.VimAutomation.Core module..."
	}


try {
    Import-Module -Name C:\HTAwareMitigation-1.0.0.19\HTAwareMitigation.psd1
	}
	
catch{

    Write-Error -Message "Could not load HTAwareMitigation module..."
	}


Set-PowerCLIConfiguration -DefaultVIServerMode Multiple -Confirm:$false | Out-Null

<# Do this for long vMotions 12.5 Hours for the script to complete #>
Set-PowerCLIConfiguration -WebOperationTimeoutSeconds 45000 -Confirm:$false | Out-Null


Connect-VIServer -Server $vc  -Credential $vcCred

Get-HTAwareMitigationAnalysis -Server vCenter_Server_Name

Write-Host "---------------------------------------------------------------------------------------------------------------"

Get-HTAwareMitigationAnalysis -ClusterName vSphere_Cluster_Name

Write-Host "---------------------------------------------------------------------------------------------------------------"

Get-HTAwareMitigationConfig -ClusterName "C2"

Write-Host "---------------------------------------------------------------------------------------------------------------"

Get-HTAwareMitigationConfig -ClusterName "C1"


Get-HTAwareMitigationConfig -VMHostName "host"

Write-Host "---------------------------------------------------------------------------------------------------------------"

Get-HTAwareMitigationConfig -VMHostName "host"


#Set-HTAwareMitigationConfig -VMHostName "host" -Enable -Confirm:$false

#Set-HTAwareMitigationConfig -VMHostName "host" -SCAv1 -Confirm:$false

#Set-HTAwareMitigationConfig -VMHostName "host" -SCAv2 -Confirm:$false

#Set-HTAwareMitigationConfig -VMHostName "host" -Disable

#Get-HTAwareMitigationConfig -VMHostName "host"


