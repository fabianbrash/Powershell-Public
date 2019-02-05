Clear-Host


<#GLOBALS#>
$SourceLocation = 'source'
$DestinationLocation = 'destionation\'
$AllArgs = @($SourceLocation,$DestinationLocation,'/NP', '/MT:32', '/E', '/R:3', '/W:5', '/ZB', '/COPYALL', '/MIR', '/LOG+:C:\RobocopyLogs\LogsNightly.log')
$AllArgs_LOG_ONLY = @($SourceLocation,$DestinationLocation,'/NP', '/MT:32', '/E', '/R:3', '/W:5', '/ZB', '/COPYALL', '/MIR', '/L', '/LOG+:C:\RobocopyLogs\LogsNightly.log')
<#Testing#>

<#$SourceTest = 'C:\Users\test_user\Downloads\Test'$DestinationTest = 'C:\Users\test_user\Desktop\Test'#>

#$AllArgsTest = @($SourceTest,$DestinationTest,'/NP', '/MT:32', '/E', '/R:3', '/W:5', '/ZB', '/COPYALL', '/MIR','/LOG+:C:\RobocopyLogs\TestLog.log')

function StartCopy{

& 'robocopy.exe' $AllArgs

#& 'robocopy.exe' $AllArgs_LOG_ONLY

}

StartCopy
