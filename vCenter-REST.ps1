Clear-Host


$RESTEndpoint = "vc_IP_OR_DNS"

$cred = Get-Credential $null

$RESTUser = $cred.UserName
$cred.Password | ConvertFrom-SecureString
$RESTPass = $cred.GetNetworkCredential().Password


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

$BaseAuthURL = "https://" + $RESTEndpoint + "/rest/com/vmware/cis/"
$BaseURL = "https://" + $RESTEndpoint + "/rest/vcenter/"
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

$VMListURL = $BaseURL+"vm"

try {

    $VMListJSON = Invoke-RestMethod -Method Get -Uri $VMListURL -TimeoutSec 100 -Headers $vCenterSessionHeader -ContentType $Type
    $VMList = $VMListJSON.value
}

catch{
    $_.Exception.ToString()
    $error[0] | Format-List -Force
}

$VMList | Format-Table -AutoSize
