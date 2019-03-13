##REF:https://serverfault.com/questions/276098/check-if-user-password-input-is-valid-in-powershell-script

Clear-Host

$DM = $env:USERDOMAIN
$DoUser = $env:UserName

$cred = Get-Credential -Credential $DM\$DoUser #Read credentials
 $username = $cred.username
 $password = $cred.GetNetworkCredential().password

 # Get current domain using logged-on user's credentials
 $CurrentDomain = "LDAP://" + ([ADSI]"").distinguishedName
 $domain = New-Object System.DirectoryServices.DirectoryEntry($CurrentDomain,$UserName,$Password)

if ($domain.name -eq $null)
{
 write-host "Authentication failed - please verify your username and password."
 exit #terminate the script.
}
else
{
 write-host "Successfully authenticated with domain $domain.name"
}
