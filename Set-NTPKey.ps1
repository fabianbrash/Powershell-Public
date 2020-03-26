Clear-Host

$KEY = "HKLM:\SYSTEM\CurrentControlSet\Services\W32Time\Parameters"

Set-ItemProperty -Path $KEY -Name "Type" -Value "NTP"
Set-ItemProperty -Path $KEY -Name "NtpServer" -Value "IP_OR_DNS_OF_NTP_SERVER,0x8"
