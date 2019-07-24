Clear-Host

Get-NetIPAddress | Select-Object -Property ifIndex, IPAddress, PrefixLength, PrefixOrigin, SuffixOrigin, AddressState, Store, @{n='Name';e={($_ | Get-NetAdapter | Select-Object -ExpandProperty Name)}}, @{n='InterfaceDescription';e={($_ | Get-NetAdapter | Select-Object -ExpandProperty ifDesc)}} | ft -Autosize
