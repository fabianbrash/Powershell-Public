Clear-Host


$hs = @{

  Name = @("John", "Pete")
  Age = 1,150,25,33,28,82,6,100,2,125

}

$hs.Name[0]
$hs.Age[0]

Write-Host "--------------------------------------------------------------------------------------"

$hs.Name[1]
$hs.Age[1]


Write-Host "--------------------------------------------------------------------------------------"

$youngest = $hs.Age | Sort-Object| Select-Object -First 1
$oldest = $hs.Age | Sort-Object -Descending | Select-Object -First 1

Write-Host "The youngest one is" $youngest
Write-Host "The eldest one is" $oldest
