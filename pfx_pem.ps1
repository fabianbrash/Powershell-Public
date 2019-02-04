#Filename:            pfx_pem.ps1
#Author:              Fabian Brash
#Date:                10-05-2016
#Modified:            10-05-2016
#Purpose:             Convert .pfx to .pem



<#________   ________   ________      
|\   __  \ |\   __  \ |\   ____\     
\ \  \|\  \\ \  \|\  \\ \  \___|_    
 \ \   _  _\\ \   ____\\ \_____  \   
  \ \  \\  \|\ \  \___| \|____|\  \  
   \ \__\\ _\ \ \__\      ____\_\  \ 
    \|__|\|__| \|__|     |\_________\
                         \|_________|#>
                                     

Clear-Host


#Install path of openSSL
$InstallPath = "C:\OpenSSL-Win32\bin\openssl.exe"
$PK_format = "pkcs12"
$in = "-in"
$noCerts = "-nocerts"
$noKeys = "-nokeys"
$out = "-out"
$nodes = "-nodes"
$extension = ".pem"
$publicCert = "publiccert"
$privateKey = "privatekey"




#Check to see if OpenSSL is installed

if(-not (Test-Path $InstallPath) )
{
    Write-Warning -Message  "OpenSSL is not installed--Please install and rerun..Exiting..."
    Exit
}

$certPath = Read-Host "Where would you like the save your certs(e.g.c:\certs\)"

if(-not ($certPath) ) {
    
    Write-Host "Path does not exist creating path now..."
    New-Item -Path $certPath -type directory
    }

$RPS_pfx = Read-Host "Please enter .pfx file to convert(Full path is required)"

#& $InstallPath $PK_format $in $RPS_pfx $noCerts $out $certPath$privateKey$extension $nodes
& $InstallPath $PK_format $in $RPS_pfx $out $certPath$publicCert$extension $nodes
