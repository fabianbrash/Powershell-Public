#FileName:      FolderSize.ps1
#Author:        Fabian Brash
#Date:          11-16-2016
#Modified:      11-16-2016

<# "{0:C0}" - Currency
   "{0:D2}" - Decimal
   "{0:P0}" - Percent
   "{0:X0}" - Hexadecimal
    


<#________   ________   ________      
|\   __  \ |\   __  \ |\   ____\     
\ \  \|\  \\ \  \|\  \\ \  \___|_    
 \ \   _  _\\ \   ____\\ \_____  \   
  \ \  \\  \|\ \  \___| \|____|\  \  
   \ \__\\ _\ \ \__\      ____\_\  \ 
    \|__|\|__| \|__|     |\_________\
                         \|_________|#>
                                     
                                     

Clear-Host

$Folder = 'C:\Source'
$num = 19245664285559

$colItems = (Get-ChildItem $Folder -Recurse | Measure-Object -Property Length -Sum)
"{0:N3}" -f ($colItems.sum / 1MB) + " MB"

Write-Host "`n"
"{0:C2}" -f $num
$num
Write-Host "`n"