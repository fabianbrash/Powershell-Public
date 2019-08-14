Clear-Host


 Get-PSDrive | ? {$_.Free -gt 1} | Select-Object -Property Root, @{n='Free (GB)';e={"{0:N2}" -f ($_.Free/1gb)}}
