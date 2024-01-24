<#
  This has been tested on server 2022 but server 2019 should work as well 
#>

Clear-Host

$arg5 = 'choco install firefox --yes'
$arg1 = 'choco install pwsh --yes'
$arg2 = 'choco install oraclejdk --yes'
$arg3 = 'choco install maven --yes'
$arg4 = 'choco install dotnet-sdk --yes'
$arg6 = 'choco install nodejs-lts --yes'
$arg7 = 'choco install golang --yes'
$arg8 = 'choco install python --yes'
$arg9 = 'choco install git --yes'

function CheckErrorCode($exitCode, $errorMessage) {
    if ($exitCode -ne 0) {
        Write-Error $errorMessage
        exit $exitCode
    }
}

function installchoco {

    ## Install chocolatey

    Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
}

function installpackages {

    ## install Firefox
    $process2 = Start-Process powershell.exe -ArgumentList $arg5 -Verb RunAs -PassThru -Wait -ErrorAction Continue
    CheckErrorCode $process2.ExitCode "Error installing Firefox"
    
    ## install PWSH
    $process1 = Start-Process powershell.exe -ArgumentList $arg1 -Verb RunAs -PassThru -Wait -ErrorAction Continue
    CheckErrorCode $process1.ExitCode "Error installing PWSH"

    ## install PWSH
    $process3 = Start-Process powershell.exe -ArgumentList $arg2 -Verb RunAs -PassThru -Wait -ErrorAction Continue
    CheckErrorCode $process3.ExitCode "Error installing JDK"

     ## install Maven
     $process4 = Start-Process powershell.exe -ArgumentList $arg3 -Verb RunAs -PassThru -Wait -ErrorAction Continue
     CheckErrorCode $process4.ExitCode "Error installing Maven"

    ## install dotnetsdk
    $process5 = Start-Process powershell.exe -ArgumentList $arg4 -Verb RunAs -PassThru -Wait -ErrorAction Continue
    CheckErrorCode $process5.ExitCode "Error installing dotnetsdk"

    ## install nodejs LTS
    $process6 = Start-Process powershell.exe -ArgumentList $arg6 -Verb RunAs -PassThru -Wait -ErrorAction Continue
    CheckErrorCode $process6.ExitCode "Error installing nodejs LTS"

    ## install golang
    $process7 = Start-Process powershell.exe -ArgumentList $arg7 -Verb RunAs -PassThru -Wait -ErrorAction Continue
    CheckErrorCode $process7.ExitCode "Error installing golang"

    ## install Python 3.x
    $process8 = Start-Process powershell.exe -ArgumentList $arg8 -Verb RunAs -PassThru -Wait -ErrorAction Continue
    CheckErrorCode $process8.ExitCode "Error installing Python3 3.x"

    ## install Git
    $process9 = Start-Process powershell.exe -ArgumentList $arg9 -Verb RunAs -PassThru -Wait -ErrorAction Continue
    CheckErrorCode $process9.ExitCode "Error installing Python3 3.x"
}

$policy = Get-ExecutionPolicy

if (($policy -eq 'Unrestricted' -or $policy -eq 'RemoteSigned' -or $policy -eq 'Bypass')) {
    <# Action to perform if the condition is true #>
    installchoco
    installpackages
}

else {
    Write-Error -Message "Change your Execution Policy and try again...."
}
