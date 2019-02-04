#$DomainPass = "Password" | ConvertTo-SecureString -AsPlainText -Force
#Invoke-VMScript -VM $VMs[$i] -ScriptText $Power_ByPass -GuestCredential (Get-Credential) -ErrorAction Stop


Clear-Host

try
    {
        Import-Module -Name VMware.VimAutomation.Core -ErrorAction Stop
    }
catch
    {
        Write-Error -Message "Could not load Core Modules"
    }



<# All our Credentials go here
#>

$DomainUser = 'fbrash'
$LocalUser = 'Administrator'
$VCenterUser = "fabian@vsphere2.local"
$PassFile = 'C:\Users\fbrash\Documents\password.txt'
$MyDomainCred = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $DomainUser, (Get-Content $PassFile | ConvertTo-SecureString)
$MyVCCred = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $VCenterUser, (Get-Content $PassFile | ConvertTo-SecureString)
$MyLocalCred = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $LocalUser, (Get-Content $PassFile | ConvertTo-SecureString)


$VC = 'lab-vcsa-01.lab.net'
$OU = 'OU=Production,OU=LabServers,DC=lab,DC=net'

$TheDomain = 'lab.net'
$DomainJoinScript = "Add-Computer -DomainName lab.net -Credential $MyDomainCred -Force -Restart"

Connect-VIServer -Server $VC -Credential $MyVCCred

$VMs = @('lab-fs-01','lab-fs-02')
$TargetUser = 'Administrator'
$Power_ByPass = 'Set-ExecutionPolicy Unrestricted -Confirm:$False'

for($i=0; $i -lt $VMs.Length; $i++)
        {

            try
                {
                    Invoke-VMScript -VM $VMs[$i] -ScriptText $Power_ByPass -GuestCredential $MyLocalCred -ErrorAction Stop
                    Invoke-VMScript -VM $VMs[$i] -ScriptText $DomainJoinScript -GuestCredential $MyLocalCred -ErrorAction Stop
                }
catch
    {
        Write-Error -Message "Unable to customize Guest VM..."
    }
}
 
 #Write-Verbose -Message "The Following systems have been joined to AD successfully"$VMs -Verbose   