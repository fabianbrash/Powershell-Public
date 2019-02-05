

<#########
# Very Simple way to store creds securely; this will be my preferred method and I will deprecate 
# The other way I do this
#>

Clear-Host


$Credential = Get-Credential

$Credential | Export-CliXml -Path C:\Users\user\Desktop\la.Cred


####Import Creds

#$Creds = Import-Clixml -Path C:\Users\user\Desktop\al.Cred

####And then you could do something like this

##Connect-VIServer -Server $vc -Credential $Creds
