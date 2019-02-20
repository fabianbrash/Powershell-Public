Clear-Host

<#
## MultiLine invoke-vmscript
## 
#>


try {

    Import-Module VMware.VimAutomation.Core -ErrorAction Stop
}

catch {
    Write-Error -Message "VMware core automation module could not be loaded..."
}


try {

    Import-Module VMware.VimAutomation.Vds -ErrorAction Stop
}

catch {
    Write-Error -Message "VMware core automation module could not be loaded..."
}

####Ignore Certificate issues this resolves an issue with New-VM in PowerCLI 11.0 but I'm certain for peace of mind just do this by default

Set-PowerCLIConfiguration -InvalidCertificateAction Ignore -confirm:$false


<## Note the above "fix" did not work for me what did work was setting -ErrorAction SilentlyContinue##>

<# VARS #>
$vc = "vc"

#$code = "Get-Process"
$code = @"
Get-Process
Get-NetAdapter | ft
"@

Connect-VIServer -Server $vc
$vm = Get-VM -Name "test"

Invoke-VMScript -VM $vm -ScriptText $code -GuestCredential(Get-Credential) 
