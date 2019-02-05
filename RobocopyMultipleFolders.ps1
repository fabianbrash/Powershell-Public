Clear-Host

<#GLOBALS#>

$SourceTest = @('C:\Users\testUser\Desktop\Test','C:\Users\testUser\Pictures\TestPic')
$DestinationTest = @('C:\Users\testUser\Downloads\Test', 'C:\Users\testUser\Music\Test')

function SharesCopy
{

  for($i=0; $i -lt $SourceTest.Length; $i++)
   {

       #Write-Host $SourceTest[$i]$DestinationTest[$i]

       robocopy $SourceTest[$i] $DestinationTest[$i] /NP /MT:32 /E /R:3 /W:5 /ZB /COPYALL /MIR /LOG+:C:\RobocopyLogs\TestLog.log
   }
}

"`n"

SharesCopy

"`n"
