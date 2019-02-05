
##FileName: dc_time_sync.ps1
##Author:  Fabian Brash
##Purpose: peer DC with a stratum 1 time source


<#________   ________   ________      
|\   __  \ |\   __  \ |\   ____\     
\ \  \|\  \\ \  \|\  \\ \  \___|_    
 \ \   _  _\\ \   ____\\ \_____  \   
  \ \  \\  \|\ \  \___| \|____|\  \  
   \ \__\\ _\ \ \__\      ____\_\  \ 
    \|__|\|__| \|__|     |\_________\
                         \|_________|#>
                         
                         
Clear-Host                        
$tmService = "w32time"
w32tm.exe /config /manualpeerlist:"0.us.pool.ntp.org 1.us.pool.ntp.org" /syncfromflags:manual /reliable:YES /update
Start-Sleep -s 10
w32tm.exe /config /update
Start-Sleep -s 3
Restart-Service $tmService




