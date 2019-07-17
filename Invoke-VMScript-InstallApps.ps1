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
$vcCred = Import-Clixml -Path "C:\Creds\la.Cred"
$cred = Import-Clixml -Path "C:\Creds\ds.Cred"
$vc = "vc"
}

elseif($isDEV -eq 0){
$vcCred=''
$cred=''
#$vc = "vc"
}

#$vcCred = Import-Clixml -Path "C:\Creds\la.Cred"
if($vcCred -eq '') {
$vcCred = Get-Credential
}

#$cred = Import-Clixml -Path "C:\Creds\lx.Cred"
if($cred -eq '') {
$cred = Get-Credential
}

Connect-VIServer -Server $vc -Credential $vcCred
#Connect-VIServer -Server $vc -AllLinked

$VM = Get-VM -Name "thevm"



<#
 # First let's  copy our install file to a common location on our VM, obviously modify this
#>
##Copy file(s) to a VM
Copy-VMGuestFile -Source C:\Win8.1AndW2K12R2-KB3191564-x64.msu -Destination C:\Installs\ -VM $VM -LocalToGuest -GuestCredential $cred
Start-Sleep -Seconds 20
##Let's do the reverse and copy a file from the VM to the local system

#Copy-VMGuestFile -Source C:\LINUX\CentOS-7-x86_64-Minimal-1810_801cbdf2-90f9-4f55-bf46-367fe0a31b4b.iso -Destination C:\InstallFiles\ -VM $VM -GuestToLocal -GuestCredential $cred


<#
 # Now let's install the app
#>


$InstallCode = @'

wusa.exe C:\Installs\Win8.1AndW2K12R2-KB3191564-x64.msu /quiet

'@



$sInvoke = @{

    VM = $VM
    GuestCredential = $cred
    ToolsWaitSecs = 180
    ScriptText = $InstallCode
    ScriptType = 'Powershell'
}


Invoke-VMScript @sInvoke

