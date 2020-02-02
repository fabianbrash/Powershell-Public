Clear-Host


$Endpoint = "https://api.coindesk.com/v1/bpi/currentprice.json"
$redditEndpoint = "https://reddit.com/.json"
#$outPut=@()


$CryptoJSON = Invoke-RestMethod -Uri $Endpoint -Method Get


$CryptoJSON.chartName

#$CryptoJSON.bpi | Format-List

#$CryptoJSON.bpi.USD

#$CryptoJSON.bpi.GBP

#$CryptoJSON.bpi.EUR

Write-Output "========================================================================"

<#$CryptoJSON | ForEach-Object {


    $_.bpi
}#>

$CryptoJSON.time.updated

$valueUSD = $CryptoJSON.bpi.USD
$valueGBP = $CryptoJSON.bpi.GBP
$valueEURO = $CryptoJSON.bpi.EUR

$valueUSD.rate

$valueGBP.rate

$valueEURO.rate

[int]$breakOut = $valueUSD.rate
if($breakOut -gt 9000) {

    Write-Output "BTC is on the move..."
}

else {Write-Output "Here we good again another failed breakout..."}



Write-Output "==============================================================================================================="


$redditJSON = Invoke-RestMethod -Method Get -Uri $redditEndpoint
$redditData = $redditJSON.data

#$redditData.children

$highUPS = $redditData.children.data | Where-Object {$_.ups -ge 50000}

($highUPS).count

$highUPS | Select-Object -Property ups, title

#$highUPS  | Select-Object -Property @{n='ups'; e={$_.ups}}, title
