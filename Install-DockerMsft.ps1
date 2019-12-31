Clear-Host


Install-WindowsFeature -Name Containers


Install-Module -Name DockerMsftProvider -Repository PSGallery -Force -Confirm:$false
Install-Package -Name docker -ProviderName DockerMsftProvider -Force -Confirm:$false

Start-Sleep -Seconds 8

Restart-Computer -Force
