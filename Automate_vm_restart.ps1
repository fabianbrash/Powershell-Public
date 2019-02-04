<##############################
#Restart a list of VM's
##############################>


####Load a csv file with our VM's

Clear-Host

$CSVData = Import-Csv -Path "C:\file.csv"

$VMs = @($CSVData.VMs)

$VMs | ForEach-Object {


    try {
	
        Restart-VM -VM $_ -RunAsync -Confirm:$false
	}
	
	catch {
	    Write-Warning -Message "Failed to restart VM(s)"
	}
	
}
