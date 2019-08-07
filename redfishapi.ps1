Clear-Host



#iLO IP address and credentials to access the iLO
$ServersCSV = Import-Csv -Path C:\Output\ilonames.csv
$sessions=@()
$Output = @()
$cred = Import-Clixml -Path "C:\Creds\ilo.Cred"


Disable-HPERedfishCertificateAuthentication


$InArray = @($ServersCSV.iLOName.Split(',').Trim())

function Get-ComputerSystemExample11
{
   


    Write-Host 'Example 11: Retrieve information of computer system(s)'

    # connect session
    $session = Connect-HPERedfish -Address $Address -Credential $cred
    
    # retrieve list of computer systems
    $system = Get-HPERedfishDataRaw -odataid '/redfish/v1/Systems/1/' -Session $session
    #$system | Select-Object -Property BiosVersion, HostName, Manufacturer, Model, PowerState, @{n='ProcessorSummary';e={($_ | Select-Object -ExpandProperty ProcessorSummary)}}, SerialNumber | ft -AutoSize

    Write-Host "----------------------------------------------------------------------------------------------------------------------------------------------------------"

    $system | Select-Object -Property BiosVersion, HostName, Manufacturer, Model, PowerState,  ProcessorSummary, SerialNumber, MemorySummary | ft -AutoSize

    #$system | Select-Object *
    # print details of all computer systems
    <#foreach($sys in $systems.Members.'@odata.id')
    {
        $sysData = Get-HPERedfishDataRaw -odataid $sys -Session $session
        $sysData
    }#>

    

    # Disconnect session after use
    Disconnect-HPERedfish -Session $session
}


function Get-NetworkAdapter1
{
   


    Write-Host 'Example 12: Retrieving network adapter(s)...'
    #$Servers.Length

    # connect session

    for($c=0; $c -lt $InArray.Length; $c++) {

    $session = Connect-HPERedfish -Address $InArray[$c] -Credential $cred

    
    # retrieve list of computer systems
    $adapters = Get-HPERedfishDataRaw -odataid '/redfish/v1/Systems/1/NetworkAdapters/1/' -Session $session

    #$adapters

    #Write-Host "----------------------------------------------------------------------------------------------------------------------------------------------------------"

    $adapters | Select-Object -Property @{n='ServerName';e={($InArray[$c])}}, Name, StructuredName, @{n='IPv4Addresses';e={($_.PhysicalPorts.IPv4Addresses | Select-Object -ExpandProperty Address)}}, `
    @{n='MACs';e={($_.PhysicalPorts | Select-Object -ExpandProperty MacAddress)}} | Export-Csv -Path C:\Output\getnet-from-ILO.csv -NoTypeInformation -Append

    

    #Write-Host "----------------------------------------------------------------------------------------------------------------------------------------------------------"

    #$system | Select-Object *
    # print details of all computer systems
    <#foreach($sys in $systems.Members.'@odata.id')
    {
        $sysData = Get-HPERedfishDataRaw -odataid $sys -Session $session
        $sysData
    }#>

    

    
    } 

    #$Output | Export-Csv -Path C:\getnet-from-ILO.csv -NoTypeInformation
    
    # Disconnect session after use
    Disconnect-HPERedfish -Session $session

    
}


function Get-NetworkAdapter2
{
   


    Write-Host 'Example 12: Retrieving network adapter(s)...'

    # connect session

    $session = Connect-HPERedfish -Address $Address -Credential $cred

    
    # retrieve list of computer systems
    $adapters = Get-HPERedfishDataRaw -odataid '/redfish/v1/Systems/1/NetworkAdapters/' -Session $session

    #$adapters

    #Write-Host "----------------------------------------------------------------------------------------------------------------------------------------------------------"

    <#$adapters | Select-Object -Property @{n='ServerName';e={($Address)}}, Name, StructuredName, @{n='IPv4Addresses';e={($_.PhysicalPorts.IPv4Addresses | Select-Object -ExpandProperty Address)}}, `
    @{n='MACs';e={($_.PhysicalPorts | Select-Object -ExpandProperty MacAddress)}} | ft#>

    
    # print details of all computer systems
    foreach($sys in $adapters.Members.'@odata.id')
    {
        $sysData = Get-HPERedfishDataRaw -odataid $sys -Session $session
        $sysData | Select-Object -Property @{n='ServerName';e={($Address)}}, Name, StructuredName, @{n='IPv4Addresses';e={($_.PhysicalPorts.IPv4Addresses | Select-Object -ExpandProperty Address)}}, `
    @{n='MACs';e={($_.PhysicalPorts | Select-Object -ExpandProperty MacAddress)}} | ft
    }

    
    # Disconnect session after use
    Disconnect-HPERedfish -Session $session

    
  }   

#Get-ComputerSystemExample11
Get-NetworkAdapter2
