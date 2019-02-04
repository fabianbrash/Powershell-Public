
#Filename:            openSSL.ps1
#Author:              Fabian Brash
#Date:                05-26-2016
#Modified:            04-27-2017
#Purpose:             Create a self-signed certificate that can be imported into IIS and now with SAN attribute
#NOTE:                DO NOT RUN FROM A NETWORK SHARE AND DO NOT RUN WITH ISE USE POWERSHELL CLI



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
$CleanPrivateKey=""
$CleanPublicKey=""
$CleanIISKey=""
$DotKey = ".key"
$DotCrt = ".crt"
$DotPfx = ".pfx"
$Arg1 = "req"
$Arg2 = "-x509"
$Arg3 = "-nodes"
$Arg4 = "-" 
$Arg5 = "-days"
$Arg6 = "-newkey"
$Arg7 = "rsa:"
$Arg8 = "-keyout"
$Arg9 = "-out"
$Arg10 = "pkcs12"
$Arg11 = "-inkey"
$Arg12 = "-in"
$Arg13 = "-export"
$FriendlyName=""
$Arg14 = "-name"
$config = "-config"
$configFile = 'C:\path to your file\san.cnf'
[int]$RPS_MAX_DAYS = 1186

#Check to see if OpenSSL is installed

if(-not (Test-Path $InstallPath) )
{
    Write-Warning -Message  "OpenSSL is not installed--Please install and rerun..Exiting..."
    Exit
}

#Get our Variables

$Certpath = Read-Host "Please enter where you would like the certs to be saved(e.g. C:\Certs\)"
<# Check to see if the path exists #>
    if( -not (Test-Path $Certpath) )
        {
            Write-Host "Path does not exist creating path now..."
            New-Item -Path $Certpath -type directory
        }

$SHA = Read-Host "Please enter the hash strength (e.g. SHA256,SHA384,SHA512)"
[int]$NumDays = Read-Host "Please enter the length of time for your Certificate(max should be 1186 days)"
    If($NumDays -gt $RPS_MAX_DAYS)
        {
            Write-Host "You can only create a certificate with a max life of 1186 days" -ForegroundColor Red
            Exit
        }

$RSA = Read-Host "Please enter the RSA length (2048,4096,if uncertain use 2048)"

$PrivateKeyPath = Read-Host "Please enter the name of the private key"
<# Lets do some logic and cleanup here #>
    if( -not($PrivateKeyPath).Contains(".") )
        {
            $CleanPrivateKey = -join($PrivateKeyPath,$DotKey)
            Write-Host $CleanPrivateKey
        }
     else {$CleanPrivateKey = $PrivateKeyPath} 
$PublicKeyPath = Read-Host "Please enter the name of the public key"
    if ( -not($PublicKeyPath).Contains(".") )
        {
            $CleanPublicKey = -join($PublicKeyPath,$DotCrt)
            Write-Host $CleanPublicKey
        }
    else {$CleanPublicKey = $PublicKeyPath}

$IISCertPath = Read-Host "Please enter the name of the key to import into IIS"
    if( -not($IISCertPath).Contains(".") )
        {
            $CleanIISKey = -join($IISCertPath,$DotPfx)
            Write-Host $CleanIISKey
        }
    else {$CleanIISKey = $IISCertPath}

$FriendlyName = Read-Host "Please enter a friendly name for your certificate"



& $InstallPath $Arg1 $Arg2 $Arg3 $Arg4$SHA $Arg5 $NumDays $Arg6 $Arg7$RSA $Arg8 $Certpath$CleanPrivateKey $Arg9 $Certpath$CleanPublicKey $config $configFile

& $InstallPath $Arg10 $Arg11 $Certpath$CleanPrivateKey $Arg12 $Certpath$CleanPublicKey $Arg13 $Arg9 $Certpath$CleanIISKey $Arg14 $FriendlyName
