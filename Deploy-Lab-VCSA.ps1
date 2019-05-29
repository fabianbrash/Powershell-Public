Clear-Host


$JSONPath = "C:\embedded_vCSA_on_ESXi-67U1-test.json"
$MountedDVDPath = "Z:\vcsa-cli-installer\win32\vcsa-deploy.exe"
$Opt1 = "install"
$Opt2 = "--no-ssl-certificate-verification"
$Opt3 = "--accept-eula"
$Opt4 = "--acknowledge-ceip"
$Opt5 = "--precheck-only"



& $MountedDVDPath $Opt1 $Opt2 $Opt3 $Opt4 $Opt5 $JSONPath
