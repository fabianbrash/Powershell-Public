Clear-Host

try {
#Import-Module -Name HPESmartArrayCmdlets
Import-Module -Name HPEiLOCmdlets

}

catch{
#Write-Error -Message "Cannot Load Module HPESmartArrayCmdlets"
Write-Error -Message "Cannot Load Module HPEiLOCmdlets"
}



$cred = Get-Credential

$iLOs = @("1.1.1.1", "2.2.2.2")

#$SAsession = Connect-HPESA -IP 1.1.1.1 -Credential $cred -DisableCertificateAuthentication
#$SAsession = Connect-HPESA -IP 2.2.2.2 -Credential $cred -DisableCertificateAuthentication

<#$diskInfo = Get-HPESAPhysicalDrive -Connection $SAsession

$diskInfo | Select-Object -Property @{n='MediaType'; e={$_.PhysicalDrive.MediaType}}, @{n='CapacityGB'; e={$_.PhysicalDrive.CapacityGB}}, @{n='FirmwareVersion'; e={$_.PhysicalDrive.FirmwareVersion}}, `
@{n='Model'; e={$_.PhysicalDrive.Model}}, @{n='SerialNumber'; e={$_.PhysicalDrive.SerialNumber}}

#CapacityGB, FirmwareVersion, Model, SerialNumber, MediaType, Model

#PhysicalDrive
Disconnect-HPESA -Connection $SAsession
#>


$ILOsession = Connect-HPEiLO -IP $iLOs -Credential $cred -DisableCertificateAuthentication

$diskInfo = Get-HPEiLOSmartArrayStorageController -Connection $ILOsession

$diskInfo | ForEach-Object {

    $_.HostName

    $_.Controllers.PhysicalDrives | Select-Object -Property CapacityGB, FirmwareVersion, MediaType, Model, SerialNumber | Where-Object {$_.MediaType -eq 'SSD'}
    Write-Output "==========================================================================================================="

}

#$diskInfo.HostName

#$diskInfo.Controllers.PhysicalDrives | Select-Object -Property CapacityGB, FirmwareVersion, MediaType, Model, SerialNumber

Disconnect-HPEiLO -Connection $ILOsession
