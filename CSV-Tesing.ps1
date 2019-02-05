Clear-Host

$D = Import-Csv -Path 'C:\Downloads\PSData.csv'

<#$D | Get-Member

$Age = $D.Age
$Name = $D.Name#>

$IPArray = @($D.IP)
$NameArray = @($D.Name)

<#foreach($Ages in $D) {
  
  $AgeArray += $D.Age
}

foreach($Names in $D) {

  $NameArray += $D.Name
}#>




$IPArray | ForEach-Object {

  Write-Host $_

}

$NameArray | ForEach-Object {

  Write-Host $_

}

Write-Host "===================================================================="

for($i=0; $i -lt $IPArray.Length; $i++) {

    Write-Host $IPArray[$i]

}


<#Write-Host $AgeArray
Write-Host $NameArray#>
