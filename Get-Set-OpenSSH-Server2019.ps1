Clear-Host



##Let's first get what we can install
Get-WindowsCapability -Online | ? Name -like 'OpenSSH*'


##On Server 2019 OpenSSH client should already be installed we just need to install the server, but if it isn't then
# Install the OpenSSH Client
<# Add-WindowsCapability -Online -Name OpenSSH.Client~~~~0.0.1.0 #>


# Install the OpenSSH Server
Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0

# Start our service
Start-Service sshd
# Automatically start our service
Set-Service -Name sshd -StartupType 'Automatic'

# We need to enable ssh-agent and then start it up

Set-Service -Name ssh-agent -StartupType 'Automatic'
Start-Service -Name ssh-agent

# Confirm the Firewall rule is configured. It should be created automatically by setup. 
Get-NetFirewallRule -Name *ssh*

# There should be a firewall rule named "OpenSSH-Server-In-TCP", which should be enabled
# If the firewall does not exist, create one
#New-NetFirewallRule -Name sshd -DisplayName 'OpenSSH Server (sshd)' -Enabled True -Direction Inbound -Protocol TCP -Action Allow -LocalPort 22

# Let's see if all or services are running

Get-Service | Where-Object {$_.Name -like '*SSH*'}
