<#
   Let's get some input from the command line, MUST be the first line in your script
#>
 Param(
    [Parameter(Mandatory=$True)]
    [string]$TheGroup,
    [strng]$FilePath <#Not Mandatory#>
    )

Clear-Host

$a = "<style>"
$a = $a + "BODY{font-family: Georgia; background-color:#eee; padding: 20px;}"
$a = $a + "TABLE{border-width: 1px;border-style: solid;border-color: black;border-collapse: collapse;}"
$a = $a + "TH{border-width: 1px;padding: 0px;border-style: solid;border-color: black;background-color:thistle}"
$a = $a + "TD{border-width: 1px;padding: 0px;border-style: solid;border-color: black;background-color:palegoldenrod}"
$a = $a + "</style>"

#$TheGroup = "Domain Admins"

Get-ADGroupMember $TheGroup | Get-ADUser -Property LastLogonDate | select name, distinguishedName, LastLogonDate | ft

##Let's export to csv

Get-ADGroupMember $TheGroup | Get-ADUser -Property LastLogonDate | select name, distinguishedName, LastLogonDate | Export-Csv C:\admins.csv


##Convert to Html

Get-ADGroupMember $TheGroup | Get-ADUser -Property LastLogonDate | select name, distinguishedName, LastLogonDate | ConvertTo-Html -head $a | Out-File C:\admins001.html

Invoke-Expression C:\admins001.html
