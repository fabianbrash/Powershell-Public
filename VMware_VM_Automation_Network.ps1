#Filename:            VMware_VM_Automation_Network.ps1
#Author:              Fabian Brash
#Date:                11-01-2016
#Modified:            11-01-2016
#Purpose:             Create a virtual portGroup on a VSS and or create a new VSS



<#________   ________   ________      
|\   __  \ |\   __  \ |\   ____\     
\ \  \|\  \\ \  \|\  \\ \  \___|_    
 \ \   _  _\\ \   ____\\ \_____  \   
  \ \  \\  \|\ \  \___| \|____|\  \  
   \ \__\\ _\ \ \__\      ____\_\  \ 
    \|__|\|__| \|__|     |\_________\
                         \|_________|#>
                                     

Clear-Host

try
    {
        Import-Module -Name VMware.VimAutomation.Core -ErrorAction Stop
    }
catch
    {
        Write-Error -Message "VmWare core automation module could not be loaded..."
    }


$VC = "Vcenter"
$VCenteruser = "fabian@vsphere2.local"
$VCenterPassFile = 'C:\passfile.txt'
$MyVCenterCred = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $VCenteruser, (Get-Content $VCenterPassFile | ConvertTo-SecureString)

Connect-ViServer -Server $VC

<#Variables#>
$vSwitch = "vSwitch0"
$vPortGroupName = "LabVMTraffic"
$VMHost = "FQDN or IP"
$vmnics = "vmnic2"

#Create a port group Name LabVMTraffic on our vSwitch0
#$vportGroup = New-VirtualPortGroup -VirtualSwitch $vSwitch -Name $vPortGroupName
Get-VirtualSwitch -Name $vswitch | New-VirtualPortGroup -Name $vPortGroupName

#Now lets create a new vSwitch on our host or hosts and add a NIC or NICS to it
$vSwitch01 = "vSwitch01"
Get-VMHost -Name $VMHost | New-VirtualSwitch -Name $vSwitch01 -Nic $vmnics -Mtu 1500 -NumPorts 128

