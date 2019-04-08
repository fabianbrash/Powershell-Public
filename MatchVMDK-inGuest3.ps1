
Clear-Host

################################################
# Configure the variables below for the vCenter
################################################
$VMName = "vm"
$vCenter = "vc"
#$ScriptDirectory = "C:\MatchingDriveLettersToVMDKsv1"
################################################
# Running the script, nothing to change below
################################################
#######################
# Importing Guest VM credentials
#######################
# Setting credential file
#$VMCredentialsFile = $ScriptDirectory + "\VMCredentials.xml"
# Testing if file exists
#$VMCredentialsFileTest =  Test-Path $VMCredentialsFile
# IF doesn't exist, prompting and saving credentials
<#IF ($VMCredentialsFileTest -eq $False)
{
$VMCredentials = Get-Credential -Message "Enter VM script run credentials"
$VMCredentials | EXPORT-CLIXML $VMCredentialsFile -Force
}
ELSE
{
 Importing credentials
$VMCredentials = IMPORT-CLIXML $VMCredentialsFile
}#>
#######################
# Importing vCenter credentials
#######################
# Setting credential file
<#$vCenterCredentialsFile = $ScriptDirectory + "\vCenterCredentials.xml"
# Testing if file exists
$vCenterCredentialsFileTest =  Test-Path $vCenterCredentialsFile
# IF doesn't exist, prompting and saving credentials
IF ($vCenterCredentialsFileTest -eq $False)
{
$vCenterCredentials = Get-Credential -Message "Enter vCenter login credentials"
$vCenterCredentials | EXPORT-CLIXML $vCenterCredentialsFile -Force
}
ELSE
{
# Importing credentials
$vCenterCredentials = IMPORT-CLIXML $vCenterCredentialsFile
}
#######################
# Installing then importing PowerCLI module
#######################
$PowerCLIModuleCheck = Get-Module -ListAvailable VMware.PowerCLI
IF ($PowerCLIModuleCheck -eq $null)
{
Install-Module -Name VMware.PowerCLI –Scope CurrentUser -Confirm:$false -AllowClobber
}
#>
# Importing PowerCLI
try {
    Import-Module -Name VMware.VimAutomation.Core
	}
	
catch{

    Write-Error -Message "Could not load VMware.VimAutomation.Core module..."
	}


$vcCred = Import-Clixml -Path "C:\mx.Cred"
$cred = Import-Clixml -Path "C:\mx1.Cred"	
#######################
# Connecting to vCenter
#######################
Connect-VIServer -Server $vCenter -Credential $vcCred
#####################
# Getting VM guest disk info
#####################
$VMGuestDiskScript = Invoke-VMScript -ScriptText {
# Creating alphabet array
$Alphabet=@()
65..90|ForEach{$Alphabet+=[char]$_}
# Getting drive letters inside the VM where the drive letter is in the alphabet
$DriveLetters = Get-Partition | Where-Object {($Alphabet -match $_.DriveLetter)} | Select -ExpandProperty DriveLetter
# Reseting serials
$DiskArray = @()
# For each drive letter getting the serial number
ForEach ($DriveLetter in $DriveLetters)
{
# Getting disk info
$DiskInfo = Get-Partition -DriveLetter $DriveLetter | Get-Disk | Select *
$DiskSize = $DiskInfo.Size
$DiskUUID = $DiskInfo.SerialNumber
# Formatting serial to match in vSphere, if not null
IF ($DiskSerial -ne $null)
{
$DiskSerial = $DiskSerial.Replace("_","").Replace(".","")
}
# Adding to array
$DiskArrayLine = New-Object PSObject
$DiskArrayLine | Add-Member -MemberType NoteProperty -Name "DriveLetter" -Value "$DriveLetter"
$DiskArrayLine | Add-Member -MemberType NoteProperty -Name "SizeInBytes" -Value "$DiskSize"
$DiskArrayLine | Add-Member -MemberType NoteProperty -Name "UUID" -Value "$DiskUUID"
$DiskArray += $DiskArrayLine
}
# Converting Disk Array to CSV data format
$DiskArrayData = $DiskArray | ConvertTo-Csv
# Returning Disk Array CSV data to main PowerShell script
$DiskArrayData
# End of invoke-vmscript below
} -VM $VMName -ToolsWaitSecs 120 -GuestCredential $cred
# Pulling the serials from the invoke-vmscript and trimming blank spaces
$VMGuestDiskCSVData = $VMGuestDiskScript.ScriptOutput.Trim()
# Converting from CSV format
$VMGuestDiskData = $VMGuestDiskCSVData | ConvertFrom-Csv
# Hostoutput of VM Guest Data
"
VMGuestDiskData:" 
$VMGuestDiskData | Format-Table -AutoSize
#####################
# Building list of VMDKs for the Customer VM
#####################
# Creating array
$VMDKArray = @()
# Getting VMDKs for the VM
$VMDKs = Get-VM $VMName | Get-HardDisk
# For Each VMDK building table array
ForEach($VMDK in $VMDKs)
{
# Getting VMDK info
$VMDKFile = $VMDK.Filename
$VMDKName = $VMDK.Name
$VMDKControllerKey = $VMDK.ExtensionData.ControllerKey
$VMDKUnitNumber = $VMDK.ExtensionData.UnitNumber
$VMDKDiskDiskSizeInGB = $VMDK.CapacityGB
$VMDKDiskDiskSizeInBytes = $VMDK.ExtensionData.CapacityInBytes
# Getting UUID
$VMDKUUID = $VMDK.extensiondata.backing.uuid.replace("-","")
# Using Controller key to get SCSI bus number
$VMDKBus = $VMDK.Parent.Extensiondata.Config.Hardware.Device | Where {$_.Key -eq $VMDKControllerKey}
$VMDKBusNumber = $VMDKBus.BusNumber
# Creating SCSI ID
$VMDKSCSIID = "scsi:"+ $VMDKBusNumber + ":" + $VMDKUnitNumber
# Matching VMDK to drive letter based on UUID first, if no serial UUID matching on size in bytes
$VMDKDiveLetter = $VMGuestDiskData | Where-Object {$_.UUID -eq $VMDKUUID} | Select -ExpandProperty DriveLetter
$VMDKMatchOn = "UUID"
IF ($VMDKDiveLetter -eq $null)
{
$VMDKDiveLetter = $VMGuestDiskData | Where-Object {$_.SizeInBytes -eq $VMDKDiskDiskSizeInBytes} | Select -ExpandProperty DriveLetter
$VMDKMatchOn = "Size"
}
# Matching drive letter for marking SWAP disk
IF ($SWAPDriveLetters -match $VMDKDiveLetter)
{
$VMDKSwap = "true"
}
ELSE
{
$VMDKSwap = "false"
}
# Creating array of VMDKs
$VMDKArrayLine = New-Object PSObject
$VMDKArrayLine | Add-Member -MemberType NoteProperty -Name "VM" -Value $VMName
$VMDKArrayLine | Add-Member -MemberType NoteProperty -Name "DiskName" -Value $VMDKName
$VMDKArrayLine | Add-Member -MemberType NoteProperty -Name "DriveLetter" -Value $VMDKDiveLetter
$VMDKArrayLine | Add-Member -MemberType NoteProperty -Name "MatchedOn" -Value $VMDKMatchOn
$VMDKArrayLine | Add-Member -MemberType NoteProperty -Name "DiskSizeGB" -Value $VMDKDiskDiskSizeInGB
$VMDKArrayLine | Add-Member -MemberType NoteProperty -Name "SCSIBus" -Value $VMDKBusNumber
$VMDKArrayLine | Add-Member -MemberType NoteProperty -Name "SCSIUnit" -Value $VMDKUnitNumber
$VMDKArrayLine | Add-Member -MemberType NoteProperty -Name "SCSIID" -Value $VMDKSCSIID
$VMDKArrayLine | Add-Member -MemberType NoteProperty -Name "DiskUUID" -Value $VMDKUUID
$VMDKArrayLine | Add-Member -MemberType NoteProperty -Name "DiskSizeBytes" -Value $VMDKDiskDiskSizeInBytes
$VMDKArrayLine | Add-Member -MemberType NoteProperty -Name "DiskFile" -Value $VMDKFile
$VMDKArray += $VMDKArrayLine
}
#####################
# Final host output of VMDK array
#####################
$VMDKArray | Format-Table -AutoSize
#####################
# End of script
#####################



Write-Host "--------------------------------------------------------------------------------------------------------------------------------------------------------------------------"
Write-Host "--------------------------------------------------------------------------------------------------------------------------------------------------------------------------"




$vmName = $VMName
## modification below here not necessary to run  
#$win32DiskDrive  = Get-WmiObject -Class Win32_DiskDrive -ComputerName $vmName -Credential $cred
$vmHardDisks = Get-VM -Name $vmName | Get-HardDisk 
$vmDatacenterView = Get-VM -Name $vmName | Get-Datacenter | Get-View 
$virtualDiskManager = Get-View -Id VirtualDiskManager-virtualDiskManager


<#$diskToDriveVolume = Get-WmiObject Win32_DiskDrive -ComputerName $vmName -Credential $cred

Get-WmiObject -Query $partitions -ComputerName $vmName -Credential $cred| % {
    $partition = $_
    $drives = "ASSOCIATORS OF " +
              "{Win32_DiskPartition.DeviceID='$($partition.DeviceID)'} " +
              "WHERE AssocClass = Win32_LogicalDiskToPartition"
    Get-WmiObject -Query $drives  -ComputerName $vmName -Credential $cred| % {
#>

$code = Invoke-VMScript -ScriptText {

$win32DiskDrive  = Get-WmiObject -Class Win32_DiskDrive


$diskToDriveVolume = Get-WmiObject Win32_DiskDrive | % {
  $disk = $_
  $partitions = "ASSOCIATORS OF " +
                "{Win32_DiskDrive.DeviceID='$($disk.DeviceID)'} " +
                "WHERE AssocClass = Win32_DiskDriveToDiskPartition"
  Get-WmiObject -Query $partitions | % {
    $partition = $_
    $drives = "ASSOCIATORS OF " +
              "{Win32_DiskPartition.DeviceID='$($partition.DeviceID)'} " +
              "WHERE AssocClass = Win32_LogicalDiskToPartition"
    Get-WmiObject -Query $drives | % {
      New-Object -Type PSCustomObject -Property @{
        Disk        = $disk.DeviceID
        DriveLetter = $_.DeviceID
        VolumeName  = $_.VolumeName
 
      }
    }
  }

  #$Volumes = $diskToDriveVolume | ConvertTo-Csv
  #$Volumes
}

foreach ($disk in $win32DiskDrive)  
{  
  $disk | Add-Member -MemberType NoteProperty -Name AltSerialNumber -Value $null 
  $diskSerialNumber = $disk.SerialNumber  
  if ($disk.Model -notmatch 'VMware Virtual disk SCSI Disk Device')  
  {  
    if ($diskSerialNumber -match '^\S{12}$'){$diskSerialNumber = ($diskSerialNumber | foreach {[byte[]]$bytes = $_.ToCharArray(); $bytes | foreach {$_.ToString('x2')} }  ) -join ''}  
    $disk.AltSerialNumber = $diskSerialNumber 
  }
  
  $win32DiskDriveData = $win32DiskDrive | ConvertTo-Csv
  $win32DiskDriveData
  }

} -GuestCredential $cred -VM $vmName


#Invoke-VMScript -ScriptText $code -ScriptType Powershell -GuestCredential $cred -VM $vmName

$VMGuestDiskCSVData = $code.ScriptOutput.Trim()

$win32DiskDrive = $VMGuestDiskCSVData | ConvertFrom-Csv
 
$results = @()  
foreach ($vmHardDisk in $vmHardDisks)  
{  
 
  $vmHardDiskUuid = $virtualDiskManager.queryvirtualdiskuuid($vmHardDisk.Filename, $vmDatacenterView.MoRef) | foreach {$_.replace(' ','').replace('-','')}  
  $windowsDisk = $win32DiskDrive | where {$_.SerialNumber -eq $vmHardDiskUuid}  
  if (-not $windowsDisk){$windowsDisk = $win32DiskDrive | where {$_.AltSerialNumber -eq $vmHardDisk.ScsiCanonicalName.substring(12,24)}}  
  $result = "" | select vmName,vmHardDiskDatastore,vmHardDiskVmdk,vmHardDiskName,windowsDiskIndex,windowsDiskSerialNumber,vmHardDiskUuid,windowsDeviceID,drives,volumes  
  $result.vmName = $vmName.toupper()  
  $result.vmHardDiskDatastore = $vmHardDisk.filename.split(']')[0].split('[')[1]  
  $result.vmHardDiskVmdk = $vmHardDisk.filename.split(']')[1].trim()  
  $result.vmHardDiskName = $vmHardDisk.Name  
  $result.windowsDiskIndex = if ($windowsDisk){$windowsDisk.Index}else{"FAILED TO MATCH"}  
  $result.windowsDiskSerialNumber = if ($windowsDisk){$windowsDisk.SerialNumber}else{"FAILED TO MATCH"}  
  $result.vmHardDiskUuid = $vmHardDiskUuid  
  $result.windowsDeviceID = if ($windowsDisk){$windowsDisk.DeviceID}else{"FAILED TO MATCH"}  
  $driveVolumes = $diskToDriveVolume | where {$_.Disk -eq $windowsDisk.DeviceID}
  $result.drives = $driveVolumes.DriveLetter
  $result.volumes = $driveVolumes.VolumeName
  $results += $result
}  
$results = $results | sort {[int]$_.vmHardDiskName.split(' ')[2]}

$results | Select-Object -Property vmName, vmHardDiskDatastore, vmHardDiskVmdk, vmHardDiskName, windowsDiskIndex, windowsDeviceID | ft




Write-Host "--------------------------------------------------------------------------------------------------------------------------------------------------------------------------"
Write-Host "--------------------------------------------------------------------------------------------------------------------------------------------------------------------------"
