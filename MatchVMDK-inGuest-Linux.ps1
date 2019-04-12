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

$vcCred = Import-Clixml -Path "C:\la.Cred"

$cred = Import-Clixml -Path "C:\lx.Cred"

Connect-VIServer -Server $vc  -Credential $vcCred


$VM = Get-VM -Name (Read-Host "Enter VM Name") #Replace this string with your VM name

<#$code = Invoke-VMScript -ScriptText {

ifconfig

} -VM $VM -GuestCredential $cred -ToolsWaitSecs 120 -ScriptType Bash#>



#$OurResults = $code.ScriptOutput.Trim()
#$code.ScriptOutput

#$OurResults | ConvertFrom-Csv

$code = "dmesg | grep -i attached | grep disk"
#Invoke-VMScript -VM $VM -GuestCredential $cred -ToolsWaitSecs 120 -ScriptText $code -ScriptType Bash
#Write-Host "VM: $VM disk info"

$code2 = "dmesg | grep sg | grep -i attached | grep -i 'type 0'"
<#it seems you can't use a newline in the below code for linux#>

$code3 = @'
dmesg | grep -i attached | grep disk
echo '-------------------------------------------------------------------'
dmesg | grep sg | grep -i attached | grep -i 'type 0'
echo '-------------------------------------------------------------------'
echo '-------------------------------------------------------------------'
lsblk
'@

$sINvoke = @{

    VM = $VM
    GuestCredential = $cred
    ToolsWaitSecs = 120
    ScriptText = $code3
    ScriptType = 'bash'
}

Invoke-VMScript @sINvoke


#$OurResults | ft -AutoSize

#$code.ScriptOutput
#$code2.ScriptOutput
#$code3.ScriptOutput

Write-Host "--------------------------------------------------------------------------------------------------------------------"
Write-Host "--------------------------------------------------------------------------------------------------------------------"

Write-Host "From the above output look @ the 3rd column i.e. 2:0:0:0 would be slot 0" -ForegroundColor Cyan
Write-Host "2:0:1:0 would be slot 1" -ForegroundColor Cyan

Write-Host "The sgx output seems all messed up to me match it up with the SCSI slot #" -ForegroundColor Cyan
