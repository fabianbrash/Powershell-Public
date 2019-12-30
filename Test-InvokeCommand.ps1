<#

  Must be run from an elevated prompt??

#>


Clear-Host


Invoke-Command -Computer server1 -ScriptBlock {

    $args=@("/mp:IP_OR_FQDN","SMSSITECODE=YYY")
    $exepath = 'C:\temp\stage\ccmsetup.exe'


    Start-Process $exepath -ArgumentList $args -Wait


}
