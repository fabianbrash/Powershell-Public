#Filename:            GenerateEncryptedCreds.ps1
#Author:              Fabian Brash
#Date:                11-01-2016
#Modified:            11-01-2016
#Purpose:             Generate encrypted Credentials to a file



<#________   ________   ________      
|\   __  \ |\   __  \ |\   ____\     
\ \  \|\  \\ \  \|\  \\ \  \___|_    
 \ \   _  _\\ \   ____\\ \_____  \   
  \ \  \\  \|\ \  \___| \|____|\  \  
   \ \__\\ _\ \ \__\      ____\_\  \ 
    \|__|\|__| \|__|     |\_________\
                         \|_________|#>
                                     


<#
Exporting SecureString from Get-Credential
(Get-Credential).Password | ConvertFrom-SecureString | Out-File "C:\Temp 2\Password.txt"

Exporting SecureString from Read-Host
Read-Host "Enter Password" -AsSecureString |  ConvertFrom-SecureString | Out-File "C:\Temp 2\Password.txt"


Creating SecureString object
$pass = Get-Content "C:\Temp 2\Password.txt" | ConvertTo-SecureString

Creating PSCredential object
$User = "MyUserName"
$File = "C:\Temp 2\Password.txt"
$MyCredential=New-Object -TypeName System.Management.Automation.PSCredential `
 -ArgumentList $User, (Get-Content $File | ConvertTo-SecureString)

#>


<# Password MUST BE RE-KEYED IF YOU MOVE TO ANOTHER MACHINE YOU CANNOT COPY THE PASSWORD FILE BETWEEEN MACHINES
KEYS ARE INVOLVED HERE, ACTUALLY YOU ALSO HAVE TO RE-KEY PER USER, IF YOU HAVE A SCRIPT RUNNING AS A SCHEDULED TASK
OR FROM A CI PIPELINE AND IT RAN AS USER A IF YOU CHANGE TO USER B YOU MUST RE-KEY FOR THAT USER.

#>


Clear-Host
$MyPassword = "Password"

$MyPassword | ConvertTo-SecureString -AsPlainText -Force | ConvertFrom-SecureString | Out-File "C:\passfile.txt"

##Now let's Decrypt this Please note this will be decrypted in RAM so if an attacker has access to your systems
##memory space they can get the password

Clear-Host
$MyPassword = "password!!"

$MyPassword | ConvertTo-SecureString -AsPlainText -Force | ConvertFrom-SecureString | Out-File "C:\passfile2.txt"

$pass = Get-Content 'C:\passfile2.txt' | ConvertTo-SecureString
$creds = (New-Object PSCredential "user",$pass).GetNetworkCredential().Password

Write-Host "The password is" $creds
