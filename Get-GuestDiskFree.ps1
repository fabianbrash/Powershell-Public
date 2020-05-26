<#
## Get in guest disk space
#>

Clear-Host


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
$outPut=@()

$vc = "tdctlvcsa01.alexander.io"


Connect-VIServer -Server $vc

<#Get All VM's#>
#$VMs = Get-VM

<#Just Windows VM's#>
$VMs = Get-VM | Where-Object {$_.GuestId -like "windows*"}

#$VM

foreach($VM in $VMs) {
    
    $outPut+= $VM.ExtensionData.Guest.Disk | Where-Object {$_.FreeSpace/1GB -lt 20} | `
    Select-Object @{N='Name';e={$VM.Name}},DiskPath,@{N='Capacity(GB)';e={[math]::Round($_.Capacity/1GB)}}, `
    @{N='Free Space(GB)';e={[math]::Round($_.FreeSpace/1GB)}}, `
    @{N='Free Space %';e={[math]::Round(((100*($_.FreeSpace))/($_.Capacity)),0)}} | Where-Object {$_.DiskPath -eq 'C:\'}

}

#$outPut | Format-Table -AutoSize

$outPut | Export-Csv -Path ~/Desktop/inGuestSpace.csv -NoTypeInformation

Disconnect-VIServer * -Force -Confirm:$false
