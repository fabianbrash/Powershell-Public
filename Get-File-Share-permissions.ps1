#REF:https://www.lepide.com/how-to/get-an-ntfs-permissions-report-using-powershell.html
Clear-Host

$thePath_or_Share = "C:\temp"

#$thePath_or_Share = "\\theshare\folder"

$FolderPath = Get-ChildItem -Directory -Path $thePath_or_Share -Recurse -Force
$Output = @()
ForEach ($Folder in $FolderPath) {
    $Acl = Get-Acl -Path $Folder.FullName
    ForEach ($Access in $Acl.Access) {
$Properties = [ordered]@{'Folder Name'=$Folder.FullName;'Group/User'=$Access.IdentityReference;'Permissions'=$Access.FileSystemRights;'Inherited'=$Access.IsInherited}
$Output += New-Object -TypeName PSObject -Property $Properties            
}
}
$Output | Out-GridView
