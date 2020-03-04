Clear-Host

try {

    Import-Module VMware.VimAutomation.Core -ErrorAction Stop
}

catch {
    Write-Error -Message "VMware core automation module could not be loaded..."
}

####Ignore Certificate issues this resolves an issue with New-VM in PowerCLI 11.0 but I'm certain for peace of mind just do this by default

Set-PowerCLIConfiguration -InvalidCertificateAction Ignore -confirm:$false


<# VARS #>
$Output=@()
$vc = "vc"


Connect-VIServer -Server $vc

$VMs = Get-VM

$VMs | ForEach-Object {

    if($_.ExtensionData.Guest.Hostname | Where-Object {$_ -like "*.domain.com*" -or $_ -like $_ "*.domain2.com*"} ) {
        
        <# Let's filter our output for specific domains#>
        $Output+= $_ | Select-Object -Property @{n='VM Name';e={$_.Name}}, @{n='Domain Name'; e={$_.ExtensionData.Guest.Hostname}}, @{n='Configured OS';e={$_.ExtensionData.Config.GuestFullName}}, @{n='Running OS';e={$_.ExtensionData.Guest.GuestFullName}}

    }
    
    
}

$Output | Format-Table -AutoSize
$Output | Format-Table -AutoSize | Out-File -FilePath C:\data.txt -Width 10000

Disconnect-ViServer * -Force -Confirm:$false
