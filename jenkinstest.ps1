Clear-Host

$KEY_x86 = 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*'
$KEY_x64 = 'HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*'
$JAVA_8_111 = "8.0.1110.14"
$JAVA_8_121 = "8.0.1210.13"
$TheApp = "Java 8*"


Write-Host "================================================ 32-bit Keys====================================================="

Get-ItemProperty $KEY_x86 | Select-Object DisplayName, DisplayVersion | Format-Table -AutoSize
Write-Host "================================================================================================================="

if(Test-Path $KEY_x64)  {
    Write-Host "================================================ 64-bit Keys====================================================="
    Get-ItemProperty $KEY_x64 | Select-Object DisplayName, DisplayVersion | Format-Table -AutoSize
    Write-Host "================================================================================================================="
}

Write-Host ""


if(Get-ItemProperty $KEY_x86 | Where-Object {$_.DisplayName -like $TheApp -and $_.DisplayVersion -eq $JAVA_8_121}) {

    Write-Host "Let's search the 32-bit keys for our App, one moment please..."

    Write-Host "Java 8 update 121 is installed, you have the latest version of Java..."
    Exit
}

else {
    Write-Host "Current version of Java is not installed or not in the 32-bit Key..."
    Exit
    }



if(Get-ItemProperty $KEY_x64 | Where-Object {$_.DisplayName -like $TheApp -and $_.DisplayVersion -eq $JAVA_8_121}) {

     Write-Host "Let's search the 64-bit keys for our App, one moment please..."

     Write-Host "Java 8 update 121 is installed, you have the latest version of Java..."
}

else {
    Write-Host "Current version of Java is not installed or not in the 64-bit Key..."
    }
