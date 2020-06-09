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
$outPutA=@()
$outPutallWindows=@()
$targetSpace=100

$vc = "vc"


Connect-VIServer -Server $vc

<#Get All VM's#>
#$VMs = Get-VM

<#Just Windows VM's#>
$VMs = Get-VM | Where-Object {$_.GuestId -like "windows*"}

#$VM

foreach($VM in $VMs) {

    $outPutA += $VM.ExtensionData.Guest.Disk | Select-Object @{n='Name';e={$VM.Name}},DiskPath,Capacity,FreeSpace | Where-Object {$_.FreeSpace/1GB -lt 19 }

    $outPut+= $VM.ExtensionData.Guest.Disk | Where-Object {$_.FreeSpace/1GB -lt $targetSpace} | `
    Select-Object @{N='Name';e={$VM.Name}},DiskPath,@{N='capacity';e={[math]::Round($_.Capacity/1GB)}}, `
    @{N='freespace';e={[math]::Round($_.FreeSpace/1GB)}}, `
    @{N='freespace %';e={[math]::Round(((100*($_.FreeSpace))/($_.Capacity)),0)}} | Where-Object {$_.DiskPath -eq 'C:\'}

    $outPutallWindows+= $VM.ExtensionData.Guest.Disk | Select-Object @{N='Name';e={$VM.Name}}, DiskPath, @{N='Capacity';e={[math]::Round($_.Capacity/1GB)}}, @{N='FreeSpace';e={[math]::Round($_.FreeSpace/1GB)}} 

}

$outPut | ConvertTo-Json -AsArray | Out-File -FilePath "~/go/static/win_low_root.json"
#$outPutA | Format-Table -AutoSize
#$outPutA | ConvertTo-Json -AsArray | Out-File -FilePath ~/diskData.json -Width 10000
#$outPut | Export-Csv -Path ~/Desktop/inGuestSpace.csv -NoTypeInformation

#$outPutallWindows | Format-Table -AutoSize

#$outPutallWindows | ConvertTo-Json -AsArray | Out-File -FilePath "~/go/static/all_windows.json"

Disconnect-VIServer * -Force -Confirm:$false
