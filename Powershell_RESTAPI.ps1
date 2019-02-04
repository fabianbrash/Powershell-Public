

Clear-Host


$data = Invoke-RestMethod -Method Get -Uri 'https://www.reddit.com/.json'

#$data.data.children[0].data | Export-Csv C:\redditHomePage.csv


Write-Host "The top story on reddit at this moment us:"$data.data.children[0].data.title
Write-Host "Written by user:"$data.data.children[0].data.author
Write-Host "And it has been upped:"$data.data.children[0].data.ups



<#Let's loop through the first 3 stories on reddit's homepage#>


Write-Host "Top 3 stories on Reddit right now"
Write-Host "=================================="

for($i=0; $i -lt 3; $i++) {
   
   
   Write-Host "Number" ($i+1) "is:"$data.data.children[$i].data.title
   Write-Host "Written by user:"$data.data.children[$i].data.author
   Write-Host "And it has been upped:"$data.data.children[$i].data.ups
}
