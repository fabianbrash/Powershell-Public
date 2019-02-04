Clear-Host


<# Note we can convert it to JSON with ConvertTo-JSON for an API call #>

<# This is a Hash table in Powershell #>


$Var = "/apiexplorer"
$vc = "https://pcdlvcsa.ent.corp"

$restAPI = @{

    "BaseURI" = "https://pcdlvcsa.ent.corp/rest"
    "VM" = "/vcenter/vm"
    "APIHome" = $Var  <# Both ways to reference a variable works#>
    "vcbase" = $($vc)
    
    }
    
    #$restAPI
    ##Now we can reference with dot notation
    
    
    Write-Host ""
    Write-Host "----------------------------------------------"
    $restAPI.BaseURI
    $restAPI.VM
    
    Write-Host "And now let's combine them together"
    $restAPI.BaseURI + $restAPI.VM
    $restAPI.vcbase + $restAPI.APIHome
    
    Write-Host "-----------------------------------------------"
    
