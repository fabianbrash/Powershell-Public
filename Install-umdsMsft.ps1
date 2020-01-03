
<#This assumes all the defaults are selected#>

<#Let's check if C:\InstallFiles exists, if not create it#>


if(-not(Test-Path 'C:\InstallFiles')) {

    New-Item -Path C:\InstallFiles -ItemType Directory
}

#$ProgressPreference = 'Continue'

#The below speeds things up greatly
$ProgressPreference = 'SilentlyContinue'
Invoke-WebRequest -UseBasicParsing -Uri https://containerblobs.blob.core.windows.net/installers/umds-Msft.zip -OutFile C:\InstallFiles\umds-Msft.zip


Expand-Archive -Path C:\InstallFiles\umds-Msft.zip -DestinationPath C:\InstallFiles\umds-Msft

Remove-Item -Path C:\InstallFiles\umds-Msft.zip -Force -Confirm:$false

Start-Process C:\InstallFiles\umds-Msft\redist\dotnet\NDP47-KB3186497-x86-x64-AllOS-ENU.exe -ArgumentList "/q /norestart" -Wait -NoNewWindow

<#Note the below doesn't work correctly it generates a bogus error you have to start the installer manually
  and then stop it and re-run the silent install, always something with legacy apps#>
Start-Process C:\InstallFiles\umds-Msft\umds\VMware-UMDS.exe -ArgumentList "/S /v/qn" -Wait -NoNewWindow

Start-Process 'C:\Program Files\VMware\Infrastructure\Update Manager\vmware-umds.exe' -ArgumentList "-G" -Wait -NoNewWindow

<# Install and configure IIS#>
Install-WindowsFeature -Name Web-Server -IncludeManagementTools

<#Enable our mime-types#>
Add-WebConfigurationProperty -PSPath 'MACHINE/WEBROOT/APPHOST' -Filter 'system.webServer/staticContent' -Name '.' -Value @{fileExtension='.vib'; mimeType='application/octet-stream'}

Add-WebConfigurationProperty -PSPath 'MACHINE/WEBROOT/APPHOST' -Filter 'system.webServer/staticContent' -Name '.' -Value @{fileExtension='.sig'; mimeType='application/octet-stream'}


# Create a virtual web directory and point it to the default install path for UMDS on Windows
New-WebVirtualDirectory -Site 'Default Web Site' -Name UMDS_Store -PhysicalPath 'C:\ProgramData\VMware\VMware Update Manager\Data'

# Configure directory browsing for our virtual web directory
Set-WebConfigurationProperty -Filter /system.webserver/directoryBrowse -Name enabled -Value True -PSPath 'IIS:\Sites\Default Web Site\UMDS_Store'


