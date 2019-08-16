Clear-Host


try {

Import-Module -Name HPOneView.410 

}

catch {

Write-Error -Message "Unable to load HPOneView.410"

}

$oneview = "PVCLHPONE01.itbu.ad.enterprise.com"

#Connect-HPOVMgmt -Hostname $oneview

function GTServer {

$OutArray=@()

$ip4 = "IPV4"
$ip6 = "IPv6"

$servers=Get-HPOVServer

#$mgmtinfo = $data.mpHostInfo

#$mgmtinfo


$OutArray = foreach($server in $servers) {

    foreach($hostinfo in $server.mpHostInfo.mpIpAddresses) {

        if($hostinfo.type -eq "Static") {Write-Host "Found IPv4..."}
        $hostinfo.type

        [PSCustomObject]@{
            Name        = $server.Name
            $ip4          = $hostinfo.address
            #$ip6          = $hostinfo.address

    }

  } 
 

 }

 $OutArray

}


GTServer


#Write-Host "---------------------------------------------------------------"

#Get-HPOVServer | Select-Object *