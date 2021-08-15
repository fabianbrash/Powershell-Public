Clear-Host


function myFunc {

    param()

    <#This makes sure we only return $age and not 'Hello World!!' and the value of $age
      PowerShell is different from other programming languages as it can return everything
      From a function and not just the value you want
      REF: https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_return?view=powershell-5.1
    
    #>


    Write-Information "Hello World!!" -InformationAction Continue

    $age = 19

    return $age

}


function myMain {

    param()

    $legal = 21
    $mainAge = myFunc

    Write-Output $mainAge

    if($mainAge -ge $legal) {
        Write-Output "You are legal"
    } else {
        Write-Output "You are not legal"
    }

}


myMain