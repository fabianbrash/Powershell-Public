<#
 REF:https://communities.vmware.com/thread/573437
 REF:http://www.virtu-al.net/2009/07/08/powercli-host-hardware-one-liner/
#>

<### Code to implement

get-vmhost | Select name,

@{N="Host";E={($_ | Get-VMHostNetwork).Hostname}},

@{N=”Datacenter”;E={Get-Datacenter -VMHost $_}},

@{N=”Cluster”;E={($_ | get-cluster).Name}},

@{N=“Cpu Model“;E={($_| Get-View).Hardware.CpuPkg[0].Description}},

@{N=“Speed“;E={"" + [math]::round(($_| get-view).Hardware.CpuInfo.Hz / 1000000, 0)}},

@{N="HT Available";E={($_).HyperthreadingActive}},

@{N="HT Active";E={($_ | get-view).Config.HyperThread.Active}},

@{N=“# CPU“;E={($_| Get-View).Hardware.CpuInfo.NumCpuPackages}},

@{N="Cores per CPU";E={($_| Get-View).Hardware.CpuInfo.NumCpuCores /($_| Get-View).Hardware.CpuInfo.NumCpuPackages}},

@{N=“#Cores“;E={($_| Get-View).Hardware.CpuInfo.NumCpuCores}},

@{N='Vendor';E={($_| Get-View).Summary.Hardware.Vendor}},

@{N=“Model“;E={($_| Get-View).Hardware.SystemInfo.Vendor+ “ “ + ($_| Get-View).Hardware.SystemInfo.Model}},

@{N=“Memory GB“;E={“” + [math]::round(($_| get-view).Hardware.MemorySize / 1GB, 0) + “ GB“}},

@{N=“Type“;E={$_.Hardware.SystemInfo.Vendor+ “ “ + $_.Hardware.SystemInfo.Model}},

@{n="HostUUID";e={$_.ExtensionData.hardware.systeminfo.uuid}},

@{N=”NTP”;E={Get-VMHostNtpServer $_}},

@{N="Datastore";E={Get-Datastore -VM $_}},

@{N="LUN";E={$lun.CanonicalName}}| Export-csv C:\Users\gemela\Desktop\ClusterESXTECOPROD.csv –NoTypeInformation


#>


Clear-Host

try {
    Import-Module -Name VMware.VimAutomation.Core
	}
	
catch{

    Write-Error -Message "Could not load VMware.VimAutomation.Core module..."
	}

$vc = "vc"

Connect-VIServer -Server $vc  -Credential $vcCred


Get-Datacenter -Name "DC2" | Get-VMHost | Sort Name | Get-View | Select Name, @{N="Type";E={$_.Hardware.SystemInfo.Vendor+""+$_.Hardware.SystemInfo.Model}}, @{N="Processor Type";E={"Proc Type:"+$_.Hardware.CpuPkg[0].Description}} | ft -AutoSize


