Clear-Host


function GenAESPass {


    <#
    
    .SYNOPSIS
    Generates a AES-256 password from an AES-256 key

    .PARAMETER Key
    Path to our AES-256 key
    
    .PARAMETER PassFile
    The name and the path of our password file


    .EXAMPLE

    PS> GenAESPass -Key "C:\Creds\passkey.key" -PassFile "C:\Creds\encrpass.txt"
    
    #>
    

    param(

        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [String]
        $Key,
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [String]
        $PassFile
    )


    (Get-Credential).Password | ConvertFrom-SecureString -Key (Get-Content $Key) | Set-Content $PassFile
}

GenAESPass -Key "C:\passkey.key" -PassFile "C:\encrpass.txt"
