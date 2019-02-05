#####FileName:     iis_dotnet_config.ps1
#####Initial Date: 10-19-2018



####Array to hold our Windows Features


Clear-Host


$Features = @("Web-Server", "Web-Common-Http", "Web-Default-Doc", "Web-Dir-Browsing", "Web-Http-Errors", "Web-Static-Content",
"Web-Http-Redirect", "Web-Health", "Web-Http-Logging", "Web-Performance", "Web-Stat-Compression", "Web-Dyn-Compression", "Web-Security",
"Web-Filtering", "Web-Basic-Auth", "Web-Client-Auth", "Web-Digest-Auth", "Web-Cert-Auth", "Web-IP-Security", "Web-Url-Auth",
"Web-Windows-Auth", "Web-App-Dev", "Web-Net-Ext", "Web-Net-Ext45", "Web-AppInit", "Web-ASP", "Web-Asp-Net", "Web-Asp-Net45",
"Web-CGI", "Web-ISAPI-Ext", "Web-ISAPI-Filter", "Web-Mgmt-Tools", "Web-Mgmt-Console", "Web-Scripting-Tools", "Web-Mgmt-Service",
"WAS", "WAS-Process-Model", "WAS-NET-Environment")



<#
 This took a little over an hour to deploy
 #>

<#for($i=0; $i -lt $Features.length; $i++) {

    Install-WindowsFeature -Name $Features[$i]
}#>


<#
 This took about 40 minutes so you save a little time
 #>

 $Features | ForEach-Object {

     Install-WindowsFeature -Name $_
 }
