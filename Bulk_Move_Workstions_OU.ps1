#Filename:            Bulk_Move_Workstations_OU.ps1
#Author:              Fabian Brash
#Date:                05-09-2017
#Modified:            05-10-2017
#Purpose:             Bulk move computers from SRC OU to DST OU                
                         
                         
<#
 ______   ______       __     ______    
/\  ___\ /\  == \     /\ \   /\  == \   
\ \  __\ \ \  __<    _\_\ \  \ \  __<   
 \ \_\    \ \_\ \_\ /\_____\  \ \_____\ 
  \/_/     \/_/ /_/ \/_____/   \/_____/ 
#>                                        


Clear-Host

Import-Module ActiveDirectory

$SRCOU = 'OU=Marketing,OU=ariWorkstations,DC=ari,DC=io'
$DSTOU = 'OU=IT,OU=ariWorkstations,DC=ari,DC=io'

##Export the OU before we mess with
Get-ADComputer -Filter * -SearchBase $SRCOU | Export-Csv C:\container.csv

#Get-ADComputer -Filter * -SearchBase $SRCOU | Format-List Name, distinguishedName
Get-ADComputer -Filter {Name -like 'cp500*' -or Name -like 'cpl500*'} -SearchBase $SRCOU | Move-ADObject -TargetPath $DSTOU

