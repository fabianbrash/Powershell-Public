



$Year = Get-Date -DisplayHint Date
$MonthT = Get-Date -DisplayHint Date
#$MonthYearT = ($MonthYearT).ToString().Substring(0,2)
$Year = ($Year).Year
$MonthT = ($MonthT).Month
#$MonthYearT = ($MonthYearT).Replace("/", "-")
Write-Host $MonthT$Year

$CLIPath = "C:\$MonthT$Year"


if(-not (Test-Path $CLIPath) )
            {
                New-Item -Path $CLIPath -type directory
                
            }

Write-Host $CLIPath
