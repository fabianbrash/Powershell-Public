Clear-Host

<# Let's speed up our downloads.. #>
$ProgressPreference = 'SilentlyContinue'

$profile=$env:USERPROFILE

New-Item -ItemType Directory -Path $profile\"Downloads\winget"

$folder='\Downloads\winget\'

$arg1 = 'winget install --id Microsoft.VisualStudioCode --source winget --accept-package-agreements --accept-source-agreements'

$arg2 = 'winget install --id Amazon.AWSCLI --source winget --accept-package-agreements --accept-source-agreements'

$arg3 = 'winget install --id Microsoft.AzureCLI --source winget --accept-package-agreements --accept-source-agreements'
$arg4 = 'choco install tanzu-cli --yes'
$arg5 = 'choco install firefox --yes'
$arg6 = 'winget install --id Google.Chrome.Beta --source winget --accept-package-agreements --accept-source-agreements'
$arg7 = 'winget install --id Microsoft.WindowsTerminal.Preview --source winget --accept-package-agreements --accept-source-agreements'
$arg8 = 'winget install --id Microsoft.PowerShell --source winget --accept-package-agreements --accept-source-agreements'
$arg9 = 'winget install --id Postman.Postman --source winget --accept-package-agreements --accept-source-agreements'
$arg10 = 'winget install --id 7zip.7zip --source winget --accept-package-agreements --accept-source-agreements'


function installchoco {

    ## Install chocolatey

    Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
}


function downloadpayloads {

    ## We need to download these packages

    Invoke-WebRequest -URI https://github.com/microsoft/winget-cli/releases/download/v1.7.2782-preview/Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle -OutFile $profile$folder"Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle"

    iwr -URI https://github.com/microsoft/winget-cli/releases/download/v1.7.2782-preview/f1c7c505b9934655be2195c074913cbf_License1.xml -OutFile $profile$folder"f1c7c505b9934655be2195c074913cbf_License1.xml"

    iwr -URI https://www.nuget.org/api/v2/package/Microsoft.UI.Xaml/2.7.3 -OutFile $profile$folder"microsoft.ui.xaml.2.7.3.nupkg"

    ## We need to rename this so we can unzip it

    Rename-Item -Path $profile$folder"microsoft.ui.xaml.2.7.3.nupkg" -NewName $profile$folder"microsoft.ui.xaml.2.7.3.zip"

    Expand-Archive -Path $profile$folder"microsoft.ui.xaml.2.7.3.zip" -DestinationPath $profile$folder

    iwr -URI https://aka.ms/Microsoft.VCLibs.x64.14.00.Desktop.appx -OutFile $profile$folder"Microsoft.VCLibs.x64.14.00.Desktop.appx"

}

<#function installpackages {

    ## install tanzu cli

    Start-Process powershell.exe -ArgumentList $arg4 -Verb RunAs -Wait

    ## install Firefox

    Start-Process powershell.exe -ArgumentList $arg5 -Verb RunAs -Wait

    ## Try to install winget

    Add-AppxPackage -Path $profile$folder"tools\AppX\x64\Release\Microsoft.UI.Xaml.2.7.appx"

    Add-AppxPackage -Path $profile$folder"Microsoft.VCLibs.x64.14.00.Desktop.appx"

    Add-AppxProvisionedPackage -Online -PackagePath $profile$folder"Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle" -LicensePath $profile$folder"f1c7c505b9934655be2195c074913cbf_License1.xml" -Verbose

    ## If winget is installed successfully these are some packages that would be nice to have

    Start-Process powershell.exe -ArgumentList $arg1 -Verb RunAs -Wait

    Start-Process powershell.exe -ArgumentList $arg2 -Verb RunAs -Wait

    Start-Process powershell.exe -ArgumentList $arg3 -Verb RunAs -Wait

    Start-Process powershell.exe -ArgumentList $arg6 -Verb RunAs -Wait

    Start-Process powershell.exe -ArgumentList $arg7 -Verb RunAs -Wait

    Start-Process powershell.exe -ArgumentList $arg8 -Verb RunAs -Wait

    Start-Process powershell.exe -ArgumentList $arg9 -Verb RunAs -Wait

    Start-Process powershell.exe -ArgumentList $arg10 -Verb RunAs -Wait

}#>

<# Function updated by ChatGPT #>

function installpackages {
    ## install tanzu cli
    $process1 = Start-Process powershell.exe -ArgumentList $arg4 -Verb RunAs -PassThru -Wait -ErrorAction Continue
    CheckErrorCode $process1.ExitCode "Error installing Tanzu CLI"

    ## install Firefox
    $process2 = Start-Process powershell.exe -ArgumentList $arg5 -Verb RunAs -PassThru -Wait -ErrorAction Continue
    CheckErrorCode $process2.ExitCode "Error installing Firefox"

    ## Try to install winget
    Add-AppxPackage -Path $profile$folder"tools\AppX\x64\Release\Microsoft.UI.Xaml.2.7.appx"
    Add-AppxPackage -Path $profile$folder"Microsoft.VCLibs.x64.14.00.Desktop.appx"
    Add-AppxProvisionedPackage -Online -PackagePath $profile$folder"Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle" -LicensePath $profile$folder"f1c7c505b9934655be2195c074913cbf_License1.xml" -Verbose

    ## If winget is installed successfully these are some packages that would be nice to have
    $process3 = Start-Process powershell.exe -ArgumentList $arg1 -Verb RunAs -PassThru -Wait -ErrorAction Continue
    CheckErrorCode $process3.ExitCode "Error installing Microsoft Visual Studio Code"

    $process4 = Start-Process powershell.exe -ArgumentList $arg2 -Verb RunAs -PassThru -Wait -ErrorAction Continue
    CheckErrorCode $process4.ExitCode "Error installing Amazon AWS CLI"

    $process5 = Start-Process powershell.exe -ArgumentList $arg3 -Verb RunAs -PassThru -Wait -ErrorAction Continue
    CheckErrorCode $process5.ExitCode "Error installing Microsoft Azure CLI"

    $process6 = Start-Process powershell.exe -ArgumentList $arg6 -Verb RunAs -PassThru -Wait -ErrorAction Continue
    CheckErrorCode $process6.ExitCode "Error installing Google Chrome Beta"

    $process7 = Start-Process powershell.exe -ArgumentList $arg7 -Verb RunAs -PassThru -Wait -ErrorAction Continue
    CheckErrorCode $process7.ExitCode "Error installing Microsoft Windows Terminal Preview"

    $process8 = Start-Process powershell.exe -ArgumentList $arg8 -Verb RunAs -PassThru -Wait -ErrorAction Continue
    CheckErrorCode $process8.ExitCode "Error installing Microsoft PowerShell"

    $process9 = Start-Process powershell.exe -ArgumentList $arg9 -Verb RunAs -PassThru -Wait -ErrorAction Continue
    CheckErrorCode $process9.ExitCode "Error installing Postman"

    $process10 = Start-Process powershell.exe -ArgumentList $arg10 -Verb RunAs -PassThru -Wait -ErrorAction Continue
    CheckErrorCode $process9.ExitCode "Error installing 7Zip"
    

}


function CheckErrorCode($exitCode, $errorMessage) {
    if ($exitCode -ne 0) {
        Write-Error $errorMessage
        exit $exitCode
    }
}

installchoco
downloadpayloads
installpackages




