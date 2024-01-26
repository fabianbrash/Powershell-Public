Clear-Host


## Connect-AzAccount -Tenant 'xxxx-xxxx-xxxx-xxxx' -SubscriptionId 'xxxx-xxxx-xxxx-xxxx'

## Connect-AzAccount -SubscriptionId 'xxxx-xxxx-xxxx-xxxx'

$cred = Get-Credential
$rg2 = "Lab-West"
$location2 = "westus"
$mandatoryTags = @{
    Owner="Fabian";
    Department="IT"
}


$commonParams = @{
    ResourceGroupName = $rg2
    Location = $location2
    #VirtualNetworkName = "vnet-a"
    #SubnetName = "frontendSubnet"
    SecurityType = "Standard"
    Size = "Standard_B4ms"
    #Image = "Win2019Datacenter"
    ImageName = "MicrosoftWindowsServer:WindowsServer:2022-datacenter-azure-edition:latest"
    Credential = $cred
    #SecurityGroupName = "wus-default-nsg"
    PublicIpSku = "Basic"
    PublicIpAddressName = "wus-dev-2-pip"
    OSDiskDeleteOption = "Delete"
}



New-AzVM `
-Name "wus-dev-2" `
@commonParams `
-Verbose `
-OpenPorts 3389,5985

# Update the VM with tags
$wusvm = Get-AzVM -Name "wus-dev-2" -ResourceGroupName $rg2

Update-AzTag -Tag $mandatoryTags -ResourceId $wusvm.Id -Operation Merge -Verbose
