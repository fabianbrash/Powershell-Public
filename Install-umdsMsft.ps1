
<#This assumes all the defaults are selected#>

<#Let's check if C:\InstallFiles exists, if not create it#>
Write-Host "Checking if directory exists..." -ForegroundColor Green
if(-not(Test-Path 'C:\InstallFiles')) {

    New-Item -Path C:\InstallFiles -ItemType Directory
}

Write-Host "Downloading installer..." -ForegroundColor Green
$ProgressPreference = 'SilentlyContinue'
Invoke-WebRequest -UseBasicParsing -Uri https://containerblobs.blob.core.windows.net/installers/umds-Msft.zip -OutFile C:\InstallFiles\umds-Msft.zip


Expand-Archive -Path C:\InstallFiles\umds-Msft.zip -DestinationPath C:\InstallFiles\umds-Msft

Remove-Item -Path C:\InstallFiles\umds-Msft.zip -Force -Confirm:$false

if((Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\NET Framework Setup\NDP\v4\Full").Release -ge 460805) {
      Write-Host ".NET 4.7.x is already installed..." -ForegroundColor Green
}
else {
  Write-Host "Installing prerequisites..." -ForegroundColor Green
  Start-Process C:\InstallFiles\umds-Msft\redist\dotnet\NDP47-KB3186497-x86-x64-AllOS-ENU.exe -ArgumentList "/q /norestart" -Wait -Verb Runas
}

<#Note the below doesn't work correctly it generates a bogus error you have to start the installer manually
  and then stop it and re-run the silent install, always something with legacy apps#>
  Write-Host "Attempting Install..." -ForegroundColor Green
Start-Process C:\InstallFiles\umds-Msft\umds\VMware-UMDS.exe -ArgumentList "/S /v/qn" -Wait -NoNewWindow

<# Install and configure IIS#>
Write-Host "Installing IIS" -ForegroundColor Green
Install-WindowsFeature -Name Web-Server -IncludeManagementTools

<#Enable our mime-types#>
Write-Host "Configuring Mime-Types" -ForegroundColor Green
Add-WebConfigurationProperty -PSPath 'MACHINE/WEBROOT/APPHOST' -Filter 'system.webServer/staticContent' -Name '.' -Value @{fileExtension='.vib'; mimeType='application/octet-stream'}

Add-WebConfigurationProperty -PSPath 'MACHINE/WEBROOT/APPHOST' -Filter 'system.webServer/staticContent' -Name '.' -Value @{fileExtension='.sig'; mimeType='application/octet-stream'}

if(Test-Path 'C:\Program Files\VMware\Infrastructure\Update Manager') {
    Write-Host "Installation was successful moving on to configure iis virtual directories..." -ForegroundColor Green
    Start-Process 'C:\Program Files\VMware\Infrastructure\Update Manager\vmware-umds.exe' -ArgumentList "-G" -Wait -NoNewWindow
    Write-Host "Configuring UMDS..." -ForegroundColor Green
    Start-Process 'C:\Program Files\VMware\Infrastructure\Update Manager\vmware-umds.exe' -ArgumentList "-S -d embeddedEsx-6.0.0 embeddedEsx-6.6.1 embeddedEsx-6.6.2 embeddedEsx-6.6.3" -Wait -NoNewWindow
    Start-Process 'C:\Program Files\VMware\Infrastructure\Update Manager\vmware-umds.exe' -ArgumentList "-S --add-url https://vibsdepot.hpe.com/index.xml --url-type HOST" -Wait -NoNewWindow
    #Start-Process 'C:\Program Files\VMware\Infrastructure\Update Manager\vmware-umds.exe' -ArgumentList "-S --add-url https://vmwaredepot.dell.com/index.xml --url-type HOST" -Wait -NoNewWindow

    # Create a virtual web directory and point it to the default install path for UMDS on Windows
    New-WebVirtualDirectory -Site 'Default Web Site' -Name UMDS_Store -PhysicalPath 'C:\ProgramData\VMware\VMware Update Manager\Data'

    # Configure directory browsing for our virtual web directory
    Set-WebConfigurationProperty -Filter /system.webserver/directoryBrowse -Name enabled -Value True -PSPath 'IIS:\Sites\Default Web Site\UMDS_Store'

    Write-Host "Attempting to Assign rights to the default apppool user" -ForegroundColor Green

    icacls.exe `"C:\ProgramData\VMware\VMware Update Manager\Data`" /grant `"IIS AppPool\DefaultAppPool`":M /t


}

else {
  Write-Host "Installation failed..." -ForegroundColor Cyan 
}


Write-Host "Remember you now need to give the APP Pool user modify rights to the root folder in this case Data..."






