Clear-Host

function Menu {

    param (
        [String]$Title = "My Menu",
        [Parameter(Mandatory=$true)]
        [int]$Option
    )
    
    
    
  Write-Host $Title
  Write-Host ""
  Write-Host "======================================================================================="
  Write-Host "Option 1"
  Write-Host "Option 2"
  Write-Host "Option 3"
  Write-Host "======================================================================================="
  Write-Host "You chose $Option"
  
}

Menu -Title "My Mega Menu" -Option 2
