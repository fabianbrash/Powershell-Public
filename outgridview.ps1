Clear-Host


$name=@()
$cpu=@()
$minutes=@()
$final=@()

<#$data1 = Read-Host "Enter columns 1 data"
$data2 = Read-Host "Enter column 2 data"
$data3 = Read-Host "Enterr column 3 data"


$data = [PSCustomObject]@{

    Name = $data1
    "CPU Usage %" = $data2
    "Running Time(minutes)" = $data3


}

$data | Out-GridView


#>



####Array of data######################

$data4 = Read-Host "Enter names comma separated"
$data5 = Read-Host "Enter CPU comma separated"
$data6 = Read-Host "Enter minutes comma separated"


$name=$data4.Split(',').Trim()
$cpu = $data5.Split(',').Trim()
$minutes=$data6.Split(',').Trim()

  for($c=0; $c -lt $name.Length; $c++) {
    $final+= [PSCustomObject]@{
  
        Name =                                $name[$c]
        "CPU Usage %" =                       $cpu[$c]
        "Running Time(minutes)" =             $minutes[$c]
      }

   }

$final | Out-GridView
