Clear-Host

<# Let's speed up our downloads.. #>
$ProgressPreference = 'SilentlyContinue'

$profile=$env:USERPROFILE

New-Item -ItemType Directory -Path $profile\"Downloads\winget"

$folder='\Downloads\winget\'

$arg1 = 'winget install --id Microsoft.VisualStudioCode --version 1.83.1 --source winget'

$arg2 = 'winget install --id Amazon.AWSCLI --version 2.13.26 --source winget'

$arg3 = 'winget install --id Microsoft.AzureCLI --version 2.53.0 --source winget'

## Install chocolatey

Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))


## install tanzu cli

choco install tanzu-cli


## We need to download these packages

Invoke-WebRequest -URI https://github.com/microsoft/winget-cli/releases/download/v1.7.2782-preview/Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle -OutFile $profile$folder"Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle"



iwr -URI https://github.com/microsoft/winget-cli/releases/download/v1.7.2782-preview/f1c7c505b9934655be2195c074913cbf_License1.xml -OutFile $profile$folder"f1c7c505b9934655be2195c074913cbf_License1.xml"


iwr -URI https://www.nuget.org/api/v2/package/Microsoft.UI.Xaml/2.7.3 -OutFile $profile$folder"microsoft.ui.xaml.2.7.3.nupkg"

## We need to rename this so we can unzip it

Rename-Item -Path $profile$folder"microsoft.ui.xaml.2.7.3.nupkg" -NewName $profile$folder"microsoft.ui.xaml.2.7.3.zip"

Expand-Archive -Path $profile$folder"microsoft.ui.xaml.2.7.3.zip" -DestinationPath $profile$folder


iwr -URI https://aka.ms/Microsoft.VCLibs.x64.14.00.Desktop.appx -OutFile $profile$folder"Microsoft.VCLibs.x64.14.00.Desktop.appx"

## Try to install winget

Add-AppxPackage -Path $profile$folder"tools\AppX\x64\Release\Microsoft.UI.Xaml.2.7.appx"

Add-AppxPackage -Path $profile$folder"Microsoft.VCLibs.x64.14.00.Desktop.appx"


Add-AppxProvisionedPackage -Online -PackagePath $profile$folder"Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle" -LicensePath $profile$folder"f1c7c505b9934655be2195c074913cbf_License1.xml" -Verbose


## If winget is installed thse are some packages that would be nice to have

Start-Process pwsh.exe -ArgumentList $arg1

Start-Process pwsh.exe -ArgumentList $arg2

Start-Process pwsh.exe -ArgumentList $arg3

