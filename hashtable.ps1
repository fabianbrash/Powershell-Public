
#REF: https://kevinmarquette.github.io/2016-11-06-powershell-hashtable-everything-you-wanted-to-know-about/

Clear-Host

Write-Host "_________________________________________________"

###HashTables


$person = @{

    Name = "Fabian"
    Age = 38
    "MOB" = "November"
    
 }
 
 $person.Name+ " " +$person.Age+ " "+$person.MOB
 
 $person
 
 $person.Name+$person.Age+$person.MOB
