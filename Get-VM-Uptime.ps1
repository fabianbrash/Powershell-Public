Clear-Host

<#
## Get VM uptime
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
$vc = "vc"

Connect-VIServer -Server $vc


$theVm = Get-VM -Name "C1"

$Uptime = Get-Stat -Entity $theVm -Stat sys.uptime.latest -Realtime -MaxSamples 1
$TimeSpan = New-TimeSpan -Seconds $Uptime.Value

$TimeSpan
