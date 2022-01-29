Clear-Host

try {
    Import-Module -Name VMware.VimAutomation.Core
	}
	
catch{

    Write-Error -Message "Could not load VMware.VimAutomation.Core module..."
	}


Set-PowerCLIConfiguration -DefaultVIServerMode Multiple -Scope User -Confirm:$false | Out-Null

<# Do this for long vMotions 12.5 Hours for the script to complete #>
Set-PowerCLIConfiguration -WebOperationTimeoutSeconds 45000 -Scope User -Confirm:$false | Out-Null

$vc = "vc"


Connect-VIServer -Server $vc  -Credential $vcCred


$VM = Get-VM -Name (Read-Host "Enter VM Name") #Replace this string with your VM name

$VMList = @()
$theGroup = "MyGroup"

$VMs = Get-VM -Name $VMList

$code3 = @"
Get-LocalGroupMember -
Name 'Administrators' | where{$_.Name -eq $theGroup}
"@


$sINvoke = @{
    VM = $VMs
    GuestCredential = $cred
    ToolsWaitSecs = 120
    ScriptText = $code3
    ScriptType = PowerShell
}


Invoke-VMScript @sINvoke


Disconnect-VIServer * -force -Confirm:$false
