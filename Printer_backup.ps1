#FileName:      DHCP_backup.ps1
#Author:        Fabian Brash
#Date:          05-16-2018
#Modified:      05-16-2018


  
  Clear-Host



  ###Make a REST call

  try {

        $data = Invoke-RestMethod -Method Get -Uri 'http://api.fabianbrash.com/printservers.json' -ErrorAction Stop
      }

 catch{
        Write-Error -Message "Error fetching data.."
        Exit
      }


$PrintServers = @()
$PrintServersTest = @('test-fs-01', 'test2-01')
$BackupTarget = '\\test-fs-01\E$\PrinterExport\2018\'
$Extension = '.printerExport'
$printbrm = 'C:\Windows\System32\spool\tools\PrintBrm.exe'


$Today = Get-Date -DisplayHint Date
$Today = ($Today).ToString().Substring(0,9)
$Today = ($Today).Replace("/", "-")

foreach($dataObject in $data) {

  $PrintServers += $dataObject.data.printservers.name
}


<#for($I=0; $I -lt $PrintServersTest.length; $I++) {
    
    Write-Host $PrintServersTest[$I]
    C:\Windows\System32\spool\tools\PrintBrm.exe -B -S \\$PrintServersTest[$I] -F $BackupTarget$PrintServersTest[$I]-$Today$Extension
} #>

$StartTime = (Get-Date).ToString()

Write-Host $StartTime
Write-Host ""

$PrintServersTest | ForEach-Object {

    Write-Host $_

    & $printbrm -B -S \\$_ -F $BackupTarget$_-$Today2$Extension

}

$EndTime = (Get-Date).ToString() 

Write-Host ""
Write-Host $EndTime
