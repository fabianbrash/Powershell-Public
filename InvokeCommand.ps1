<#
  Note this will also work if you run it from an elevated prompt on the local machine

  Start-Process $exepath -ArgumentList $args -Wait
  
  REF:https://community.idera.com/database-tools/powershell/ask_the_experts/f/powershell_remoting-24/21789/invoke-command-with-run-as-administrator-on-remote-machines
#>



Clear-Host


$vms = Get-Content -Path C:\vms.txt

$vms | Out-GridView
$answer = Read-Host "Are these correct(Y/N)"
$answer.ToUpper()

if($answer -eq 'Y') {

    ForEach($VM in $vms) {
        
        Write-Host "Starting installation on $VM" -ForegroundColor Green
        Invoke-Command -Computer $VM -ScriptBlock {

            $args=@("/mp:IP_FQDN","SMSSITECODE=YYY")
            $exepath = 'C:\temp\stage\ccmsetup.exe'
        
        
            Start-Process -Verb RunAs $exepath -ArgumentList $args -Wait


    }

  }

}

elseif($answer -eq 'N'){
    
    Exit

}
