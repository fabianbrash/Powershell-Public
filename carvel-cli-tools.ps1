Clear-Host

<# Let's speed up our downloads.. #>
$ProgressPreference = 'SilentlyContinue'

$profile=$env:USERPROFILE
$usermode=1

if($usermode -eq 0) {
    
    New-Item -ItemType Directory 'C:\Program Files\tanzu-cli'
    $folder = "C:\Program Files\tanzu-cli\"
    Write-Host $folder
}

else {
    
    New-Item -ItemType Directory $profile"\tanzu-cli"
    $folder = $profile+"\tanzu-cli\"
    Write-Host $folder
}

#New-Item -ItemType Directory -Path $profile$folder


$ytturi = "https://github.com/carvel-dev/ytt/releases/download/v0.45.6/ytt-windows-amd64.exe"
$imgpkguri = "https://github.com/carvel-dev/imgpkg/releases/download/v0.39.0/imgpkg-windows-amd64.exe"
$kblduri = "https://github.com/carvel-dev/kbld/releases/download/v0.38.1/kbld-windows-amd64.exe"
$kappuri = "https://github.com/carvel-dev/kapp/releases/download/v0.59.1/kapp-windows-amd64.exe"
$vendiruri = "https://github.com/carvel-dev/vendir/releases/download/v0.35.2/vendir-windows-amd64.exe"
$kctrluri = "https://github.com/carvel-dev/kapp-controller/releases/download/v0.48.2/kctrl-windows-amd64.exe"
$tanzucliuri = "https://github.com/vmware-tanzu/tanzu-cli/releases/download/v1.1.0/tanzu-cli-windows-amd64.zip"

function downloadpayloads {

    Write-Output "Downloading packages..."

    iwr -URI $ytturi -OutFile $folder"ytt-windows-amd64.exe"
    iwr -URI $imgpkguri -OutFile $folder"imgpkg-windows-amd64.exe"
    iwr -URI $kblduri -OutFile $folder"kbld-windows-amd64.exe"
    iwr -URI $kappuri -OutFile $folder"kapp-windows-amd64.exe"
    iwr -URI $vendiruri -OutFile $folder"vendir-windows-amd64.exe"
    iwr -URI $kctrluri -OutFile $folder"kctrl-windows-amd64.exe"
    iwr -Uri $tanzucliuri -OutFile $folder"tanzu-cli-windows-amd64.zip"
    # We need to expand the above
    Expand-Archive -Path $folder"tanzu-cli-windows-amd64.zip" -DestinationPath $folder
   
}


function renamefiles {

    Write-Output "Renaming files..."

    Rename-Item -Path $folder"ytt-windows-amd64.exe" -NewName ytt.exe
    Rename-Item -Path $folder"imgpkg-windows-amd64.exe" -NewName imgpkg.exe
    Rename-Item -Path $folder"kbld-windows-amd64.exe" -NewName kbld.exe
    Rename-Item -Path $folder"kapp-windows-amd64.exe" -NewName kapp.exe
    Rename-Item -Path $folder"vendir-windows-amd64.exe" -NewName vendir.exe
    Rename-Item -Path $folder"kctrl-windows-amd64.exe" -NewName kctrl.exe
    # We need to do some extra work since it's a zip file
    Rename-Item -Path $folder"\v1.1.0\tanzu-cli-windows_amd64.exe" -NewName tanzu.exe
    Start-Sleep -Seconds 2
    Move-Item -Path $folder"\v1.1.0\tanzu.exe" -Destination $folder
    Start-Sleep -Seconds 2

}

function setpath {


    if($usermode -eq 0) {
    Write-Output "Setting our path for all users..."
    [Environment]::SetEnvironmentVariable(
    "Path",
    [Environment]::GetEnvironmentVariable("Path", [EnvironmentVariableTarget]::Machine) + ";C:\Program Files\tanzu-cli",
    [EnvironmentVariableTarget]::Machine)
    }

    else {
    Write-Output "Setting our path for the current user only..."
    [Environment]::SetEnvironmentVariable(
    "Path",
    [Environment]::GetEnvironmentVariable("Path", [EnvironmentVariableTarget]::User) + ";$folder",
    [EnvironmentVariableTarget]::User)
    }
    
 }

 function cleanup {
 
     Write-Output "Cleaning up..."
     Remove-Item -Path $folder"tanzu-cli-windows-amd64.zip" -Force -Confirm:$false
     Remove-Item -Path $folder"v1.1.0" -Force -Confirm:$false   
 
 }

 function launch {
     
     # Assumes we have powershell >=6
     Start-Process pwsh
 
 }


downloadpayloads
renamefiles
setpath
cleanup
launch
