Clear-Host

Get-NetIPAddress | Select-Object -Property ifIndex, IPAddress, SuffixOrigin, @{n='Name';e={($_ | Get-NetAdapter | Select-Object -ExpandProperty Name)}}, @{n='InterfaceDescription';e={($_ | Get-NetAdapter | Select-Object -ExpandProperty ifDesc)}}, @{n='MacAddress';e={($_ | Get-NetAdapter | Select-Object -ExpandProperty MacAddress)}}, @{n='Status';e={($_ | Get-NetAdapter | Select-Object -ExpandProperty Status)}}, @{n='LinkSpeed';e={($_ | Get-NetAdapter | Select-Object -ExpandProperty LinkSpeed)}} | ft -Autosize
