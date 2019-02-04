<# Digitally sign a powershell script, this assumes you only have 1 certificate in your personal store, if you have more than 1 then
   the script will have to be modified
 #>

function CodeSign($Myfile) {

    $cert = Get-ChildItem -Path Cert:\CurrentUser\My -CodeSigningCert
    Set-AuthenticodeSignature $Myfile -cert $cert

}

$TheFile12 = "path_to_file_to_sign/thefile.ps1"

CodeSign $TheFile12
