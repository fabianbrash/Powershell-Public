Clear-Host

$TheHosts = @("1", "2", "3")
$OutArray=@()

$Script = {
Get-NetIPAddress | Select-Object -Property @{n='HostName';e={($env:computername)}},IfIndex,IPAddress,SuffixOrigin ,@{n='Name';e={($_ | Get-NetAdapter | Select-Object -ExpandProperty Name)}}, @{n='InterfaceDescription';e={($_ | Get-NetAdapter | Select-Object -ExpandProperty ifDesc)}}, @{n='MacAddress';e={($_ | Get-NetAdapter | Select-Object -ExpandProperty MacAddress)}}, @{n='Status';e={($_ | Get-NetAdapter | Select-Object -ExpandProperty Status)}}, @{n='LinkSpeed';e={($_ | Get-NetAdapter | Select-Object -ExpandProperty LinkSpeed)}} | Where-Object {$_.SuffixOrigin -ne 'WellKnown'}

}

#$TheHost = "3"

$TheHosts | % {

$OutArray+=Invoke-Command -ComputerName $_ -ScriptBlock $Script -ErrorAction SilentlyContinue
  
 }

$OutArray | Export-Csv -Path C:\Users\FABIAN4-DSA\Desktop\Output\getnet.csv -NoTypeInformation
#$OutArray

 #Get-NetIPAddress | Select-Object -Property IfIndex,IPAddress,SuffixOrigin, @{n='Name';e={($_ | Get-NetAdapter | Select-Object -ExpandProperty Name)}}, @{n='InterfaceDescription';e={($_ | Get-NetAdapter | Select-Object -ExpandProperty ifDesc)}}, @{n='MacAddress';e={($_ | Get-NetAdapter | Select-Object -ExpandProperty MacAddress)}}, @{n='Status';e={($_ | Get-NetAdapter | Select-Object -ExpandProperty Status)}}, @{n='LinkSpeed';e={($_ | Get-NetAdapter | Select-Object -ExpandProperty LinkSpeed)}} | Where-Object {$_.SuffixOrigin -ne 'WellKnown'} | ft -AutoSize
