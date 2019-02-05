#Filename:            VMware_VM_Automation.ps1
#Author:              Fabian Brash
#Date:                09-28-2016
#Modified:            10-23-2017
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

$RPS_DataStore = "yourdatastore"
$VMNetwork = "yournetwork"
$VMName = "tst-mgmt-02"
$RPS_Folder = 'yourfolder'
$SourceCustomization = "Server2016-Customization_PowerCLI"
$SourceCustomization2012 = "Server2012R2-Customization_PowerCLI"
$Subnet = '255.255.255.0'
$RPS_IPMode = 'UseStaticIp'
$RPS_IPAddress = 'IP'
$Gateway = 'Gateway'
$RPS_DNS = 'DNS'
$RPS_DNS2 = 'DNS'
$vCenter = "yourvcenter"
$RPS_Description = "Testing"
[int]$OSClass = 1

Write-Host "======================================================================"
Write-Host "1. Server 2016(GUI)"
Write-Host "2. Server 2012R2(GUI)"
Write-Host ""
Write-Host "======================================================================"

##Let's get input from user to see if they want to deploy a 2016 or 2012R2 VM
$OSClass = Read-Host "Enter 1 to deploy Server 2016 or a 2 to deploy Server 2012R2"

Connect-ViServer -Server $vCenter

#Variables from inside vCenter
$Srv2k12R2Template = "srv2012R2-template"
$Srv2k16Template = "srv16-template"

$TargetCluster = Get-Cluster -Name "Schools"

Write-Verbose -Message "Beginning deployment of VM..." -Verbose


try{
    switch($OSClass) {
      #$nicMapping = Get-OSCustomizationNicMapping -OSCustomizationSpec -Name $SourceCustomization | where {$_.Position -eq 1}
      1 {
         Get-OSCustomizationSpec $SourceCustomization | Get-OSCustomizationNicMapping | Set-OSCustomizationNicMapping -IpMode $RPS_IPMode -IpAddress $RPS_IPAddress -SubnetMask $Subnet -DefaultGateway $Gateway -Dns $RPS_DNS
         $SourceTemplate = Get-Template -Name $Srv2k16Template
         New-VM -Name $VMName -ResourcePool $TargetCluster -Location $RPS_Folder -Datastore $RPS_DataStore -Template $SourceTemplate -OSCustomizationSpec $SourceCustomization -Description $RPS_Description -ErrorAction Stop
         Get-NetworkAdapter -VM $VMName | Set-NetworkAdapter -NetworkName $VMNetwork -Confirm:$false
         Start-VM -VM $VMName
         #-RunAsync Do not add to New-Vm command if you want to use Start-VM -VM $myVM command
         }
         
     2 {
        #$nicMapping = Get-OSCustomizationNicMapping -OSCustomizationSpec -Name $SourceCustomization | where {$_.Position -eq 1}
        Get-OSCustomizationSpec $SourceCustomization2012 | Get-OSCustomizationNicMapping | Set-OSCustomizationNicMapping -IpMode $RPS_IPMode -IpAddress $RPS_IPAddress -SubnetMask $Subnet -DefaultGateway $Gateway -Dns $RPS_DNS
        $SourceTemplate = Get-Template -Name $Srv2k12R2Template
        New-VM -Name $VMName -ResourcePool $TargetCluster -Location $RPS_Folder -Datastore $RPS_DataStore -Template $SourceTemplate -OSCustomizationSpec $SourceCustomization2012 -Description $RPS_Description -ErrorAction Stop
        Get-NetworkAdapter -VM $VMName | Set-NetworkAdapter -NetworkName $VMNetwork -Confirm:$false
        Start-VM -VM $VMName
        #-RunAsync Do not add to New-Vm command if you want to use Start-VM -VM $myVM command
     }

    default {
          Write-Error -Message "You did not make a correct selection..."
          Exit
    }

 <#if($OSClass -eq 1) {
   #$nicMapping = Get-OSCustomizationNicMapping -OSCustomizationSpec -Name $SourceCustomization | where {$_.Position -eq 1}
   Get-OSCustomizationSpec $SourceCustomization | Get-OSCustomizationNicMapping | Set-OSCustomizationNicMapping -IpMode $RPS_IPMode -IpAddress $RPS_IPAddress -SubnetMask $Subnet -DefaultGateway $Gateway -Dns $RPS_DNS
   $SourceTemplate = Get-Template -Name $Srv2k16Template
    New-VM -Name $VMName -ResourcePool $TargetCluster -Location $RPS_Folder -Datastore $RPS_DataStore -Template $SourceTemplate -OSCustomizationSpec $SourceCustomization -Description $RPS_Description -ErrorAction Stop
    Get-NetworkAdapter -VM $VMName | Set-NetworkAdapter -NetworkName $VMNetwork -Confirm:$false
    Start-VM -VM $VMName
    #-RunAsync Do not add to New-Vm command if you want to use Start-VM -VM $myVM command
  }#>

  <#else {
    #$nicMapping = Get-OSCustomizationNicMapping -OSCustomizationSpec -Name $SourceCustomization | where {$_.Position -eq 1}
    Get-OSCustomizationSpec $SourceCustomization2012 | Get-OSCustomizationNicMapping | Set-OSCustomizationNicMapping -IpMode $RPS_IPMode -IpAddress $RPS_IPAddress -SubnetMask $Subnet -DefaultGateway $Gateway -Dns $RPS_DNS
    $SourceTemplate = Get-Template -Name $Srv2k12R2Template
     New-VM -Name $VMName -ResourcePool $TargetCluster -Location $RPS_Folder -Datastore $RPS_DataStore -Template $SourceTemplate -OSCustomizationSpec $SourceCustomization2012 -Description $RPS_Description -ErrorAction Stop
     Get-NetworkAdapter -VM $VMName | Set-NetworkAdapter -NetworkName $VMNetwork -Confirm:$false
     Start-VM -VM $VMName
     #-RunAsync Do not add to New-Vm command if you want to use Start-VM -VM $myVM command
  }#>
 } <#End Switch#>
}<#End Try#>

catch{
        Write-Error "Deployment Failed..."
    }
