Clear-Host

try {

    Import-Module VMware.VimAutomation.Core -ErrorAction Stop
}

catch {
    Write-Error -Message "VMware core automation module could not be loaded..."
}

####Ignore Certificate issues this resolves an issue with New-VM in PowerCLI 11.0 but I'm certain for peace of mind just do this by default

Set-PowerCLIConfiguration -InvalidCertificateAction Ignore -confirm:$false


<## Note the above "fix" did not work for me what did work was setting -ErrorAction SilentlyContinue##>

<# VARS #>
$vc = "vc"

<#$code = @"
Set-LocalUser -Name Administrator -AccountNeverExpires -PasswordNeverExpires $true -FullName newname
ReName-LocalUser -Name Administrator -NewName newname
Start-Sleep 3
Restart-Computer -Force
"@#>

$Creds = Import-Clixml -Path C:\Users\creds.Cred

$Cred = Import-Clixml -Path C:\creds.Cred
Connect-VIServer -Server $vc -Credential $Cred

$vm = Get-VM -Name "theVM"
$admin = "Administrator"
$yes = "`$true"
$no = "`$false"
$fname = "newname"
$theshare = "\\localhost\testshare"
$spath = "D:\ShareA"
$adminG = "Administrators"

$code = @"
Get-NetAdapter | ft
Set-LocalUser -Name ${admin} -AccountNeverExpires -PasswordNeverExpires ${yes} -FullName ${fname}
"@

$code1 = @"
ReName-LocalUser -Name ${admin} -NewName ${fname}
Restart-Computer
"@

#Below does not work all the way still a WIP
$createshare = @"
New-SmbShare -Name "testshare" -Path ${spath} -Description "Test Share" -FullAccess ${adminG}, "ShareAUser"
${acl} = Get-Acl ${theshare}
${acl}.SetAccessRuleProtection(${yes},${no})
${acl} | Set-Acl ${theshare}
${acl} = Get-Acl ${theshare}
${AccessRule} = New-Object System.Security.AccessControl.FileSystemAccessRule("Administrators", "FullControl", 'ContainerInherit, ObjectInherit', 'None', "Allow")
${AccessRule1} = New-Object System.Security.AccessControl.FileSystemAccessRule("ShareUsers", "FullControl", 'ContainerInherit, ObjectInherit', 'None', "Allow")

${acl}.SetAccessRule(${AccessRule})
${acl} | Set-Acl ${theshare}

${acl}.SetAccessRule(${AccessRule1})
${acl} | Set-Acl ${theshare}
Get-Acl ${theshare} | fl
"@

#Invoke-VMScript -VM $vm -ScriptText $code -GuestCredential $Creds -ToolsWaitSecs 40
#Invoke-VMScript -VM $vm -ScriptText $code1 -GuestCredential $Creds -ToolsWaitSecs 40 -ErrorAction SilentlyContinue
#Invoke-VMScript -VM $vm -ScriptText $createshare -GuestCredential(Get-Credential) -ToolsWaitSecs 40

