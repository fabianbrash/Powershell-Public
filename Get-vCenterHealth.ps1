Clear-Host


<#
 Variable declarations
#>

#$RESTEndpoints = "vc1"
$RESTEndpoints = @("vc1", "vc2", "vc3")
#$RESTEndpoints = @("vc1", "vc2")

#$cred = Get-Credential $null

<# One way if getting encrypted creds the issue with this is only the user who created the .cred file can decrypt the password

#>


#$cred = Import-Clixml -Path C:\la.Cred

#$RESTUser = $cred.UserName
#$cred.Password | ConvertFrom-SecureString #Required when using Get-Credential

#$RESTPass = $cred.GetNetworkCredential().Password

<#################################################################################################################################>


$Output=@()
$smtpServer = "smtpserver"
$To = @("Me <me@me.com>", "You <You@you.com>", "tree <tree@tree.com>")
$CurDate = Get-Date -DisplayHint Date
$TheUser = "Administrator@vsphere.local"
$ThePasswordFile = "D:\Creds\api-pass.txt"
$KeyFile = "D:\Keys\api-user.key"

<# Let's Decrypt our password #>
$password = Get-Content $ThePasswordFile | ConvertTo-SecureString -Key (Get-Content $KeyFile)
$creds = New-Object System.Management.Automation.PSCredential($TheUser,$password)

$RESTUser = $TheUser
$Ptr = [System.Runtime.InteropServices.Marshal]::SecureStringToCoTaskMemUnicode($password)
$result = [System.Runtime.InteropServices.Marshal]::PtrToStringUni($Ptr) 
[System.Runtime.InteropServices.Marshal]::ZeroFreeCoTaskMemUnicode($Ptr)



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

$Header = @{"Authorization" = "Basic "+[System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($RESTUser+":"+$result))}
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
$ApplianceBKStatus = "/recovery/backup/job/details"

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

    $ApplianceBKStatusJSON = Invoke-RestMethod -Method Get -Uri $ApplianceURL$ApplianceBKStatus -TimeoutSec 100 -Headers $vCenterSessionHeader -ContentType $Type
    $ApplianceBKStatusValue = $ApplianceBKStatusJSON.value
}

catch{
    $_.Exception.ToString()
    $error[0] | Format-List -Force
}


#$ApplianceBKStatusValue | Format-List

#$ApplianceBKStatusValue.value | Format-List

$schValue = $ApplianceBKStatusValue | Where-Object {$_.value.type -eq "SCHEDULED"}

$RESTEndpoints[$c]+ " " +($schValue).count

$OutPut += [PSCustomObject]@{

    "vCenter"                           = $RESTEndpoints[$c].ToUpper()
    "Appliance DB storage Health"       = $DBStoragehealth.ToUpper()
    "Appliance Storage Health"          = $ApplianceStoragehealth.ToUpper()
    "Appliance Services Health"         = $ApplianceServiceHealth.ToUpper()
    "Last scheduled backup status"      = $schValue.value.status | Select-Object -Last 1
    
 }

} #End our for loop



<#
 Let's add some styling to our table
#>

$Style = @"

<link href="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css" rel=stylesheet>
<link href="https://fonts.googleapis.com/css?family=Roboto+Condensed&display=swap" rel=stylesheet> 

<style>
  body {font-family: 'Roboto Condensed', sans-serif; font-size:14px}

</style>
"@

$Pre = @"

<div class="container-fluid">
  <h2 align="center">vCenter Health Status</h2>
</div>

"@

$Post = @"
<div class="container-fluid">
  <p align="left">Last Updated @ $CurDate</p>
</div>

"@

$OutPut | ConvertTo-Html -Head $Style -PreContent $Pre -Title "vCenter Health" -PostContent $Post | `
ForEach-Object {$_ -replace '<table>', '<table class="table table-striped">'} | ForEach-Object {$_ -replace '<tr>', '<tr align="center">'} | `
Out-File -FilePath C:\output.html

Start-Sleep -Seconds 7
##Now let's email our file

$sMail = @{

    To = $To
    Subject = "vCenter(s) Health Report"
    SmtpServer = $smtpServer
    From = "Me <Me@me.com>"
    Body = "vCenter(s) Health report"
    Attachments = "C:\output.html"
}

Send-MailMessage @sMail


#$DBStoragehealth | Format-Table -AutoSize
