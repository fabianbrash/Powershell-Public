Clear-Host


$final=@()

$data1 = Read-Host "Enter columns 1 data"
$data2 = Read-Host "Enter column 2 data"
$data3 = Read-Host "Enterr column 3 data"

$final+=$data1
$final+=$data2
$final+=$data3

$data = [PSCustomObject]@{

    Name = $data1
    "CPU Usage %" = $data2
    "Running Time(minutes)" = $data3


}

$data | Out-GridView
