Clear-Host



Invoke-Command -ComputerName TDCQWWSUS-1.fabianbrash.com -ScriptBlock {

  #$URI = "https://www.7-zip.org/a/7z1900-x64.msi"
  $URI = "https://www.7-zip.org/a/7z1900-x64.exe"

  <# Speed up downloads #>
  $ProgressPreference = 'SilentlyContinue'

  Invoke-WebRequest -URI $URI -OutFile C:\7z1900-x64.exe
  $args = @("/S")
  $exepath = "C:\7z1900-x64.exe"
  Start-Process -FilePath $exepath -ArgumentList $args -Wait -Verb RunAs -PassThru

}