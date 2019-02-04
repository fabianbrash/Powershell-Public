


Clear-Host

$PSVersionTable

Write-Host "-------------------------------------------"

Write-Host "--------------------------------------------"

Write-Host "HERE-STRING EXAMPLES"

Write-Host "-------------------------------------------"

$here = @"
This is a test of "here-string" for us to test out
and you can see it spans multiple lines
"@

$here


$html = @"
<html><head><title>Here-String</title></head>
<body><p>This is a paragraph using here-strings in powershell</p>
</body>
</html>
"@

$html
#$html | ConvertTo-Html | Out-File -FilePath C:\test.html

$html | Out-File -FilePath C:\test.html
