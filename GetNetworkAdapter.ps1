Clear-Host

$TheHosts = @("1", "2", "3")
$OutArray=@()

$Script = {
Get-NetIPAddress | Select-Object -Property @{n='HostName';e={($env:computername)}},IfIndex,IPAddress,SuffixOrigin ,@{n='Name';e={($_ | Get-NetAdapter | Select-Object -ExpandProperty Name)}}, @{n='InterfaceDescription';e={($_ | Get-NetAdapter | Select-Object -ExpandProperty ifDesc)}}, @{n='MacAddress';e={($_ | Get-NetAdapter | Select-Object -ExpandProperty MacAddress)}}, @{n='Status';e={($_ | Get-NetAdapter | Select-Object -ExpandProperty Status)}}, @{n='LinkSpeed';e={($_ | Get-NetAdapter | Select-Object -ExpandProperty LinkSpeed)}} | Where-Object {$_.SuffixOrigin -ne 'WellKnown' -and $_.IPAddress -notlike 'fe*'}

}

#$TheHost = "3"

$TheHosts | % {

$OutArray+=Invoke-Command -ComputerName $_ -ScriptBlock $Script -ErrorAction SilentlyContinue
  
 }

$OutArray | Export-Csv -Path C:\getnet.csv -NoTypeInformation
#$OutArray

 #Get-NetIPAddress | Select-Object -Property IfIndex,IPAddress,SuffixOrigin, @{n='Name';e={($_ | Get-NetAdapter | Select-Object -ExpandProperty Name)}}, @{n='InterfaceDescription';e={($_ | Get-NetAdapter | Select-Object -ExpandProperty ifDesc)}}, @{n='MacAddress';e={($_ | Get-NetAdapter | Select-Object -ExpandProperty MacAddress)}}, @{n='Status';e={($_ | Get-NetAdapter | Select-Object -ExpandProperty Status)}}, @{n='LinkSpeed';e={($_ | Get-NetAdapter | Select-Object -ExpandProperty LinkSpeed)}} | Where-Object {$_.SuffixOrigin -ne 'WellKnown'} | ft -AutoSize
