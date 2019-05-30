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
$results=@()

if($isDEV -eq 1) {
$vcCred = Import-Clixml -Path "C:\power.Cred"
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

Write-Host ""

#$TheHost = Get-View -ViewType HostSystem -Filter @{"Name" = "host1"}

$TheHost = Get-View -ViewType HostSystem


$TheHost | % {
   
   $results+= $_.Name
   $results += $_.Hardware.BiosInfo

}

$results | Out-File -FilePath C:\BIOS.log

#Start-Sleep -Seconds 6

Get-FileHash C:\BIOS.log | Out-File -FilePath C:\BIOS-hash.log -Append
