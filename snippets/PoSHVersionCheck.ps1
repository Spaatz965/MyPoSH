<#
Snippet from Greg Bryniarski
#>


#region ######################################## Test-PowershellVersion ########################################



function Test-PowershellVersion {



    $version = $PSVersionTable.PSVersion



    if (($version.Major -eq 5 -and $version.Minor -lt 1) -or ($version.Major -gt 5)) {



        Write-Error "$(Get-Date) - Expecting Powershell version 5.1 or Greater - current version is: '$($version.Major).$($version.Minor)' - go to https://www.microsoft.com/en-us/download/details.aspx?id=54616 to update"

        exit 1

    }
    else {

        Write-Host "$(Get-Date) - Powershell Version: '$version' - which is nice"

    }

}

#endregion





#region ######################################## Test-AzureModuleVersion ########################################



function Test-AzureModuleVersion {

    [string] $AzureModuleName = 'Azure'



    $module = Get-Module -ListAvailable | Where-Object { $_.Name -eq $AzureModuleName }



    if (-not $? -or -not $module) {

        Write-Error "$(Get-Date) - Error - Could not get module: '$AzureModuleName'"

        exit 1

    }



    if ($module.Version.Major -lt 5 -and $module.Version.Minor -lt 1) {

        Write-Error "$(Get-Date) - Error - Expecting Azure Module version 5.1.0 or greater - current verision is $($module.Version.Major).$($module.Version.Minor).$($module.Version.Build) - Try - 'Update-Module -Name AzureRM' - it is OK to trust the repository"

        exit 1

    }
    else {

        Write-Host "$(Get-Date) - Module: $AzureModuleName Version: '$($module.Version)' - which is nice"

    }

}

#endregion <#
Snippet from Greg Bryniarski
#>


#region ######################################## Test-PowershellVersion ########################################

 

function Test-PowershellVersion {

 

    $version = $PSVersionTable.PSVersion

 

    if (($version.Major -eq 5 -and $version.Minor -lt 1) -or ($version.Major -gt 5)) {

 

        Write-Error "$(Get-Date) - Expecting Powershell version 5.1 or Greater - current version is: '$($version.Major).$($version.Minor)' - go to https://www.microsoft.com/en-us/download/details.aspx?id=54616 to update"

        exit 1

    }
    else {

        Write-Host "$(Get-Date) - Powershell Version: '$version' - which is nice"

    }

}

#endregion

 

 

#region ######################################## Test-AzureModuleVersion ########################################

 

function Test-AzureModuleVersion {

    [string] $AzureModuleName = 'Azure'

 

    $module = Get-Module -ListAvailable | Where-Object { $_.Name -eq $AzureModuleName }

 

    if (-not $? -or -not $module) {

        Write-Error "$(Get-Date) - Error - Could not get module: '$AzureModuleName'"

        exit 1

    }

 

    if ($module.Version.Major -lt 5 -and $module.Version.Minor -lt 1) {

        Write-Error "$(Get-Date) - Error - Expecting Azure Module version 5.1.0 or greater - current verision is $($module.Version.Major).$($module.Version.Minor).$($module.Version.Build) - Try - 'Update-Module -Name AzureRM' - it is OK to trust the repository"

        exit 1

    }
    else {

        Write-Host "$(Get-Date) - Module: $AzureModuleName Version: '$($module.Version)' - which is nice"

    }

}

#endregion<#
Snippet from Greg Bryniarski
#>


#region ######################################## Test-PowershellVersion ########################################

 

function Test-PowershellVersion {

 

    $version = $PSVersionTable.PSVersion

 

    if (($version.Major -eq 5 -and $version.Minor -lt 1) -or ($version.Major -gt 5)) {

 

        Write-Error "$(Get-Date) - Expecting Powershell version 5.1 or Greater - current version is: '$($version.Major).$($version.Minor)' - go to https://www.microsoft.com/en-us/download/details.aspx?id=54616 to update"

        exit 1

    }
    else {

        Write-Host "$(Get-Date) - Powershell Version: '$version' - which is nice"

    }

}

#endregion

 

 

#region ######################################## Test-AzureModuleVersion ########################################

 

function Test-AzureModuleVersion {

    [string] $AzureModuleName = 'Azure'

 

    $module = Get-Module -ListAvailable | Where-Object { $_.Name -eq $AzureModuleName }

 

    if (-not $? -or -not $module) {

        Write-Error "$(Get-Date) - Error - Could not get module: '$AzureModuleName'"

        exit 1

    }

 

    if ($module.Version.Major -lt 5 -and $module.Version.Minor -lt 1) {

        Write-Error "$(Get-Date) - Error - Expecting Azure Module version 5.1.0 or greater - current verision is $($module.Version.Major).$($module.Version.Minor).$($module.Version.Build) - Try - 'Update-Module -Name AzureRM' - it is OK to trust the repository"

        exit 1

    }
    else {

        Write-Host "$(Get-Date) - Module: $AzureModuleName Version: '$($module.Version)' - which is nice"

    }

}

#endregion