#Filename:            VMware_VM_Automation.ps1
#Author:              Fabian Brash
#Date:                09-28-2016
#Modified:            10-28-2016
#Purpose:             Deploy and Customize a VM **Must be run in x86 version of Powershell or PowerCLI



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



#Get-OSCustomizationSpec -Name "Server2012-Customization_Automation"
#Get-OSCustomizationSpec -Name "Server2012-Customization_Automation" | Get-OSCustomizationNicMapping

$RPS_DataStore = "VMData"
$VMNetwork = "LabVMTraffic"
$VMName = 'lab-fs-01'
$VMNameArray = @('lab-fs-01','lab-fs-02')
$RPS_Folder = 'Infrastructure'
$SourceCustomization = "Server2016_PowerCLI"
$Subnet = '255.255.255.0'
$RPS_IPMode = 'UseStaticIp'
$RPS_IPAddress = '192.168.1.230'
$VM_IP = @('192.168.1.230','192.168.1.231')
$Gateway = '192.168.1.1'
$RPS_DNS = '192.168.1.222'
$RPS_DNS2 = 'YOUR DNS2'
$vCenter = "lab-vcsa-01.lab.net"
$RPS_Description = 'Infrastructure File Server number 1'
$VMDesc = @('Infrastructure File Server number 1','Infrastructure File Server number 2')


Connect-ViServer -Server $vCenter

#Variables from inside vCenter
#$TargetCluster = Get-Cluster -Name "YOUR CLUSTER"
$TargetHost = Get-VMHost -Name '192.168.1.216'
$SourceTemplate = Get-Template -Name "template2016"


#$nicMapping = Get-OSCustomizationNicMapping -OSCustomizationSpec -Name $SourceCustomization | where {$_.Position -eq 1}
#Get-OSCustomizationSpec $SourceCustomization | Get-OSCustomizationNicMapping | Set-OSCustomizationNicMapping -IpMode $RPS_IPMode -IpAddress $RPS_IPAddress -SubnetMask $Subnet -DefaultGateway $Gateway -Dns $RPS_DNS

Write-Verbose -Message "Beginning deployment of VM(s)..." -Verbose
for($i=0; $i -lt $VMNameArray.Length; $i++) {
        try{

            Get-OSCustomizationSpec $SourceCustomization | Get-OSCustomizationNicMapping | Set-OSCustomizationNicMapping -IpMode $RPS_IPMode -IpAddress $VM_IP[$i] -SubnetMask $Subnet -DefaultGateway $Gateway -Dns $RPS_DNS
            
            New-VM -Name $VMNameArray[$i] -VMHost $TargetHost -Location $RPS_Folder -Datastore $RPS_DataStore -Template $SourceTemplate -OSCustomizationSpec $SourceCustomization -Description $VMDesc[$i] -ErrorAction Stop
            Start-VM -VM $VMNameArray[$i]
            <#New-VM -Name $VMNameArray[1] -VMHost $TargetHost -Location $RPS_Folder -Datastore $RPS_DataStore -Template $SourceTemplate -OSCustomizationSpec $SourceCustomization -Description $VMDesc[1] -ErrorAction Stop
            Start-VM -VM $VMNameArray[1]#>
            }

    #-RunAsync Do not add to New-Vm command if you want to use Start-VM -VM $myVM command
    #-ResourcePool $TargetCluster
    catch{
        Write-Error "Deployment Failed..."
    }
}



Write-Verbose -Message "Deployment Completed Successfully..." -Verbose