Clear-Host

Set-LocalUser -Name "Administrator" -AccountNeverExpires -PasswordNeverExpires $true -FullName "sa"
Rename-LocalUser -Name "Administrator" -NewName "sa"
Start-Sleep 5
Restart-Computer -Force
