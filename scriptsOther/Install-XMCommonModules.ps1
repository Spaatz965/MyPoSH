#requires -Version 5.1

function Install-XMCommonModules {
    <#
.SYNOPSIS
    Short function to install commonly needed / used modules for Office 365
    Administration.

.DESCRIPTION
    Short function to install commonly needed / used modules for Office 365
    Administration.

.EXAMPLE
    Install-XMCommonModules
    Installs modules missing from the system.

.NOTES
    Additional information about the function or script.
    File Name      : Install-XMCommonModules.ps1
    Author         : Mark Christman
    Requires       : PowerShell Version 5.1
    Version        : 1.0
    Date           : 11 February 2020

    TODO:
    Pre-Requisite Checking (Az has specific requirements for example)
    Conflict checking (Don't install multiple SharePoint PnP Modules at once)
    Provide ability to specify list of modules to install with a default list.
    Complete contextual help
#>

    [CmdletBinding()]
    param ()

    BEGIN {
        Write-Verbose "[$((get-date).TimeOfDay.ToString()) BEGIN   ] "
        Write-Verbose "[$((get-date).TimeOfDay.ToString()) BEGIN   ] Starting: $($MyInvocation.MyCommand)"
        Write-Verbose "[$((get-date).TimeOfDay.ToString()) BEGIN   ] Execution Metadata:"
        # TODO: Add Get-XMNEnvironmentMetaData helper function
        # $EnvironmentData = Get-XMNEnvironmentMetaData
        # Write-Verbose $EnvironmentData

        $Modules = @(
            "Az",
            #Install either AzureAD or AzureADPreview. Don't install both/
            #"AzureAD",
            "AzureADPreview",
            "CredentialManager",
            "Microsoft.Online.SharePoint.PowerShell",
            "Microsoft.PowerApps.Administration.PowerShell",
            "Microsoft.PowerApps.PowerShell",
            "MicrosoftTeams",
            "MSOnline",
            "Pester",
            #"SharePointPnPPowerShell2013",
            #"SharePointPnPPowerShell2016",
            #"SharePointPnPPowerShell2019",
            "SharePointPnPPowerShellOnline",
            "SkypeOnlineConnector"
        )

        $InstalledModules = Get-InstalledModule | select-object -ExpandProperty name

    } # BEGIN

    PROCESS {
        Write-Verbose "[$((get-date).TimeOfDay.ToString()) PROCESS ] "
        foreach ( $Module in $Modules ) {
            if ( -not ($Module -in $InstalledModules) ) {
                Install-Module -Name $Module
            }
        }

    } # PROCESS

    END {
        Write-Verbose "[$((get-date).TimeOfDay.ToString()) END     ] Ending: $($MyInvocation.Mycommand)"
        Write-Verbose "[$((get-date).TimeOfDay.ToString()) END     ] "
        Update-Help
    } # END

} # function Install-XMCommonModules

#region Function Test Use Cases (Uncomment To Test)

# Call Function with parameters
Install-XMCommonModules
# Call Function via PipeLine

# Call Function via PipeLine By Name

# Call Function with multiple objects in parameter

# Call Function test Error Logging


#endregion