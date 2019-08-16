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

        if($hostinfo.type -eq "Static") {$v4 = $hostinfo.address}
        else{$v6=$hostinfo.address; $v4=""}
        #$hostinfo.type

        [PSCustomObject]@{
            Name        = $server.Name
            $ip4          = $v4
            $ip6          = $v6

    }

  } 
 

 }

 $OutArray

}


function Enclosure {

$ValuesArray = @()

$ListofEncs = Get-HPOVEnclosure | Sort-Object Name

  $ValuesArray = foreach($enc in $ListofEncs) {

      foreach($bay in $enc.managerBays) {

          [PSCustomObject]@{

              Name                       =-join ($enc.Name,",", ""+$bay.managerType,$bay.bayNumber)
              Component                  = "Onboard Administrator"
              Installed                  =$bay.fwVersion
     }
  }

 }
 $ValuesArray | Out-File -FilePath C:\enc.log
 
}

 

GTServer


#Write-Host "---------------------------------------------------------------"

#Get-HPOVServer | Select-Object *
