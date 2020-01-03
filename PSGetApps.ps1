Clear-Host


$KEY64APP32 = "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*"
$KEY64APP64 = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*"
$KEY32 = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*"

$Header1 = "DisplayName"
$Header2 = "Publisher"
$Header3 = "DisplayVersion"
$Header4 = "InstallDate"
$Output=@()
$hostSystem = $env:COMPUTERNAME


function Get-Apps {


    <#
    
    .SYNOPSIS
    Find installed apps on a machine, note I'm lazy it's just as easy to detect the architecture by looking for the presence of the
	Program Files(x86) folder, this folder only exists on 64-bit systems for the installation of 32-bit apps
	In my testing it seems updates are included on Server 2008, and 2012 machines but not on Server 2016

    .PARAMETER OSArch
    Specefies OS architecture
	
	.PARAMETER FileLocation
	Specefies where to save the output file

    .EXAMPLE

    PS> Get-Apps -FileLocation C:\data -OSArch 32
	
	PS> Get-Apps -FileLocation C:\data -OSArch 64
    
    #>

    param (
	    [Parameter(Mandatory=$true)]
		[ValidateNotNullOrEmpty()]
		[ValidateSet(32,64)]
		[int]$OSArch,
		[Parameter(Mandatory=$true)]
		[ValidateNotNullOrEmpty()]
		[String]$FileLocation
	)
    
	if($OSArch -eq 64) {
		$Values = Get-ItemProperty $KEY64APP64 | Select-Object -Property $Header1, $Header2, $Header3, $Header4 | Where-Object {$_.DisplayName -notlike 'Security Update*'}

		    if($Values -ne $null){
                 $OutPut+=$Values
			}


		$Values2 = Get-ItemProperty $KEY64APP32 | Select-Object -Property $Header1, $Header2, $Header3, $Header4 | Where-Object {$_.DisplayName -notlike 'Security Update*'}
            if($Values2 -ne $null){
				$OutPut+=$Values2
			}
	        	

		#$OutPut | Out-File -FilePath C:\Output\testoutput.txt
		$Output | Export-Csv -Path $FileLocation -NoTypeInformation
	}
	
	elseif($OSArch -eq 32) {
	
	    $Output+=Get-ItemProperty $KEY32 | Select-Object -Property $Header1, $Header2, $Header3, $Header4 | Where-Object {$_.DisplayName -notlike 'Security Update*'}
	}
	
	else {
	    Write-Output "No architecture entered"
	}
	
	
}


Get-Apps -FileLocation "C:\Output\$hostSystem-InstalledApps.csv" -OSArch 64
