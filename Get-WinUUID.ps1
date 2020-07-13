Clear-Host


<#
 Get machine UUID, this should be unique across machines, I will assume if these are unique then a sysprep was done on the machine
 I need to confirm that though

 #>


#Get-WmiObject Win32_ComputerSystemProduct | Select-Object * | Format-List

Get-WmiObject Win32_ComputerSystemProduct | Select-Object -Property PSComputerName, UUID
