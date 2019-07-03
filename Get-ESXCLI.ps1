<#
 REF: https://www.virten.net/2016/11/how-to-use-esxcli-v2-commands-in-powercli/
#>


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


if($isDEV -eq 1) {
$vcCred = Import-Clixml -Path "C:\la.Cred"
$cred = Import-Clixml -Path "C:\lx.Cred"
$vc = "vc"
}

elseif($isDEV -eq 0){
$vcCred=''
$cred=''
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

$TheHost = Get-VMHost -Name "host"

$esxcli = Get-EsxCli -VMHost $TheHost -V2

##Note for -V2 you must use .Invoke()

$esxcli.software.vib.list.Invoke() | Select-Object Name,Vendor,Version | ft

