<#
 
.SYNOPSIS
    Personal PowerShell Profile Script.
 
.DESCRIPTION
    Profie sets contant global variables for personal use.

.EXAMPLE
    Get the current date in my preferred format

    get-date -uformat $dateFormat

.EXAMPLE
    Append Date to an output file for easy sorting

    Get-WMIObject -class win32_system | out-file ".\systeminfo$(get-date -uformat $dateFormatSort)
 
.NOTES
    Additional information about the function or script.
    File Name  : Microsoft.PowerShell_profile.ps1
    Author     : Mark Christman
    Requires   : PowerShell Version 2.0 and Active Directory Module
    Version    : 2.0
    Date       : 17 September 2016
#>

Set-Alias -Name sudo -Value Start-ElevatedPowerShell | out-null

$Parameters = @{
    'Name'        = "dateFormatSort"
    'Value'       = "%Y%m%d-%H%M"
    'Description' = "Date format to append to file names. Profile created"
    'Option'      = "Constant"
    'Scope'       = "Global"
} # $Parameters
Set-Variable @Parameters

$Parameters = @{
    'Name'        = "dateFormat"
    'Value'       = "%d %h %Y %T"
    'Description' = "Preferred Date/Time Format. Profile created"
    'Option'      = "Constant"
    'Scope'       = "Global"
} # $Parameters
Set-Variable @Parameters

<#
Commented out temporarily
$Parameters = @{
    'Name'        = "PSEmailServer"
    'Value'       = "mailer.example.com"
    'Description' = "Outgoing SMTP Email Server. Profile created"
    'Scope'       = "Global"
} # $Parameters
Set-Variable @Parameters
#>

$Parameters = @{
    'Name'        = "Doc"
    'Value'       = "$env:userprofile\documents"
    'Description' = "My Documents Library. Profile created"
    'Option'      = "Constant"
    'Scope'       = "Global"
} # $Parameters
Set-Variable @Parameters

$Parameters = @{
    'Name'        = "DL"
    'Value'       = "$env:userprofile\downloads"
    'Description' = "My Downloads Library. Profile created"
    'Option'      = "Constant"
    'Scope'       = "Global"
} # $Parameters
Set-Variable @Parameters

$Parameters = @{
    'Name'        = "Scripts"
    'Value'       = "$env:userprofile\onedrive\scripts"
    'Description' = "Prefered location for PowerShell Sripts. Profile created"
    'Option'      = "Constant"
    'Scope'       = "Global"
} # $Parameters
Set-Variable @Parameters

$Parameters = @{
    'Name'        = "PSProfile"
    'Value'       = "$env:userprofile\documents\WindowsPowerShell"
    'Description' = "Default location for PowerShell Profile. Profile created"
    'Option'      = "Constant"
    'Scope'       = "Global"
} # $Parameters
Set-Variable @Parameters

function prompt {"PS: $(get-date -uformat $dateFormat )> "}

set-location -path $Doc