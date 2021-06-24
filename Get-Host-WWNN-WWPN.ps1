Clear-Host

try {
    Import-Module -Name VMware.VimAutomation.Core
	}
	
catch{

    Write-Error -Message "Could not load VMware.VimAutomation.Core module..."
	}



Set-PowerCLIConfiguration -DefaultVIServerMode Multiple -Scope User -Confirm:$false | Out-Null

<# Do this for long running tasks 12.5 Hours for the script to complete #>
Set-PowerCLIConfiguration -WebOperationTimeoutSeconds 45000 -Scope User -Confirm:$false | Out-Null

Set-PowerCLIConfiguration -Scope User -ParticipateInCEIP $false -Confirm:$false | Out-Null

Set-PowerCLIConfiguration -InvalidCertificateAction Ignore -Scope User -Confirm:$false | Out-Null


$vc = "vc"

Connect-VIServer -Server $vc
#Connect-VIServer -Server $vc -AllLinked

$DC1 = "DC1"
$DC2 = "DC2"
$Cluster = "myCluster"



<# Get all hosts in a cluster #>


$WWNN = @{label="WWNN";e={"{0:X}" -f ($_.NodeWorldWideName) | ForEach-Object {$_.Insert(2, ':').Insert(5, ':').Insert(8, ':').Insert(11, ':').Insert(13, ':').Insert(16, ':').Insert(19, ':').Insert(21, ':')} }}
$WWPN = @{label='WWPN';e={"{0:X}" -f $_.PortWorldWideName | ForEach-Object {$_.Insert(2, ':').Insert(5, ':').Insert(8, ':').Insert(11, ':').Insert(13, ':').Insert(16, ':').Insert(19, ':').Insert(21, ':')}}}

$list = Get-Cluster $Cluster | Get-VMhost | Get-VMHostHBA -Type FibreChannel | Select VMHost,Device,$WWNN,$WWPN | Sort VMhost,Device | ft -AutoSize

<#$list = Get-Datacenter $DC2 | Get-VMhost | Get-VMHostHBA -Type FibreChannel | Select VMHost,Device,$WWNN,$WWPN | Sort VMhost,Device | ft -AutoSize#>



<# Let's just get all host(s) #>
<#$list = Get-VMhost | Get-VMHostHBA -Type FibreChannel | Select VMHost,Device,$WWNN,$WWPN | Sort VMhost,Device | ft -AutoSize#>


#Go through each row and put : between every 2 digits
<#foreach ($item in $list){
   $item.wwpn = (&{for ($i=0;$i -lt $item.wwpn.length;$i+=2)   
                    {     
                        $item.wwpn.substring($i,2)   
                    }}) -join':' 
}#>


$list

Disconnect-VIServer * -Confirm:$false -Force

