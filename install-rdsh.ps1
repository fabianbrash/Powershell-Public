Clear-Host

Install-WindowsFeature -Name "Remote-Desktop-Services", "RDS-RD-Server" -IncludeManagementTools

<# Let's add our reg keys #>

$KEY = "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services"
$licenseServer = "my_server"
$licenseMode = 4  <# 4=per user 2=per device #>

New-ItemProperty -Path $KEY -Name "LicenseServers" -PropertyType String -Value $licenseServer
New-ItemProperty -Path $KEY -Name "LicenseMode" -PropertyType DWord -Value $licenseMode

Restart-Computer -Confirm:$false
