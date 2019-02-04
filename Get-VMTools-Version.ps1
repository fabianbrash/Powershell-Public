#Filename:            Get-VMTools-Version.ps1
#Author:              Fabian Brash
#Date:                09-28-2016
#Modified:            10-03-2016
#Purpose:             Get Vm tools version



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


$VC = "lab-vcsa-01.lab.net"

Connect-VIServer -Server $VC
#$Cluster = "RTCN-Infrastructure"

Get-VM | Get-VMGuest | Select VMName, ToolsVersion | FT -AutoSize