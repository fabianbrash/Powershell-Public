##FileName:      simplivity_api_backup.ps1
##Author:        Fabian Brash
##Date:          10-03-2017
##Last Modified: 10-03-2017
##Usage:         Make REST call to Simplivity for all backups




Clear-Host
##This assumes you have encrypted the password to a file and now we are reading the file and decrypting the password
##https://github.com/fabianbrash/PowerShell/raw/dev/GenerateEncryptedCreds.ps1

<# Password MUST BE RE-KEYED IF YOU MOVE TO ANOTHER MACHINE YOU CANNOT COPY THE PASSWORD FILE BETWEEEN MACHINES
KEYS ARE INVOLVED HERE.

#>

$simpliv_user = 'user@vsphere.local'
$encrypted = Get-Content C:\passfile.txt | ConvertTo-SecureString
$simpliv_password = (New-Object PSCredential "user",$encrypted).GetNetworkCredential().Password
$ovc = 'IP_ADDRESS'

$RemotePath = '\\server\path\'
$LocalPath = 'C:\'

# Allow the use of self signed certificates.
[System.Net.ServicePointManager]::ServerCertificateValidationCallback = { $True }


$BASE_URL = "https://" + $ovc + "/api/"
$base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f "simplivity","")))
$body = @{grant_type='password';username=$simpliv_user;password=$simpliv_password}

#Authenticate user and generate access token
$url = $BASE_URL+'oauth/token'
$header = @{Authorization=("Basic {0}" -f $base64AuthInfo)}
$response = Invoke-RestMethod -Uri $url -Headers $header -Body $body -Method Post
$access_token = $response.access_token;

##Add the access_token to the header.
$header = @{Authorization='Bearer '+$access_token}

##Issue a GET request: GET /backups.
##? is used for the first argument, nd then & after that to build your URL string 
$limit = '&limit=5000'
$OS_Cluster_ClusterA = '?omnistack_cluster_name=ClusterA'
$OS_Cluster_ClusterB = '?omnistack_cluster_name=ClusterB'
$OS_Cluster_ClusterC = '?omnistack_cluster_name=ClusterC'
##ISO-8601 form, based on Coordinated Universal Time (UTC)
##Time below should be 4 PM EST 2018-09-27T20%3A00%3A00Z
$Created_before = '&created_before=2018-09-27T20:00:00Z'

#$url = $BASE_URL+'backups'+$limit
$url = $BASE_URL+'backups'+$OS_Cluster_ClusterA+$Created_before+$limit
#$url = $BASE_URL+'backups'+$OS_Cluster_ClusterB+$Created_before+$limit
#$url = $BASE_URL+'backups'+$OS_Cluster_ClusterC+$Created_before+$limit
$backups = Invoke-RestMethod -Header $header -Uri $url -Method Get
##Issue a GET request: GET /backups.
$url = $BASE_URL+'backups'
$backups = Invoke-RestMethod -Header $header -Uri $url -Method Get

Clear-Host

##Place our backups in a variable so we can export it out(Not sure why this works though)
##backups are returns as backups{ [] }
$backups = Invoke-RestMethod -Header $header -Uri $url -Method Get

##Place our backups in a variable so we can export it out(Not sure why this works though)
##backups are returns as backups{ [] }
$headerStyle="<style>"
$headerStyle+="table{border-width:2px; border-style:solid; padding: 2px}"
$headerStyle+="td{border-width:2px; border-style:solid; padding:4px}"
$headerStyle+="</style>"


$thebackups = $backups.backups
$thebackups | Select-Object -Property virtual_machine_name,expiration_time,created_at,name,state | Export-Csv $RemotePath$Today$CSVFormat -NoTypeInformation
$thebackups | ConvertTo-Html -Property virtual_machine_name,expiration_time,created_at,name,state -Head $headerStyle | Out-File -FilePath $RemotePath$Today$HTMLFormat


<#$thebackups = $backups.backups
$thebackups | Select-Object -Property virtual_machine_name,expiration_time,created_at,name,state | Export-Csv C:\backup2.csv -NoTypeInformation
$thebackups | ConvertTo-Html -Property virtual_machine_name,expiration_time,created_at,name,state -Head $headerStyle | Out-File -FilePath C:\backups.html#>

<#$thebackups = $backups.backups
$thebackups | Export-Csv C:\backup.csv
$backups.backups.virtual_machine_name
$backups.backups.created_at
Write-Host "Current backup count is:" $backups.count#>


#$backup.backups.created_at $backup.backups.name $backup.backups.state
#$backups.virtual_machine_name, $backups.backups.created_at
