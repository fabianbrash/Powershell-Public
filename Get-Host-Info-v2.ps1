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




[int]$isDEV = 1
$theDate = Get-Date -DisplayHint Date

$results=@()
$HostName=@()
$HostResults=@()

if($isDEV -eq 1) {
$vcCred = Import-Clixml -Path "C:\t.Cred"
$cred = Import-Clixml -Path "C:\lx.Cred"
$vc = "vc1"
}

elseif($isDEV -eq 0){
$vcCred=''
$cred=''
#$vc = "vc2"
}

#$vcCred = Import-Clixml -Path "C:\la.Cred"
if($vcCred -eq '') {
$vcCred = Get-Credential
}

#$cred = Import-Clixml -Path "C:\lx.Cred"
if($cred -eq '') {
$cred = Get-Credential
}

Connect-VIServer -Server $vc -Credential $vcCred
#Connect-VIServer -Server $vc -AllLinked

$DC = Get-Datacenter -Name "DC1"

#$Nodes = Get-VMHost -Location "DC1" 

#$Nodes.Name | ft

<#
  Before we gather our information let's restart the management agents
  #>

  <#$Nodes | % {

      Get-VMHostService -VMHost $_ | where {$_.Key -eq "vpxa"} | Restart-VMHostService -Confirm:$false -ErrorAction SilentlyContinue

}#>


#$TheHost = Get-View -ViewType HostSystem -Filter @{"Name" = "host"}

#$TheHost = Get-View -ViewType HostSystem

$TheHost = Get-View -ViewType HostSystem -SearchRoot $DC.ExtensionData.MoRef


$TheHost | % {
   
   $results+= $_.Name
   $results += $_.Hardware.BiosInfo

}

#$results
#$theDate

$results | Out-File -FilePath C:\BIOS.log
$theDate | Out-File -FilePath C:\BIOS.log -Append

Get-FileHash C:\BIOS.log | Out-File -FilePath C:\BIOS-hash.log -Append

$DCHosts = Get-Datacenter -Name "DC1" | Get-VMHost



$esxcli = Get-Esxcli -VMHost $DCHosts -V2

$DCHosts | % {

$HostResults+= $_.Name

$HostResults+= $esxcli.network.ip.connection.list.Invoke() | Select-Object -Property LocalAddress, Proto, State, WorldName | Where-Object {$_.State -eq "LISTEN" -and $_.LocalAddress -notlike "*fe*"}
$HostResults+= [Environment]::NewLine

}


#$HostName | Export-Csv -Path C:\PORTS.csv -NoTypeInformation
$HostResults | Out-File -FilePath C:\PORTS.log

$vcsaBuild = $Global:DefaultVIServer | Select Name, Version, Build

$vcsaBuild | Out-File -FilePath C:\vcsa.log

