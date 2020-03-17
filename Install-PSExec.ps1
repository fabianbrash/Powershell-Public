Clear-Host

<#Clear the error logs as we are going to output the current errors to a file #>
$Error.Clear()

<#First we need to copy our file to the target machine or it can be on a share if the target systems
 Can hit it
 #>



Function New-Log {


    param(
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [String]$msg
    )

    $msg | Out-File -FilePath C:\Output\log-psexec.log -Append -Width 10000
}


<#Now let's install powershell 7.0 #>

$endpoints = Get-Content -Path C:\Output\endpoints.txt

ForEach($endpoint in $endpoints){
    
    New-Log -msg "Copying file to $endpoint"
    $xResult = xcopy /s /i /e /q /y D:\pwsh7 \\$endpoint\d$
    New-Log -msg $xResult
    New-Log -msg "Starting powershell 7 install on $endpoint"

    <#Odd if I use -u & -p I can get an error regarding incorrect username and password...#>
    PsExec.exe -nobanner \\$endpoint -s -i msiexec.exe /I "D:\PowerShell-7.0.0-win-x64.msi" /quiet /norestart /L*v D:\pwsh7-install.log >> C:\Output\log-psexec.log 2>&1
    #New-Log -msg $PSResult
}

$Error | Out-file -LiteralPath C:\Output\psexec-Errors.log -Append

#TODO: Improve logging
