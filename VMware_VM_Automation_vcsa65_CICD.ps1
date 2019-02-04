#Filename:            VMware_VM_Automation_vcsa65_CICD.ps1
#Author:              Fabian Brash
#Date:                09-28-2016
#Modified:            05-22-2018
#Purpose:             Deploy and Customize a VM **Must be run in x86 version of Powershell or PowerCLI(Not longer accurate as of version 5.5.x this can be run in x64)


Clear-Host


try
    {
        Import-Module -Name VMware.VimAutomation.Core -ErrorAction Stop
    }
catch
    {
        Write-Error -Message "VmWare core automation module could not be loaded..."
    }

    try
        {
            Import-Module -Name VMware.VimAutomation.Vds -ErrorAction Stop
        }
    catch
        {
            Write-Error -Message "VMware core networking automation module could not be loaded..."
        }


$RPS_DataStore = "datastore1"
$VMNetwork = "VM Network"
$vDSPG = "DvPG"
$vDSName = "DSwitch"
$VMName = "Srv16-CI-Test"
$RPS_Folder = 'Staging'
$SourceCustomization = "CI-Pipeline-Spec"
$SourceCustomization2012 = "Server2012R2-Customization_PowerCLI"
$SourceCustomizationLinux = "Linux-Spec"
$Subnet = '255.255.255.0'
$RPS_IPMode = 'UseStaticIp'
$RPS_IPAddress = 'IP'
$Gateway = 'GW'
$RPS_DNS = 'DNS1'
$RPS_DNS2 = 'DNS2'
$vCenter = "lab-vcsa-01.test.local"
$RPS_Description = "Test CI build from Jenkins"
[int]$OSClass = 3


$VCSAUser = "administrator@vsphere.local"
$encrypted = Get-Content D:\passfile_lab.txt | ConvertTo-SecureString

<#-----------Let's decrypt our password-----------------------------#>
$PipeLine_password = (New-Object PSCredential "user",$encrypted).GetNetworkCredential().Password


Connect-ViServer -Server $vCenter -User $VCSAUser -Password $PipeLine_password

###Variables from inside vCenter

###Our Templates
$Srv2k12R2Template = "18-04-Srv2012R2-8K-T"
$Srv2k16Template = "18-05-Srv16-T"
$CentOS = "18-05-CentOS7-T"

##Our Target Host
$EsxiHost = Get-VMHost -Name "DNS_OR_IP"

##Our vDS
$ProdvDSPG = Get-VDSwitch -Name $vDSName | Get-VDPortgroup -Name $vDSPG


<#---Let's get all VM's so we can check for name collisions--------------#>

$VMObjects = Get-VM


function CheckVMObjects($TheVM) {

  if($VMObjects.Name -eq $TheVM) {

    Throw "VM already exists"
    Exit
  }
}


Write-Verbose -Message "Beginning deployment of VM..." -Verbose


<#----@Function:  Deploy a server 2016 VM-------------------------#>

function DeploySrv2016
{
  $RPSIPArraySrv16 = @('192.168.1.100')
  $RPSVMNameArraySrv16 = @('Srv16-CI-Test')
  $RPSDescriptionArraySrv16 = @('Test CI build from Jenkins')

for($i = 0; $i -lt $RPSVMNameArraySrv16.length; $i++) {

      <#----Let's first check for a name collision------#>
  CheckVMObjects $RPSVMNameArraySrv16SQL[$i]

  <#----If everything is good start deploying-------#>
      try {
        Get-OSCustomizationSpec $SourceCustomization | Get-OSCustomizationNicMapping | Set-OSCustomizationNicMapping -IpMode $RPS_IPMode -IpAddress $RPSIPArraySrv16[$i] -SubnetMask $Subnet -DefaultGateway $Gateway -Dns $RPS_DNS
        $SourceTemplate = Get-Template -Name $Srv2k16Template
        New-VM -Name $RPSVMNameArraySrv16[$i] -ResourcePool $EsxiHost -Location $RPS_Folder -Datastore $RPS_DataStore -Template $SourceTemplate -OSCustomizationSpec $SourceCustomization -Description $RPSDescriptionArraySrv16[$i] -ErrorAction Stop
        Get-NetworkAdapter -VM $RPSVMNameArraySrv16[$i] | Set-NetworkAdapter -Portgroup $LabvDSPG -Confirm:$false
        Start-VM -VM $RPSVMNameArraySrv16[$i]
        #-RunAsync Do not add to New-Vm command if you want to use Start-VM -VM $myVM command
      }

      catch {

        Write-Error "Deployment of Server 2016 Failed..."
       }

   }

}



<#----@Function:  Deploy a Server 2012 R2 VM-------------------------#>


function DeploySrv2012R2
{
  $RPSIPArraySrv12 = @('192.168.1.100')
  $RPSVMNameArraySrv12 = @('Srv16-CI-Test')
  $RPSDescriptionArraySrv12 = @('Test CI build from Jenkins')

  for($i = 0; $i -lt RPSVMNameArraySrv12.length; $i++) {
      
      <#----Let's first check for a name collision------#>
    CheckVMObjects $RPSVMNameArraySrv12[$i]

    <#----If everything is good start deploying-------#>
      try {
        Get-OSCustomizationSpec $SourceCustomization2012 | Get-OSCustomizationNicMapping | Set-OSCustomizationNicMapping -IpMode $RPS_IPMode -IpAddress $RPSIPArraySrv12[$i] -SubnetMask $Subnet -DefaultGateway $Gateway -Dns $RPS_DNS
        $SourceTemplate = Get-Template -Name $Srv2k12R2Template
        New-VM -Name $RPSVMNameArraySrv12[$i] -ResourcePool $TargetCluster -Location $RPS_Folder -Datastore $RPS_DataStore -Template $SourceTemplate -OSCustomizationSpec $SourceCustomization2012 -Description $RPSDescriptionArraySrv12[$i] -ErrorAction Stop
        Get-NetworkAdapter -VM $RPSVMNameArraySrv12[$i] | Set-NetworkAdapter -Portgroup $LabvDSPG -Confirm:$false
        Start-VM -VM $RPSVMNameArraySrv12[$i]
        #-RunAsync Do not add to New-Vm command if you want to use Start-VM -VM $myVM command
       }

      catch {

        Write-Error "Deployment of Server 2012 R2 Failed..."
       }

    }

}


function DeployLinux {

$IPArray = @('IP1', 'IP2', 'IP3')
$VMNameArray = @("cent-automated-01", "cent-automated-02", "cent-automated-03")
$RPS_DescriptionArray = @("Build from Jenkins", "Build from Jenkins 2", "Build from Jenkins 3")

for($I = 0; $I -lt $VMNameArray.length; $I++) {

    <#----Let's first check for a name collision------#>
  CheckVMObjects $VMNameArray[$I]

  <#----If everything is good start deploying-------#>
    try {
    Get-OSCustomizationSpec $SourceCustomizationLinux | Get-OSCustomizationNicMapping | Set-OSCustomizationNicMapping -IpMode $RPS_IPMode -IpAddress $IPArray[$I] -SubnetMask $Subnet -DefaultGateway $Gateway
    $SourceTemplate = Get-Template -Name $CentOS
    New-VM -Name $VMNameArray[$I] -ResourcePool $EsxiHost -Location $RPS_Folder -Datastore $RPS_DataStore -Template $SourceTemplate -OSCustomizationSpec $SourceCustomizationLinux -Description $RPS_DescriptionArray[$I] -ErrorAction Stop
    Get-NetworkAdapter -VM $VMNameArray[$I] | Set-NetworkAdapter -NetworkName $VMNetwork -Confirm:$false
    Start-VM -VM $VMNameArray[$I]
    #-RunAsync Do not add to New-Vm command if you want to use Start-VM -VM $myVM command
    }

catch {

  Write-Error "Deployment of Linux Failed..."
  }

 }

}

function Deploy3Tier {

  <#---------Let's import a CSV file that holds our data-----------------------#>
  $CsvData = Import-Csv -Path 'D:\Data\PSData-Prod.csv'
  [int]$Is3Tier = 1

  <#---------SQL----------------------------------------------------------------#>
  $RPSIPArraySrv16SQL = @($CsvData.SQLIP.Split(',').Trim())
  $RPSVMNameArraySrv16SQL = @($CsvData.SQLName.Split(',').Trim())
  $RPSDescriptionArraySrv16SQL = @($CsvData.SQLDescription.Split(',').Trim())

  <#--------APP-----------------------------------------------------------------#>
  $RPSIPArraySrv16APP = @($CsvData.APPIP.Split(',').Trim())
  $RPSVMNameArraySrv16APP = @($CsvData.APPName.Split(',').Trim())
  $RPSDescriptionArraySrv16APP = @($CsvData.APPDescription.Split(',').Trim())

  <#------WEB-------------------------------------------------------------------#>
  $RPSIPArraySrv16WEB = @($CsvData.WEBIP.Split(',').Trim())
  $RPSVMNameArraySrv16WEB = @($CsvData.WEBName.Split(',').Trim())
  $RPSDescriptionArraySrv16WEB = @($CsvData.WEBDescription.Split(',').Trim())

  <#-------Let's do some kind of sanity check here----------------#>

  if($RPSVMNameArraySrv16SQL.Length -lt 1) {
    Throw 'Error the size of the array is zero...'
    Exit
  }

<#---Begin a 3Tier deployment-----------------------------------------------#>

  if($Is3Tier -eq 1) {


<#----Deploy SQL--------------------------------------------------------------#>

  for($i = 0; $i -lt $RPSVMNameArraySrv16SQL.length; $i++) {
  
        <#----Let's first check for a name collision------#>
      CheckVMObjects $RPSVMNameArraySrv16SQL[$i]

      <#----If everything is good start deploying-------#>
        try {
          Get-OSCustomizationSpec $SourceCustomization | Get-OSCustomizationNicMapping | Set-OSCustomizationNicMapping -IpMode $RPS_IPMode -IpAddress $RPSIPArraySrv16SQL[$i] -SubnetMask $Subnet -DefaultGateway $Gateway -Dns $RPS_DNS
          $SourceTemplate = Get-Template -Name $Srv2k16SQLTemplate
          New-VM -Name $RPSVMNameArraySrv16SQL[$i] -ResourcePool $EsxiHost -Location $RPS_Folder -Datastore $RPS_DataStore -Template $SourceTemplate -OSCustomizationSpec $SourceCustomization -Description $RPSDescriptionArraySrv16SQL[$i] -ErrorAction Stop
          Get-NetworkAdapter -VM $RPSVMNameArraySrv16SQL[$i] | Set-NetworkAdapter -Portgroup $ProdvDSPG -Confirm:$false
          Start-VM -VM $RPSVMNameArraySrv16SQL[$i]
          Write-Host "Successfully deployed "$RPSVMNameArraySrv16SQL.Count"SQL Servers"
          #-RunAsync Do not add to New-Vm command if you want to use Start-VM -VM $myVM command
        }

        catch {

          Write-Error "Deployment of SQL Server Failed..."
         }

     }


     <#----Deploy APP----------------------------------------------------------#>
       for($k = 0; $k -lt $RPSVMNameArraySrv16APP.length; $k++) {
       
             <#----Let's first check for a name collision------#>
         CheckVMObjects $RPSVMNameArraySrv16APP[$k]

         <#----If everything is good start deploying-------#>
             try {
               Get-OSCustomizationSpec $SourceCustomization | Get-OSCustomizationNicMapping | Set-OSCustomizationNicMapping -IpMode $RPS_IPMode -IpAddress $RPSIPArraySrv16APP[$k] -SubnetMask $Subnet -DefaultGateway $Gateway -Dns $RPS_DNS
               $SourceTemplate = Get-Template -Name $Srv2k16Template
               New-VM -Name $RPSVMNameArraySrv16APP[$k] -ResourcePool $EsxiHost -Location $RPS_Folder -Datastore $RPS_DataStore -Template $SourceTemplate -OSCustomizationSpec $SourceCustomization -Description $RPSDescriptionArraySrv16APP[$k] -ErrorAction Stop
               Get-NetworkAdapter -VM $RPSVMNameArraySrv16APP[$k] | Set-NetworkAdapter -Portgroup $ProdvDSPG -Confirm:$false
               Start-VM -VM $RPSVMNameArraySrv16APP[$k]
               Write-Host "Successfully deployed "$RPSVMNameArraySrv16APP.Count"APP Servers"
               #-RunAsync Do not add to New-Vm command if you want to use Start-VM -VM $myVM command
             }

             catch {

               Write-Error "Deployment of App Server Failed..."
              }

          }

          <#----Deploy WEB--------------------------------------------------------------#>
            for($j = 0; $j -lt $RPSVMNameArraySrv16WEB.length; $j++) {
            
                  <#----Let's first check for a name collision------#>
              CheckVMObjects $RPSVMNameArraySrv16WEB[$j]

              <#----If everything is good start deploying-------#>
                  try {
                    Get-OSCustomizationSpec $SourceCustomization | Get-OSCustomizationNicMapping | Set-OSCustomizationNicMapping -IpMode $RPS_IPMode -IpAddress $RPSIPArraySrv16WEB[$j] -SubnetMask $Subnet -DefaultGateway $Gateway -Dns $RPS_DNS
                    $SourceTemplate = Get-Template -Name $Srv2k16Template
                    New-VM -Name $RPSVMNameArraySrv16WEB[$j] -ResourcePool $EsxiHost -Location $RPS_Folder -Datastore $RPS_DataStore -Template $SourceTemplate -OSCustomizationSpec $SourceCustomization -Description $RPSDescriptionArraySrv16WEB[$j] -ErrorAction Stop
                    Get-NetworkAdapter -VM $RPSVMNameArraySrv16WEB[$j] | Set-NetworkAdapter -Portgroup $ProdvDSPG -Confirm:$false
                    Start-VM -VM $RPSVMNameArraySrv16WEB[$j]
                    Write-Host "Successfully deployed "$RPSVMNameArraySrv16WEB.Count"Web Servers"
                    #-RunAsync Do not add to New-Vm command if you want to use Start-VM -VM $myVM command
                  }

                  catch {

                    Write-Error "Deployment of Web Server Failed..."
                   }

               }

    }

    <#-----Begin 2Tier deployment SQL, WEB/APP only----------------------------------#>
    elseif($Is3Tier -eq 0) {

      for($i = 0; $i -lt $RPSVMNameArraySrv16SQL.length; $i++) {
      
            <#----Let's first check for a name collision------#>
        CheckVMObjects $RPSVMNameArraySrv16SQL[$i]

        <#----If everything is good start deploying-------#>
            try {
              Get-OSCustomizationSpec $SourceCustomization | Get-OSCustomizationNicMapping | Set-OSCustomizationNicMapping -IpMode $RPS_IPMode -IpAddress $RPSIPArraySrv16SQL[$i] -SubnetMask $Subnet -DefaultGateway $Gateway -Dns $RPS_DNS
              $SourceTemplate = Get-Template -Name $Srv2k16SQLTemplate
              New-VM -Name $RPSVMNameArraySrv16SQL[$i] -ResourcePool $EsxiHost -Location $RPS_Folder -Datastore $RPS_DataStore -Template $SourceTemplate -OSCustomizationSpec $SourceCustomization -Description $RPSDescriptionArraySrv16SQL[$i] -ErrorAction Stop
              Get-NetworkAdapter -VM $RPSVMNameArraySrv16SQL[$i] | Set-NetworkAdapter -Portgroup $ProdvDSPG -Confirm:$false
              Start-VM -VM $RPSVMNameArraySrv16SQL[$i]
              Write-Host "Successfully deployed "$RPSVMNameArraySrv16SQL.Count"SQL Servers"
              #-RunAsync Do not add to New-Vm command if you want to use Start-VM -VM $myVM command
            }

            catch {

              Write-Error "Deployment of SQL Server Failed..."
             }

         }


         <#----Deploy APP----------------------------------------------------------#>
           for($k = 0; $k -lt $RPSVMNameArraySrv16APP.length; $k++) {
           
                 <#----Let's first check for a name collision------#>
           CheckVMObjects $RPSVMNameArraySrv16APP[$k]

           <#----If everything is good start deploying-------#>
                 try {
                   Get-OSCustomizationSpec $SourceCustomization | Get-OSCustomizationNicMapping | Set-OSCustomizationNicMapping -IpMode $RPS_IPMode -IpAddress $RPSIPArraySrv16APP[$k] -SubnetMask $Subnet -DefaultGateway $Gateway -Dns $RPS_DNS
                   $SourceTemplate = Get-Template -Name $Srv2k16Template
                   New-VM -Name $RPSVMNameArraySrv16APP[$k] -ResourcePool $EsxiHost -Location $RPS_Folder -Datastore $RPS_DataStore -Template $SourceTemplate -OSCustomizationSpec $SourceCustomization -Description $RPSDescriptionArraySrv16APP[$k] -ErrorAction Stop
                   Get-NetworkAdapter -VM $RPSVMNameArraySrv16APP[$k] | Set-NetworkAdapter -Portgroup $ProdvDSPG -Confirm:$false
                   Start-VM -VM $RPSVMNameArraySrv16APP[$k]
                   Write-Host "Successfully deployed "$RPSVMNameArraySrv16APP.Count"APP Servers"
                   #-RunAsync Do not add to New-Vm command if you want to use Start-VM -VM $myVM command
                 }

                 catch {

                   Write-Error "Deployment of App Server Failed..."
                  }

              }

     }

  <#--------ADD CODE HERE---------------------------------------#>
}


    switch($OSClass) {
      #$nicMapping = Get-OSCustomizationNicMapping -OSCustomizationSpec -Name $SourceCustomization | where {$_.Position -eq 1}
      1 { DeploySrv2016 }

      2 { DeploySrv2012R2 }

      3 { DeployLinux }

      4 { Deploy3Tier }

    default {
          Write-Error -Message "You did not make a correct selection..."
          Exit
    }


}





<#------------------------------------------------Legacy code to be removed------------------------------------------------------------------------------------#>

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



 #Get-OSCustomizationSpec -Name "Server2012-Customization_Automation"
 #Get-OSCustomizationSpec -Name "Server2012-Customization_Automation" | Get-OSCustomizationNicMapping

<#-----------------------------------------------End legacy block------------------------------------------------------------------------------------------------------------#>
