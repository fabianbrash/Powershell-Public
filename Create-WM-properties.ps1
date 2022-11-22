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


$vc = "VC_IP_FQDN"
$namespaces = @("dev", "ssc", "prod")
$cluster = "cluster-01"
$spbmpolicy = "gold"



Connect-VIServer -Server $vc -User 'administrator@vsphere.local' -Password 'my_secret_password'

Write-Output "Creating all required namespaces..."

Start-Sleep -Seconds 2

foreach($ns in $namespaces) {
    
    New-WMNamespace -Name $ns -Cluster $cluster 

}

Write-Output "Assigning the edit role to all namespaces to administrator@vsphere.local..."

Start-Sleep -Seconds 2

foreach($perm in $namespaces) {

    New-WMNamespacePermission -Namespace $perm -Role Edit -Domain vsphere.local -PrincipalType User -PrincipalName Administrator
}

Write-Output "Assigning a storage policy to all namespaces..."

Start-Sleep -Seconds 2

$sp = Get-SpbmStoragePolicy -Name $spbmpolicy

foreach($spbm in $namespaces) {
    
    $nsObject = Get-WMNamespace $spbm
    New-WMNamespaceStoragePolicy -Namespace $nsObject -StoragePolicy $sp
}


Disconnect-VIServer * -Force -Confirm:$false
