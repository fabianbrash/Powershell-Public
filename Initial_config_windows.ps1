#Filename:            Initial_config_windows.ps1
#Author:              Fabian Brash
#Date:                04-20-2018
#Modified:            04-20-2018
#Purpose:             Initial config of windows to prep for content library or template creation



<#________   ________   ________
|\   __  \ |\   __  \ |\   ____\
\ \  \|\  \\ \  \|\  \\ \  \___|_
 \ \   _  _\\ \   ____\\ \_____  \
  \ \  \\  \|\ \  \___| \|____|\  \
   \ \__\\ _\ \ \__\      ____\_\  \
    \|__|\|__| \|__|     |\_________\
                         \|_________|#>


Clear-Host


#--------------------------------------------------------------
# Let's install .NET 3.5
#--------------------------------------------------------------

try{
  Install-WindowsFeature NET-Framework-Features -ErrorAction Stop
  Write-Host ".NET 3.5 successfully installed" -ForegroundColor Green
}
catch {
  Write-Error "Failure occurred during installation of .Net 3.5"
}



#--------------------------------------------------------------
# Set san policy to onlineAll
#--------------------------------------------------------------

try {
  Set-StorageSetting -NewDiskPolicy OnlineAll -ErrorAction Stop
  Write-Host "SAN policy has been successfully set to OnlineAll" -ForegroundColor Green
}
catch {
  Write-Error "There was an error setting the SAN policy"
}



#--------------------------------------------------------------
# Enable RDP set -Value to 1 to disable RDP
#--------------------------------------------------------------

try {
  Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server'-name "fDenyTSConnections" -Value 0 -ErrorAction Stop
  Write-Host "RDP has been successfully enabled" -ForegroundColor Green
}
catch {
  Write-Error "There was an error enabling RDP on the target system"
}


#--------------------------------------------------------------
# Set Power plan to High Performance
#--------------------------------------------------------------

Try {
    $HighPerf = powercfg -l | %{if($_.contains("High performance")) {$_.split()[3]}}
    $CurrPlan = $(powercfg -getactivescheme).split()[3]
    if ($CurrPlan -ne $HighPerf) {powercfg -setactive $HighPerf}
    Write-Host "Successfully set power plan to high performance" -ForegroundColor Green
} Catch {
    Write-Warning -Message "Unable to set power plan to high performance"
}


#--------------------------------------------------------------
# Just in case this was changed
#--------------------------------------------------------------

try {
  Set-ExecutionPolicy RemoteSigned
  Write-Host "Successfully changed execution policy to RemoteSigned" -ForegroundColor Green
}
catch {
  Write-Error -Message "Could not set execution policy to RemoteSigned"
}
