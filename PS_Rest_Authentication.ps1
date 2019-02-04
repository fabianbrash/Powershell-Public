

<######
Delete this key and create a new one if we don't have this
{0} -f - Used to format output
Personal Access Token:

#>


Clear-Host


$URL = 'https://api.github.com'
$endpoint = '/user'

$Body = @{

    location = "Richmond, VA";
    blog = "http://blog.fabianbrash.com";
} | ConvertTo-Json

$Token = 'fabianbrash:xxxxxxxxxxxxxxxxx'
$Base64Token = [System.Convert]::ToBase64String([char[]]$Token)

$Headers = @{
   Authorization = 'Basic {0}' -f $Base64Token;
   #Authorization = 'Basic ' +$Base64Token; ***This also works
   };


##Let's update some data ConvertTo-Json is required
Invoke-RestMethod -Headers $Headers -Method Patch -Uri $URL$endpoint -Body $Body

###Let's read some data ConvertTo-Json is not required
$ReturnBody = Invoke-RestMethod -Uri $URL$endpoint -Method Get -Headers $Headers

Write-Host "Name is:"$ReturnBody.name
Write-Host "I work for:"$ReturnBody.company
