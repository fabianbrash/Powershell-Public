<#

##Useful alias' with Powershell, note these are bad for legibility 


CommandType     Name                                               Version    Source
-----------     ----                                               -------    ------
Alias           % -> ForEach-Object
Alias           ? -> Where-Object
Alias           h -> Get-History
Alias           r -> Invoke-History

#>



Clear-Host


Get-PSDrive | ? {$_.Free -gt 1} | Select-Object -Property Root, @{n='Free (GB)';e={"{0:N2}" -f ($_.Free/1gb)}}
