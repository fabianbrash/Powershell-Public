Clear-Host

$IDs = @("Microsoft.SQLServerManagementStudio", "Adobe.AdobeAcrobatReaderDC", "Mozilla.Firefox", "Google.Chrome", "OpenJS.NodeJS", "GoLang.Go")

## Let's set the code to zero so we can have a clean run
$LASTEXITCODE = 0

foreach($ID in $IDs){
    
    if($LASTEXITCODE -eq 0) {
        winget install --id $ID
    }
    
}

<#

winget install --name 'SQL Server Management Studio'

winget install --id Microsoft.SQLServerManagementStudio
if($LASTEXITCODE -eq 0) {
    winget install  --id Oracle.MySQL
}

if($LASTEXITCODE -eq 0) {
    winget install --id Adobe.AdobeAcrobatReaderDC
}

if($LASTEXITCODE -eq 0) {
    winget install --id Adobe.AdobeAcrobatReaderDC
}


#>