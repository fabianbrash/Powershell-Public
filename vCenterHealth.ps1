Clear-Host


<#
 Variable declarations
#>

#$RESTEndpoint = "vc_IP_OR_DNS"
$RESTEndpoints = @("tdctlvcsa01.alexander.io")


$cred = Get-Credential $null
#$cred = Import-Clixml -Path C:\Creds\la.Cred

$RESTUser = $cred.UserName
$cred.Password | ConvertFrom-SecureString #Required when using Get-Credential
$RESTPass = $cred.GetNetworkCredential().Password
$Output=@()


###Prevent our script from breaking because of a self-signed certificate and also apparently Powershell 5.x and below don't by default use TLS1.2
##I didn't have to do this with teh Simplivity API calls I made, but I think the reason was I imported the vCenter Cert into our trusted Root Store
##Plus I don't think the API required TLS1.2
##Note in PWSH 6.x and above you can just use the -SkipCertificateCheck on both Invoke-RestMethod and Invoke-WebRequest
##Invoke-RestMethod -Uri https://blahh.com -SkipCertificateCheck

add-Type -TypeDefinition @"
    using System;
    using System.Net;
    using System.Net.Security;
    using System.Security.Cryptography.X509Certificates;

    public class TrustAllCertsPolicy : ICertificatePolicy {
        public bool CheckValidationResult(
            ServicePoint srvPoint, X509Certificate certificate,
            WebRequest request, int certificateProblem) {
                return true;
            }
    }
"@
[System.Net.ServicePointManager]::CertificatePolicy = New-Object TrustAllCertsPolicy
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]'Tls11,Tls12'
#[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]'Ssl3,Tls,Tls11,Tls12'


##Build our URL's and headers
for($c=0; $c -lt $RESTEndpoints.Length; $c++) {

$BaseAuthURL = "https://" + $RESTEndpoints[$c] + "/rest/com/vmware/cis/"
$BaseURL = "https://" + $RESTEndpoints[$c] + "/rest/"
$vCenterSessionURL = $BaseAuthURL + "session"

$Header = @{"Authorization" = "Basic "+[System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($RESTUser+":"+$RESTPass))}
$Type = "application/json"

##Let's get our token

try{

    $vCenterSessionResponse = Invoke-RestMethod -Uri $vCenterSessionURL -Headers $Header -Method Post -ContentType $Type
}

catch{
    $_.Exception.ToString()
    $error[0] | Format-List -Force
}

$vCenterSessionHeader = @{'vmware-api-session-id' = $vCenterSessionResponse.value}

$ApplianceURL = $BaseURL+"appliance"
$ApplianceDBHealthURL = "/health/database-storage"
$ApplianceStorageHealth = "/health/storage"
$ApplianceServicesHealth = "/health/applmgmt"
$ApplianceBKURL = "/recovery/backup/job/details"

##Note the + sign only concatenates here, do not use with a commandlet
#$ApplianceURL+$ApplianceDBHealthURL

#$DBStorageEndpoint = "appliance/health/database-storage"



try {
    
    $DBStoragehealthJSON = Invoke-RestMethod -Method Get -Uri $ApplianceURL$ApplianceDBHealthURL -TimeoutSec 100 -Headers $vCenterSessionHeader -ContentType $Type
    $DBStoragehealth = $DBStoragehealthJSON.value

    $ApplianceStoragehealthJSON = Invoke-RestMethod -Method Get -Uri $ApplianceURL$ApplianceStorageHealth -TimeoutSec 100 -Headers $vCenterSessionHeader -ContentType $Type
    $ApplianceStoragehealth = $ApplianceStoragehealthJSON.value

    $ApplianceServiceHealthJSON = Invoke-RestMethod -Method Get -Uri $ApplianceURL$ApplianceServicesHealth -TimeoutSec 100 -Headers $vCenterSessionHeader -ContentType $Type
    $ApplianceServicehealth = $ApplianceServiceHealthJSON.value

    $ApplianceBKJSON = Invoke-RestMethod -Method Get -Uri $ApplianceURL$ApplianceBKURL -TimeoutSec 100 -Headers $vCenterSessionHeader -ContentType $Type
    $ApplianceBKHealth = $ApplianceBKJSON.value
}

catch{
    $_.Exception.ToString()
    $error[0] | Format-List -Force
}


#$ApplianceBKHealth.value | Format-List

#$Manual = $ApplianceBKHealth | Where-Object {$_.value.type -eq "MANUAL"}
$scheduled = $ApplianceBKHealth | Where-Object {$_.value.type -eq "SCHEDULED"}

#($Manual).count
#($scheduled).count

#$Manual.value.status | Select-Object -Last 1

$OutPut += [PSCustomObject]@{

    "vCenter"                           = $RESTEndpoints[$c].ToUpper()
    "Appliance DB storage Health"       = $DBStoragehealth.ToUpper()
    "Appliance Storage Health"          = $ApplianceStoragehealth.ToUpper()
    "Appliance Services Health"         = $ApplianceServiceHealth.ToUpper()
    #"Last Manual Backup Status"                = $Manual.value.status | Select-Object -Last 1
    "Last Scheduled backup status"      = $scheduled.value.status | Select-Object -Last 1
    
 }

} #End out for loop



<#
 Let's add some styling to our table
#>

$Style = @"

<link href="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css" rel=stylesheet>
<link href="https://fonts.googleapis.com/css?family=Roboto+Condensed&display=swap" rel=stylesheet> 

<style>
  body {font-family: 'Roboto Condensed', sans-serif; font-size:16px}

</style>
"@

$Pre = @"

<div class="container-fluid">
  <h2 align="center">vCenter Health Status</h2>
</div>

"@

$OutPut | ConvertTo-Html -Head $Style -PreContent $Pre -Title "vCenter Health" | `
ForEach-Object {$_ -replace '<table>', '<table class="table table-striped">'} | ForEach-Object {$_ -replace '<tr>', '<tr align="center">'} | `
Out-File -FilePath C:\Users\Fabian\Desktop\output.html


#$DBStoragehealth | Format-Table -AutoSize
