


Clear-Host



 
 $CsvData = @(Import-Csv -Path 'D:\Data\PSData-Clean.csv')

 $SQLIP = @($CsvData.SQLIP.Split(','))
 $SQLName = @($CsvData.SQLName.Split(','))
 $SQLDesc = @($CsvData.SQLDescription.Split(','))

 $APPIP = @($CsvData.APPIP.Split(','))
 $APPName = @($CsvData.APPName.Split(','))
 $APPDesc = @($CsvData.APPDescription.Split(','))


 $WEBIP = @($CsvData.WEBIP.Split(','))
 $WEBName = @($CsvData.WEBName.Split(','))
 $WEBDesc = @($CsvData.WEBDescription.Split(','))

 $APIIP = @($CsvData.APIIP.Split(','))
 $APIName = @($CsvData.APIName.Split(','))
 $APIDesc = @($CsvData.APIDescription.Split(','))

 <#Write-Host $SQLIP
 Write-Host $APPIP
 Write-Host $WEBIP#>

 Write-Host "============================================================"
 Write-Host "Looping..."
 Write-Host "============================================================"

 function CsvLoop {

   <#$CsvData.SQLIP.Count | ForEach-Object {

      Write-Host $CsvData.SQLIP
      Write-Host "SQL size:"$CsvData.SQLIP.Count.Count
      
   
   }

    $CsvData.SQLName.Count | ForEach-Object {

     Write-Host $CsvData.SQLName 

   }

    $SQLDesc.Count | ForEach-Object {

     Write-Host $CsvData.SQLDescription
   
   }

   $CsvData.APPIP.Count | ForEach-Object {

   Write-Host $CsvData.APPIP
   Write-Host "APP size:"$CsvData.APPIP.Count.Count

  }
  
   $CsvData.APPName.Count | ForEach-Object {

   Write-Host $CsvData.APPName

  }

   $APPDesc.Count | ForEach-Object {

   Write-Host $APPDesc

  }

  $CsvData.WEBIP.Count | ForEach-Object {

   Write-Host $CsvData.WEBIP
   Write-Host "WEB size:"$CsvData.WEBIP.Count
  }

  $CsvData.WEBName.Count | ForEach-Object {

   Write-Host $CsvData.WEBName

  }

  $WEBDesc.Count | ForEach-Object {

   Write-Host $WEBDesc

  }#>

  #[int]$Mycount = $CsvData.SQLName.Count

  #Write-Host $Mycount
  #$Mycount.GetType()


  #Write-Host "Size of SQLIP:"$SQLIP.Count

  for($i=0; $i -lt $SQLIP.Count; $i++) {

    Write-Host $SQLIP[$i]
    Write-Host $SQLName[$i]
    Write-Host $SQLDesc[$i]
    Write-Host "SQL array size is:"$SQLIP.Count

  }
  

  for($j=0; $j -lt $APPName.Count; $j++) {

    Write-Host $APPIP[$j]
    Write-Host $APPName[$j]
    Write-Host $APPDesc[$j]
    Write-Host "APP array size is:"$APPName.Count

  }

  

  for($k=0; $k -lt $WEBName.Count; $k++) {

    Write-Host $WEBIP[$k]
    Write-Host $WEBName[$k]
    Write-Host $WEBDesc[$k]
    Write-Host "WEB array size is:"$WEBName.Count

  }

  
  for($q=0; $q -lt $APIName.Count; $q++) {

    Write-Host $APIIP[$q]
    Write-Host $APIName[$q]
    Write-Host $APIDesc[$q]
    Write-Host "API array size is:"$APIName.Count

  }

}


CsvLoop


Write-Host "=============================================================="
#$CsvData.GetType()

Write-Host "=============================================================="
#$CsvData.PSObject.Members
