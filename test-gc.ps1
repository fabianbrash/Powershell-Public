Clear-Host

try {
    Import-Module -Name VMware.VimAutomation.Core
	}
	
catch{

    Write-Error -Message "Could not load VMware.VimAutomation.Core module..."
	}


Set-PowerCLIConfiguration -Scope User -DefaultVIServerMode Multiple -Confirm:$false | Out-Null

<# Do this for long vMotions 12.5 Hours for the script to complete #>
Set-PowerCLIConfiguration -Scope User -WebOperationTimeoutSeconds 45000 -Confirm:$false | Out-Null


$vc = "vc"
$Output=@()

$creds = Get-Credential

$VMs = Get-Content -Path C:\Desktop\vms.txt

Connect-VIServer -Server $vc -Credential $creds


$VMs | ForEach-Object {


    $Output+= Get-VM -Name $_ | Select-Object * | Where-Object{$_.PowerState -eq "PoweredOn"}
    #Get-VM -Name $_ | Select-Object * | Format-List
}

<# Cannot be used with | ft or | fl#>
$Output | Out-GridView
