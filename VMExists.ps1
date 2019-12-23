Clear-Host



$VMs=@()
$VMList = Get-Content -Path C:\vms.txt
$retVMs=@()
$vc = "vc"

Connect-VIServer -Server $vc


$VMObj = Get-VM
function VMExists {


    param(

        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [String]$VM,
        [Parameter(Mandatory=$false)]
        [Switch]$ToolsRunning
    )


    if($ToolsRunning.IsPresent){
        $ToolsStatus = (Get-VM $VM -ErrorAction SilentlyContinue).ExtensionData.Guest.ToolsStatus
        if($VMObj.Name -eq $VM -and $ToolsStatus -ne 'toolsNotRunning') {

            return $VM
            
        }
    
    }

    elseif(-not($ToolsRunning)) {
        #Write-Information "Not checking for tools" -InformationAction Continue
        if($VMObj.Name -eq $VM){

            return $VM
        }
    }
    
}


ForEach($obj in $VMList) {

    $retVMs+=VMExists -VM $obj
}

$retVMs | Out-GridView

#Get-VM -Name "tst5" | Select-Object * | Select-Object -Property @{n='ToolsStatus'; e={$_.ExtensionData.Guest.ToolsStatus}}
 

