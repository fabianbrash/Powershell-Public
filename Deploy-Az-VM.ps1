
<##
 Deploy a VM in Azure
 This assumes that you have created the necessary resources
 REF://https://github.com/fabianbrash/Recipes/blob/stable/AZURE
 #>


Clear-Host

$cred = Get-Credential

New-AzVm `
    -ResourceGroupName "Lab" `
    -Name "PBCJMPH01" `
    -Location "EastUS" `
    -VirtualNetworkName "LabNetwork" `
    -SubnetName "Jumphosts" `
    -SecurityGroupName "jumphostsRDP" `
    -PublicIpAddressName "jumphost" `
    -ImageName "MicrosoftWindowsServer:WindowsServer:2019-Datacenter:latest" `
    -Credential $cred
    #-AsJob


