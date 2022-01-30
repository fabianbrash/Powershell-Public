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

####Ignore Certificate issues this resolves an issue with New-VM in PowerCLI 11.0 but I'm certain for peace of mind just do this by default

Set-PowerCLIConfiguration -InvalidCertificateAction Ignore -Scope User -confirm:$false | Out-Null

Set-PowerCLIConfiguration -Scope User -ParticipateInCEIP $false -Confirm:$false | Out-Null

$vc = "vc"


Connect-VIServer -Server $vc -Credential $vcCred


$VM = Get-VM -Name (Read-Host "Enter VM Name") #Replace this string with your VM name

#$VMList = @()
$VMList = Get-Content -Path C:\path_to_text_file\file.txt


$VMs = Get-VM -Name $VMList

$code3 = @'
$theGroup = "MyGroup"
$found = Get-LocalGroupMember -Name 'Administrators' | Where-Object { $_.Name -like '*'+$theGroup }
if($found) {
    Write-Host "Found group $theGroup"
}
else {
    Write-Host "Did not find group $theGroup"
}
'@

$code2 = @"
Get-Process
"@

## Note the difference above it seems if you want to use variables you need @' '@ if you don't need variables then @" "@ is okay
<# Get creds for OS #>
$guestCredentials = Get-Credential

$VMs | ForEach-Object {

    $sINvoke = @{
      VM = $_
      GuestCredential = $guestCredentials
      ToolsWaitSecs = 120
      ScriptText = $code3
      
    }

#ScriptType = PowerShell note this caused the script to just stop and do nothing...
    Invoke-VMScript @sINvoke

}


Disconnect-VIServer * -force -Confirm:$false
