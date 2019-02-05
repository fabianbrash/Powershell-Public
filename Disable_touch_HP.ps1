#Filename:            Disable_touch_HP.ps1
#Author:              Fabian Brash
#Date:                05-11-2018
#Modified:            05-11-2018
#Purpose:             Disable touch on HP Probook x360 11 G2 EE



<#________   ________   ________
|\   __  \ |\   __  \ |\   ____\
\ \  \|\  \\ \  \|\  \\ \  \___|_
 \ \   _  _\\ \   ____\\ \_____  \
  \ \  \\  \|\ \  \___| \|____|\  \
   \ \__\\ _\ \ \__\      ____\_\  \
    \|__|\|__| \|__|     |\_________\
                         \|_________|#>


Clear-Host


function disableTouch {

$TouchInstanceId = Get-PnpDevice -FriendlyName 'HID-compliant touch screen' | Select -ExpandProperty InstanceId

Disable-PnPDevice -InstanceId $TouchInstanceId -Confirm:$false

}


disableTouch
