Clear-Host


$Path = "C:\PowerCLI\"

$Directory = Get-Acl -Path $Path

ForEach($Dir in $Directory.Access) {

    
    $DirPermissions = [PSCustomObject]@{


      Path                     =$Path
      Owner                    =$Directory.Owner
      Group                    =$Dir.IdentityReference
      AccessType               =$Dir.AccessControlType
      Rights                   =$Dir.FileSystemRights


    }

    $DirPermissions | ft -AutoSize
}


###Non-Shorthand way of creating a custom object
##Note this way does not output the fields in the order we want them 


<#ForEach($Dir in $Directory.Access) {

    
    $DirPermissions = New-Object -TypeName PSObject -Property  @{


    'Path'                     =$Path
    'Owner'                    =$Directory.Owner
    'Group'                    =$Dir.IdentityReference
    'AccessType'               =$Dir.AccessControlType
    'Rights'                   =$Dir.FileSystemRights


    }

    $DirPermissions | ft -AutoSize

}#>
