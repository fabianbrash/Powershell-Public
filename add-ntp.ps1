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

Get-Cluster -Name "theCluster" | Get-VMHost | Add-VMHostNtpServer -NtpServer "ntp.enterprise.com"

#Get-VMHost -Name "h1" | Get-VMHostService

##Start the service
Get-Cluster -Name "thecluster" | Get-VMHost | Get-VMHostService | Where {$_.Key -eq "ntpd"} | Start-VMHostService

##Set policy to start and stop with host
Get-Cluster -Name "theCluster" | Get-VMHost | Get-VMHostService | Where {$_.Key -eq "ntpd"} | Set-VMHostService -Policy On


Get-VMHost -Name "h1" | Get-VMHostService
