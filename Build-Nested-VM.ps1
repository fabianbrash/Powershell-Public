<#

  Control Names are exactly as they listed in the UI
  Name: SCSI controller 1

#>


Clear-Host

try {
    Import-Module -Name VMware.VimAutomation.Core
	}
	
catch{

    Write-Error -Message "Could not load VMware.VimAutomation.Core module..."
	}



#$user = "user@vsphere.local"
$Cred = Import-Clixml -Path C:\cred.Cred

$vc = "vcsa"

Connect-VIServer -Server $vc -Credential $Cred


$TheVM = Get-VM -Name tst1
$TheVMs = @("tst1", "tst2")
$VSS = Get-VirtualPortgroup -Name "VSS"
$VDS = Get-VDPortgroup -Name "vDS"

###Let's configure our VM's

$TheVMs | % {

  New-HardDisk -VM $_ -CapacityGB 20 -StorageFormat Thin | New-ScsiController -Type ParaVirtual
  New-HardDisk -VM $_ -CapacityGB 40 -StorageFormat Thin | New-ScsiController -Type ParaVirtual
  New-HardDisk -VM $_ -CapacityGB 40 -StorageFormat Thin | New-ScsiController -Type ParaVirtual

  $Scsi2 = Get-ScsiController -VM $_ -Name "SCSI controller 2"

  New-HardDisk -VM $_ -CapacityGB 40 -StorageFormat Thin -Controller $Scsi2

  ##Now let's add our networking
  New-NetworkAdapter -VM $_ -StartConnected -Type Vmxnet3 -NetworkName $VSS 
  New-NetworkAdapter -VM $_ -StartConnected -Type Vmxnet3 -NetworkName $VSS 
  New-NetworkAdapter -VM $_ -StartConnected -Type Vmxnet3 -NetworkName $VSS 
  #New-NetworkAdapter -VM $_ -StartConnected -Type Vmxnet3 -Portgroup $VDS 

  }


#Let's create 3 new hard disks and create a new PVSCI controller for each one

<#New-HardDisk -VM $TheVM -CapacityGB 1 -StorageFormat Thin | New-ScsiController -Type ParaVirtual
New-HardDisk -VM $TheVM -CapacityGB 2 -StorageFormat Thin | New-ScsiController -Type ParaVirtual
New-HardDisk -VM $TheVM -CapacityGB 3 -StorageFormat Thin | New-ScsiController -Type ParaVirtual#>

#Start-Sleep -Seconds 2
#Now let's add a 4th disk and assign it to SCSI controller 2
#$Scsi2 = Get-ScsiController -VM $TheVM -Name "SCSI controller 2"

#New-HardDisk -VM $TheVM -CapacityGB 4 -StorageFormat Thin -Controller $Scsi2


