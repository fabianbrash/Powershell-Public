#Filename:            Get_VM_Snapshots.ps1
#Author:              Fabian Brash
#Date:                02-21-2018
#Modified:            02-21-2018
#Purpose:             Get all VM's with snapshots



<#________   ________   ________
|\   __  \ |\   __  \ |\   ____\
\ \  \|\  \\ \  \|\  \\ \  \___|_
 \ \   _  _\\ \   ____\\ \_____  \
  \ \  \\  \|\ \  \___| \|____|\  \
   \ \__\\ _\ \ \__\      ____\_\  \
    \|__|\|__| \|__|     |\_________\
                         \|_________|#>

Clear-Host

try {
  Import-Module -Name VMware.VimAutomation.Core -ErrorAction Stop
}
catch {
  Write-Error -Message "There was an error loading module VMware.VimAutomation.Core"
}


<# Let's get and decrypt our password #>

$pass = Get-Content 'C:\passfile.txt' | ConvertTo-SecureString
$creds = (New-Object PSCredential "user",$pass).GetNetworkCredential().Password

$Automation_user = 'user@vsphere.local'

$VC = 'vc'
#$VCOLD = 'vc'
$SMTPServer = 'smtpserver'
$Today = Get-Date -DisplayHint Date
$Today = ($Today).ToString().Substring(0,9)
$Today = ($Today).Replace("/", "-")


Connect-ViServer -Server $VC -User $Automation_user -Password $creds

<#Get-VM | Get-Snapshot | Format-List vm,name,SizeMB,SizeGB | Export-Csv C:\VMSnaps.csv#>

Get-VM | Get-Snapshot | Select vm,name,SizeMB,SizeGB | Export-Csv C:\VMSnaps65$Today.csv
<#Get-VM | Get-Snapshot | Format-List vm,name,SizeMB,SizeGB#>

Start-Sleep -Seconds 2

Send-MailMessage -To "serveradmin <serveradmin@blah.com>" -From "powershell <powershell@blah.com>" -Subject "VM's Running on Snapshots" -Body "Here is a list of all VM's running on a snapshot" -SmtpServer $SMTPServer -Attachments C:\VMSnaps65$Today.csv
