<#
## Get VM Datastore
#>


try {

    Import-Module VMware.VimAutomation.Core -ErrorAction Stop
}

catch {
    Write-Error -Message "VMware core automation module could not be loaded..."
}

####Ignore Certificate issues this resolves an issue with New-VM in PowerCLI 11.0 but I'm certain for peace of mind just do this by default

Set-PowerCLIConfiguration -InvalidCertificateAction Ignore -confirm:$false


$vc = 'VCENTER'

Connect-VIServer -server $vc

$TheCluster = "MyCluster"

$VMs = Get-Cluster -Name $TheCluster | Get-VM

$VMs | Select-Object -Property Name, @{n='Datastore';e={(Get-Datastore - Id $_.DatastoreIdList | Select-Object -ExpandProperty Name)}},`
@{n='Folder';e={$_.Folder.Name}} | Out-GridView

$Count = ($VMs).count

Write-Output "Number of VMs in the cluster: $Count"

Disconnect-VIServer * -Force -Confirm:$false
