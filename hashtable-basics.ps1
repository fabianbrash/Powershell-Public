<#
 REF: https://powershellexplained.com/2016-11-06-powershell-hashtable-everything-you-wanted-to-know-about/
 #>

Clear-Host

$drives = Get-PSDrive | Where Used


#$drives | Select-Object -Property Name,Free



##Now let's create a hashtable

$property = @{

    name = 'totalSpaceGB'
    expression = { ($_.used + $_.free) / 1GB}
}

#$drives | Select-Object -Property name, $property


###OR we can do it this way

$drives | Select-Object -Property name, @{n='totalSpaceGB';e={($_.used + $_.free) / 1GB}}
