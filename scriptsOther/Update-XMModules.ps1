
function Update-XMModules {
    <#
.SYNOPSIS
    Short script to update all installed modules on a computer.

.DESCRIPTION
    Finds the installed modules on a computer, checks against the repository
    for modules of the name where the versions do not match, and updates.

.EXAMPLE
    Update-PSModules

.NOTES
    Additional information about the function or script.
    File Name      : Update-XMModules.ps1
    Author         : Mark Christman
    Requires       : PowerShell Version 5.1
    Version        : 1.0
    Date           : 08 July 2019

    Acknowledgements to Todd Klindt
    https://www.toddklindt.com/blog/Lists/Posts/Post.aspx?ID=832
#>

    [CmdletBinding()]
    param ( )

    BEGIN {
        Write-Verbose "[$((get-date).TimeOfDay.ToString()) BEGIN   ] "
        Write-Verbose "[$((get-date).TimeOfDay.ToString()) BEGIN   ] Starting: $($MyInvocation.MyCommand)"
        Write-Verbose "[$((get-date).TimeOfDay.ToString()) BEGIN   ] Execution Metadata:"

        # TODO: need to get self elevation in play


    } # BEGIN

    PROCESS {
        Write-Verbose "[$((get-date).TimeOfDay.ToString()) PROCESS ] "

        $InstalledModules = Get-InstalledModule

        $UpdateModules = foreach ( $InstalledModule in $InstalledModules ) {

            $FoundModule = Find-Module -Name $InstalledModule.name

            If ( $FoundModule.version -ne $InstalledModule.version ) { Write-Output $FoundModule.Name }
        }
        
        foreach ( $UpdateModule in $UpdateModules) {

            Update-Module -Name $UpdateModule -Force

        }

    } # PROCESS

    END {
        Write-Verbose "[$((get-date).TimeOfDay.ToString()) END     ] Ending: $($MyInvocation.Mycommand)"
        Write-Verbose "[$((get-date).TimeOfDay.ToString()) END     ] "
        Update-Help
    } # END

} # function Update-XMModules

#region Function Test Use Cases (Uncomment To Test)

# Call Function with parameters
Update-XMModules

# Call Function via PipeLine

# Call Function via PipeLine By Name

# Call Function with multiple objects in parameter

# Call Function test Error Logging


#endregion