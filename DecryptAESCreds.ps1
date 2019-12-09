<# REF:https://www.altaro.com/msp-dojo/encrypt-password-powershell/ #>

Clear-Host

function DecryptPass {


    <#
    
    .SYNOPSIS
    Decrypt a password that was encrypted using an AES-256 key

    .PARAMETER ThePasswordFile
    Path to our password file
    
    .PARAMETER KeyFile
    The name and the path of our key file

    .PARAMETER TheUser
    The name of our user


    .EXAMPLE

    PS> DecryptPass -ThePasswordFile "C:\Creds\encrpass.txt" -KeyFile "C:\Creds\passkey.key" -TheUser "userA"
    
    #>

    param(
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [String]
        $ThePasswordFile,
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [String]
        $KeyFile,
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [String]
        $TheUser
    )

    $password = Get-Content $ThePasswordFile | ConvertTo-SecureString -Key (Get-Content $KeyFile)
    $creds = New-Object System.Management.Automation.PSCredential($TheUser,$password)

    <# Output our creds, obviously this is useless you would use this via -Credential $creds#>
    $creds
}

DecryptPass -ThePasswordFile "C:\Creds\encrpass.txt" -KeyFile "C:\Creds\passkey.key" -TheUser "Administrator@vphere.local"
