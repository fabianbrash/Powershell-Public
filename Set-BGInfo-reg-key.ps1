Clear-Host


$rootKey = "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run"
$bginfo = "C:\BGInfo\Bginfo.exe C:\BGInfo\default.bgi /timer:0 /silent /nolicprompt"

Set-ItemProperty -Path $rootKey -Name "BgInfo" -Type String -Value $bginfo

