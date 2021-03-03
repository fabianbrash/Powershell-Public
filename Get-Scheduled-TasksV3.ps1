##Note I am pretty sure this requires WinRM to work, so make sure it's configured in your environment

Clear-Host

$s = New-PSSession -ComputerName CompA,CompB,CompC

Invoke-Command -Session $s {

 $Data=@()
 
 $Tasks = Get-ScheduledTask | Where-Object {$_.TaskPath -like "\"} #Root path only
 
 foreach($taskName in $Tasks.TaskName) {
 
   $Data+= Get-ScheduledTaskInfo -TaskName $taskName | Select-Object -Property TaskName, LastRunTime, NextRunTime, NumberOfMissedRuns, LastTaskResult
 
 }
 
 $Data

} | Export-Csv -Path C:\tasks.csv -NotypeInformation -Append

# | Out-File -FilePath C:\tasks.log -Width 10000 -Append
