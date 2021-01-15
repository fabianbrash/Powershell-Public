Clear-Host

try {
  Import-Module -Name VMware.VimAutomation.Core -ErrorAction Stop
}

catch {
  Write-Error -Message "Could not load core module..."
}


$vc = "vc1"

Connect-VIServer -Server $vc

Get-Cluster | Get-VM | Select-Object -Property @{name='Cluster';e={$_.VMHost.Parent}}, Name, VmHost | Format-Table -AutoSize
#Get-Cluster | Get-VM | Select-Object -Property @{name='Cluster';e={$_.VMHost.Parent}}, Name, VmHost | Export-Csv -Path C:\data.csv -NoTypeInformation
