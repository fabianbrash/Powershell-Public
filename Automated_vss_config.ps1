

Clear-Host

try {
        Import-Module -Name VMware.VimAutomation.Core -ErrorAction Stop
    }

catch {
        Write-Error -Message "Error loading core VMware module"
      }




$TheVSS = 'vSwitch2'
$JumboFrames = '9000'
#$TheHost = 'compute-01.rps.edu'
$TheHostTemp = '10.216.4.9'
$TheVMK900 = 'VMk-VMotion900'
$TheVMKSimpliv = 'SVT_StorPG'
$TestPG = 'TestPG'
$TheVLAN = '100'
$vMotionIP = '10.10.90.185'
$vMotionSub = '255.255.255.0'
$VMKSimplivIP = '10.10.94.185'
$VMKSimplivSub = '255.255.255.0'


Connect-VIServer -Server $TheHostTemp

#Create a new vss
New-VirtualSwitch -VMHost $TheHostTemp -Name $TheVSS -Mtu $JumboFrames -WhatIf

#Add a PG to the vss
New-VirtualPortGroup -VirtualSwitch $TheVSS -Name $TestPG -VLanId $TheVLAN -WhatIf

#Set the specified vss to an mtu of 9000
Set-VirtualSwitch -VirtualSwitch $TheVSS -Mtu $JumboFrames

#Create a VMK for vMotion on vswitch0
New-VMHostNetworkAdapter -VMHost $TheHostTemp -PortGroup $TheVMK900 -VirtualSwitch $TheVSS -IP $vMotionIP -SubnetMask $vMotionSub -Mtu $JumboFrames -VMotionEnabled:$true

#Create a VMK for Simplivity Storage on vswitch0
New-VMHostNetworkAdapter -VMHost $TheHostTemp -PortGroup $TheVMKSimpliv -VirtualSwitch $TheVSS -IP $VMKSimplivIP -SubnetMask $VMKSimplivSub -Mtu $JumboFrames