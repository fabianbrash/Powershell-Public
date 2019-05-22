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

[int]$isDEV = 1
$VMs = @("1", "2", "5")
$Hosts = @("h2", "h1")
$Stats = @()
$hStats = @()

$vc2 = "vc"

Connect-VIServer -Server $vc2 -Credential $vcCred


$VMs | % {
$Stats += Get-VM -Name $_ | Get-Stat -Stat "mem.usage.average" -Start 05/13/2019 -Finish 05/21/2019 | Select-Object -Property Value, Timestamp, Unit, Entity, MetricId
$Stats += Get-VM -Name $_ | Get-Stat -Stat "cpu.usage.average" -Start 05/13/2019 -Finish 05/21/2019 | Select-Object -Property Value, Timestamp, Unit, Entity, MetricId
$Stats += Get-VM -Name $_ | Get-Stat -Stat "cpu.usagemhz.average" -Start 05/13/2019 -Finish 05/21/2019 | Select-Object -Property Value, Timestamp, Unit, Entity, MetricId

}

$Stats | Export-Csv -Path C:\stats.csv -NoTypeInformation

$Hosts | % {

$hStats += Get-VMHost -Name $_ | Get-Stat -Stat "mem.usage.average" -Start 05/13/2019 -Finish 05/21/2019 | Select-Object -Property Value, Timestamp, Unit, Entity, MetricId
$hStats += Get-VMHost -Name $_ | Get-Stat -Stat "cpu.usage.average" -Start 05/13/2019 -Finish 05/21/2019 | Select-Object -Property Value, Timestamp, Unit, Entity, MetricId


}

$hStats | Export-Csv -Path C:\stats.csv -NoTypeInformation -Append

Get-StatType -Entity "h1"
Write-Host "------------------------------------------------------------------------------------------------------"
Get-StatType -Entity "1"
