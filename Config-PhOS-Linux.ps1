Clear-Host

try {
    Import-Module -Name VMware.VimAutomation.Core
	}
	
catch{

    Write-Error -Message "Could not load VMware.VimAutomation.Core module..."
	}


Set-PowerCLIConfiguration -DefaultVIServerMode Multiple -Confirm:$false | Out-Null

<# Do this for long vMotions 12.5 Hours for the script to complete #>
Set-PowerCLIConfiguration -WebOperationTimeoutSeconds 45000 -Confirm:$false | Out-Null

$vc = "vc"

$IP = "192.168.1.2/24"
$DNS = "8.8.8.8"
$GW = "192.168.1.1"
$Domain = "photon.local"

$vcCred = Import-Clixml -Path "C:\la.Cred"
if($vcCred -eq '') {
$vcCred = Get-Credential
}

$cred = Import-Clixml -Path "C:\lx.Cred"
if($cred -eq '') {
$cred = Get-Credential
}


Connect-VIServer -Server $vc  -Credential $vcCred


$VM = Get-VM -Name (Read-Host "Enter VM Name") #Replace this string with your VM name




<# It seems you can't use empty newlines in linux#>

$code3 = @"
cp /etc/systemd/network/99-dhcp-en.network /etc/systemd/network/99-dhcp-en.network.BAK
sed -i 's/DHCP=yes/DHCP=no/g' /etc/systemd/network/99-dhcp-en.network
cp -p /etc/systemd/network/99-dhcp-en.network /etc/systemd/network/10-static-en.network
echo Address=$IP >> /etc/systemd/network/10-static-en.network
echo Gateway=$GW >> /etc/systemd/network/10-static-en.network
echo DNS=$DNS >> /etc/systemd/network/10-static-en.network
echo Domains=$Domain >> /etc/systemd/network/10-static-en.network
systemctl restart systemd-networkd
systemctl enable docker
systemctl start docker
cat /etc/systemd/network/10-static-en.network
systemctl status docker

"@


<#tdnf check-update
tdnf update -y >> /updates.log#>

'@

$sINvoke = @{

    VM = $VM
    GuestCredential = $cred
    ToolsWaitSecs = 120
    ScriptText = $code3
    ScriptType = 'bash'
}

Invoke-VMScript @sINvoke
