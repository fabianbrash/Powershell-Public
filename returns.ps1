Clear-Host

<#
 Note PowerShell is unlike most programming languages when it comes to returning a value from a function
 it will return more than the variable it will also return the data from write-host if you use it
 hence I am using the Write-Information method instead, so be careful when using return
#>


function myFunc {

    param($myAge)

# let's mutate our state
$myAge * 3

Write-Information "This function returns the users' age" -InformationAction Continue

return $myAge
}

function returnHash {

    param()

  $user = @{
    id = Get-Random -Maximum 11;
    name = "User1";
    age = Get-Random -Minimum 1 -Maximum 100

  }

  return $user
}

function myMain {

    param()
    $legal = 21
    $myHash = @{}
    $age = myFunc -myAge 21
    $myHash = returnHash
    #$age

  if($age -ge $legal) {
    Write-Output "You are legal..."
  } else {
    Write-Output "You are not legal..."
  }

  $myHash.values

}

myMain
