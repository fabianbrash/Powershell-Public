<#
  Purpose: Update docker version
#>

Clear-Host


Find-Package -Name Docker -ProviderName DockerMSFTProvider


Install-Package -Name Docker -ProviderName DockerMSFTProvider -Update -Force


Start-Sleep -Seconds 10

Restart-Service docker

Restart-Computer -Confirm:$false
