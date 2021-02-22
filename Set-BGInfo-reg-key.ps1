Clear-Host

<# Let's speed up our downloads.. #>
$ProgressPreference = 'SilentlyContinue' 

<# Let's download our zip file #>
Invoke-WebRequest -URI https://containerblobs.blob.core.windows.net/installers/BGInfo.zip -OutFile C:\BGInfo.zip

<# Expand our zip file #>
Expand-Archive -Path C:\BGInfo.zip -DestinationPath C:\

$rootKey = "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run"
$bginfo = "C:\BGInfo\Bginfo.exe C:\BGInfo\default.bgi /timer:0 /silent /nolicprompt"

New-ItemProperty -Path $rootKey -Name "BgInfo" -PropertyType String -Value $bginfo

