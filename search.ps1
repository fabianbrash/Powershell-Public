<#
 REF:https://devblogs.microsoft.com/scripting/use-select-string-cmdlet-in-powershell-to-view-contents-of-log-file/
 REF:https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_regular_expressions?view=powershell-6
 #>
 
Clear-Host


$text = "The quick brown fox"
$found=@()

$computers = @("Computer1", "Computer2")

$computersGC = Get-Content -Path /home/user/Documents/computers2.txt

$computersObj = Get-Content -Path /home/user/Documents/computers.txt -TotalCount 1

Select-String -InputObject $text -Pattern "brown"



foreach($computer in $computersGC){

    $found+=Select-String -Path /home/user/Documents/computers.txt -Pattern $computer | Select-Object Line | Format-Table -AutoSize
    
}

$computersObj | Out-File -FilePath /home/fabian/Documents/found.txt -Append
$found | Out-File -FilePath /home/fabian/Documents/found.txt -Append
#$found.Matches

#$NumOccurences = $found.Matches.Length

#Write-Output "We found $NumOccurences matches"
