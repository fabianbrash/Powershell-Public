#FileName:      DHCP_backup.ps1
#Author:        Fabian Brash
#Date:          05-07-2018
#Modified:      05-07-2018



<#________   ________   ________      
|\   __  \ |\   __  \ |\   ____\     
\ \  \|\  \\ \  \|\  \\ \  \___|_    
 \ \   _  _\\ \   ____\\ \_____  \   
  \ \  \\  \|\ \  \___| \|____|\  \  
   \ \__\\ _\ \ \__\      ____\_\  \ 
    \|__|\|__| \|__|     |\_________\
                         \|_________|#>
  
  
  Clear-Host



  ###Make a REST call

  try {

        $data = Invoke-RestMethod -Method Get -Uri 'http://api.fabianbrash.com/data.json' -ErrorAction Stop
      }

 catch{
        Write-Error -Message "Error fetching data.."
        Exit
      }

  #$data.data.dc.name[0]
  ##Our Servers

  $Today = Get-Date -DisplayHint Date
  $Today = ($Today).ToString().Substring(0,9)
  $Today = ($Today).Replace("/", "-")

  $DHCPServers = @()
  $DHCPServersTest = @("DC-01", "DC-02")
  
  <#----------------------------------------------------------------------------------------------------------
   Let's store our object data from our REST call into an Array, this is probably not needed
   but I like arrays
   ---------------------------------------------------------------------------------------------------------#>
  foreach($dataObject in $data) {
    $DHCPServers += $dataObject.data.dc.name

    }


<#-----------------------------------------------------------------------------------------------------------------------------------------
   @Note:  The below code will not work because of how Powershell handles output streams i.e. (> pipes) or using OutFile
           Powershell will attempt to open a file for all values in the array so if you have 50 entries, 50 files @ once
           So to fix this we need to use the ForEach-Object cmdlet and pipe in our array


-------------------------------------------------------------------------------------------------------------------------------------------#>

<#for($I=0; $I -lt $DHCPServersTest.Length; $I++) {

  
  Write-Host $DHCPServersTest[$I]

  netsh dhcp server \\$DHCPServersTest[$I] dump > C:\Output\$DHCPServersTest[$I]

  }#>

  <#-------------------------------------------------------------------------------------------------------------------------------
     Now let's use ForEach-Object which will fix our above issue
  ---------------------------------------------------------------------------------------------------------------------------------#>

  $DHCPServers | ForEach-Object {


      Write-Host $_

      netsh dhcp server \\$_ dump > C:\Output\$_-$Today.txt
      
  } 

  Write-Host ""
  Write-Host "#-------------------------------------------------------------"
  Write-Host "ALL DONE..." -ForegroundColor Green
  Write-Host "#-------------------------------------------------------------"
