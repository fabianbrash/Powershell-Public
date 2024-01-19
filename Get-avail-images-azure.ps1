Clear-Host

$location = "westus"
$publisher = "MicrosoftWindowsServer"
$offerName = "WindowsServer"
$skuName = "2022-datacenter-azure-edition-core"
## Let's get all Publishers in the eastus

#Get-AzVMImagePublisher -Location "eastus" | Select-Object PublisherName

## Just show me Microsoft

Write-Output "Showing publisher (Microsoft)"
Get-AzVMImagePublisher -Location $location | Where-Object {$_.PublisherName -like "*Microsoft*"}

Write-Output "Showing Images on Offer"
Get-AzVMImageOffer -Location $location -PublisherName $publisher | Format-Table

Write-Output "Showing SKUs on offer"
Get-AzVMImageSku -Location $location -PublisherName $publisher -Offer $offerName | Format-Table

Write-Output "Showing version(s) on offer for a particular SKU"
Get-AzVMImage -Location $location -PublisherName $publisher -Offer $offerName -Skus $skuName | Format-Table

