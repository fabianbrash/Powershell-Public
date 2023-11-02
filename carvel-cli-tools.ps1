Clear-Host

<# Let's speed up our downloads.. #>
$ProgressPreference = 'SilentlyContinue'

$profile=$env:USERPROFILE
$folder = "C:\Program Files\tanzu-cli\"

#New-Item -ItemType Directory -Path $profile$folder
New-Item -ItemType Directory 'C:\Program Files\tanzu-cli'

$ytturi = "https://github.com/carvel-dev/ytt/releases/download/v0.45.6/ytt-windows-amd64.exe"
$imgpkguri = "https://github.com/carvel-dev/imgpkg/releases/download/v0.39.0/imgpkg-windows-amd64.exe"
$kblduri = "https://github.com/carvel-dev/kbld/releases/download/v0.38.1/kbld-windows-amd64.exe"
$kappuri = "https://github.com/carvel-dev/kapp/releases/download/v0.59.1/kapp-windows-amd64.exe"
$vendiruri = "https://github.com/carvel-dev/vendir/releases/download/v0.35.2/vendir-windows-amd64.exe"
$kctrluri = "https://github.com/carvel-dev/kapp-controller/releases/download/v0.48.2/kctrl-windows-amd64.exe"

function downloadpayloads {

    Write-Output "Downloading packages..."

    iwr -URI $ytturi -OutFile $folder"ytt-windows-amd64.exe"
    iwr -URI $imgpkguri -OutFile $folder"imgpkg-windows-amd64.exe"
    iwr -URI $kblduri -OutFile $folder"kbld-windows-amd64.exe"
    iwr -URI $kappuri -OutFile $folder"kapp-windows-amd64.exe"
    iwr -URI $vendiruri -OutFile $folder"vendir-windows-amd64.exe"
    iwr -URI $kctrluri -OutFile $folder"kctrl-windows-amd64.exe"


}


function renamefiles {

    Write-Output "Renaming files..."

    Rename-Item -Path $folder"ytt-windows-amd64.exe" -NewName ytt.exe
    Rename-Item -Path $folder"imgpkg-windows-amd64.exe" -NewName imgpkg.exe
    Rename-Item -Path $folder"kbld-windows-amd64.exe" -NewName kbld.exe
    Rename-Item -Path $folder"kapp-windows-amd64.exe" -NewName kapp.exe
    Rename-Item -Path $folder"vendir-windows-amd64.exe" -NewName vendir.exe
    Rename-Item -Path $folder"kctrl-windows-amd64.exe" -NewName kctrl.exe

}

function setpath {


    Write-Output "Setting our path..."

    [Environment]::SetEnvironmentVariable(
    "Path",
    [Environment]::GetEnvironmentVariable("Path", [EnvironmentVariableTarget]::Machine) + ";C:\Program Files\tanzu-cli",
    [EnvironmentVariableTarget]::Machine)

}



downloadpayloads
renamefiles
setpath
