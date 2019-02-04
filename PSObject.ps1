

Clear-Host


$myObj = New-Object PSObject

Add-Member -InputObject $myObj -MemberType NoteProperty -Name prop1 -Value "obj1"
Add-Member -InputObject $myObj -MemberType NoteProperty -Name prop2 -Value "obj2"
Add-Member -InputObject $myObj -MemberType NoteProperty -Name name -Value "Fabian Brash"
Add-Member -InputObject $myObj -MemberType NoteProperty -Name age -Value "38"


Write-Host "Property 1 is:"$myObj.prop1
Write-Host "Property 2 is:"$myObj.prop2
Write-Host "My name is:"$myObj.name
Write-Host "My age is:"$myObj.age