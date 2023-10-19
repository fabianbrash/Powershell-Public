Clear-Host

$url = "https://harbor.fbclouddemo.us"


Invoke-WebRequest -URI $url

Invoke-WebRequest -URI $url --SkipCertificateCheck  #Requires PWSH 6.x or 7.x

Invoke-WebRequest -URI https://harborh2o.alexanderbrash.net -SkipCertificateCheck | Select-Object -ExpandProperty RawContent

Invoke-WebRequest -URI https://harborh2o.alexanderbrash.net | Select-Object -ExpandProperty RawContent

Invoke-WebRequest -URI https://harborh2o.alexanderbrash.net -SkipCertificateCheck | Select-Object -ExpandProperty Headers

Invoke-WebRequest -URI https://harborh2o.alexanderbrash.net | Select-Object -ExpandProperty Headers
