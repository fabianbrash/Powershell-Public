#REF:https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_functions_advanced_parameters?view=powershell-6
#REF:https://powershell.org/forums/topic/understanding-switch-parameters/
#REF:https://blogs.msdn.microsoft.com/mediaandmicrocode/2009/04/10/microcode-powershell-scripting-trick-fun-with-parameter-binding-the-fake-parameter-set-trick/

Clear-Host


function Adv {

    <#
    
    .SYNOPSIS
    Uses advanced function techniques like ParameterSets, validation and switch

    .PARAMETER ComputerName
    Specifies computer name cannot be used in conjunction with $Username

    .PARAMETER UserName
    Specifies username cannot be used in conjunction with $ComputerName

    .PARAMETER Summary
    Specifies a switch if it's there is true if not it's false note it's mandatory if used with the user parameter set

    .EXAMPLE

    PS> Adv -ComputerName "Computer"

    PS> Adv -UserName "User1" -Summary
    
    #>
    
    ##Note the below does not set a default parameterset

    <#
     [CmdletBinding(DefaultParameterSetName="Computer")]
    #>
    param (
       [Parameter(Mandatory=$true,
       ParameterSetName="Computer")]
       [ValidateNotNullOrEmpty()]
       [String[]]
       $ComputerName,
       
       [Parameter(Mandatory=$true,
       ParameterSetName="User")]
       [ValidateNotNullOrEmpty()]
       [String[]]
       $UserName,

       [Parameter(Mandatory=$false, ParameterSetName="Computer")]
       [Parameter(Mandatory=$true, ParameterSetName="User")]
       [Switch]
       $Summary

    )


    if($ComputerName) {

        Write-Output $ComputerName
    }

    if($UserName) {

        Write-Output $UserName
    }
}

Adv -UserName "User1" -Summary
