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

Set-PowerCLIConfiguration -InvalidCertificateAction Ignore -confirm:$false | Out-Null

$vc = "vc"


Connect-VIServer -Server $vc  -Credential $vcCred


$VM = Get-VM -Name (Read-Host "Enter VM Name") #Replace this string with your VM name

#$VMList = @()
$VMList = Get-Content -Path C:\path_to_text_file\file.txt
$theGroup = "MyGroup"

$VMs = Get-VM -Name $VMList

$code3 = @"
$found = Get-LocalGroupMember -
Name 'Administrators' | where{$_.Name -like '*'+$theGroup}
if($found) {
    Write-Host "$theGroup found on $env:COMPUTERNAME"
}
else {
    Write-Host "Did not find $theGroup"
}
"@

<# Get creds for OS #>
$cred = Get-Credentials

$VMs | ForEach-Object {

    $sINvoke = @{
      VM = $_
      GuestCredential = $cred
      ToolsWaitSecs = 120
      ScriptText = $code3
      ScriptType = PowerShell
    }


    Invoke-VMScript @sINvoke

}


Disconnect-VIServer * -force -Confirm:$false
