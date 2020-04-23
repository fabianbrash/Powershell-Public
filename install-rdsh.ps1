Clear-Host

Install-WindowsFeature -Name "Remote-Desktop-Services", "RDS-RD-Server" -IncludeManagementTools -Restart
