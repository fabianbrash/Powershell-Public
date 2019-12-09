<# REF:https://www.altaro.com/msp-dojo/encrypt-password-powershell/
#>

Clear-Host


function GenAES {


    <#
    
    .SYNOPSIS
    Generates a AES-256 key

    .PARAMETER File
    The output file path and name

    .EXAMPLE

    PS> GenAES -File "C:\passkey.txt"
    
    #>
    
    param (

        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [String]$File
        
    )
    

    $Key = New-Object Byte[] 32
    [Security.Cryptography.RNGCryptoServiceProvider]::Create().GetBytes($Key)
    $Key | Out-File $File
}


GenAES -File "C:\Creds\passkey.key"
