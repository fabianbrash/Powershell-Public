Clear-Host

<# Let's speed up our downloads.. #>
$ProgressPreference = 'SilentlyContinue'


## Install chocolatey

Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))


## install tanzu cli

choco install tanzu-cli


## We need to download these packages

Invoke-WebRequest -URI https://github.com/microsoft/winget-cli/releases/download/v1.7.2782-preview/Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle -OutFile Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle



iwr -URI https://github.com/microsoft/winget-cli/releases/download/v1.7.2782-preview/f1c7c505b9934655be2195c074913cbf_License1.xml -OutFile f1c7c505b9934655be2195c074913cbf_License1.xml


iwr -URI https://www.nuget.org/api/v2/package/Microsoft.UI.Xaml/2.7.3 -OutFile microsoft.ui.xaml.2.7.3.nupkg


iwr -URI https://aka.ms/Microsoft.VCLibs.x64.14.00.Desktop.appx -OutFile Microsoft.VCLibs.x64.14.00.Desktop.appx

## Try to install winget

Add-AppxPackage -Path C:\Users\Administrator\Downloads\microsoft.ui.xaml.2.7.3\tools\AppX\x64\Release\Microsoft.UI.Xaml.2.7.appx

Add-AppxPackage -Path .\Microsoft.VCLibs.x64.14.00.Desktop.appx


Add-AppxProvisionedPackage -Online -PackagePath .\Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle -LicensePath .\f1c7c505b9934655be2195c074913cbf_License1.xml -Verbose


## If winget is installed thse are some packages that would be nice to have

winget install --id Microsoft.VisualStudioCode --version 1.83.1 --source winget

winget install --id Amazon.AWSCLI --version 2.13.26 --source winget

winget install --id Microsoft.AzureCLI --version 2.53.0 --source winget

