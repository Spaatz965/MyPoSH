<<<<<<< HEAD
=======
<#

.SYNOPSIS
    Personal PowerShell Profile Script.

.DESCRIPTION
    Profie sets contant global variables for personal use.

.NOTES
    Additional information about the function or script.
    File Name  : Microsoft.PowerShell_profile.ps1
    Requires   :
    Version    : 2.1
    Date       : 8 July 2023
#>

Set-Alias -Name sudo -Value Start-ElevatedPowerShell | out-null

function gitgraph { git log --oneline --graph --decorate --all }

$Parameters = @{
    'Name'        = "logs"
    'Value'       = "$ENV:OneDrive\_PowerShellLogs"
    'Description' = "My PowerShell Logs. Profile created"
    'Option'      = "Constant"
    'Scope'       = "Global"
} # $Parameters
Set-Variable @Parameters

$Parameters = @{
    'Name'        = "Doc"
    'Value'       = "$ENV:OneDrive\documents"
    'Description' = "My Documents Library. Profile created"
    'Option'      = "Constant"
    'Scope'       = "Global"
} # $Parameters
Set-Variable @Parameters

$Parameters = @{
    'Name'        = "DL"
    'Value'       = "$ENV:OneDrive\downloads"
    'Description' = "My Downloads Library. Profile created"
    'Option'      = "Constant"
    'Scope'       = "Global"
} # $Parameters
Set-Variable @Parameters

$Parameters = @{
    'Name'        = "Scripts"
    'Value'       = "$ENV:Scripts"
    'Description' = "Prefered location for PowerShell Sripts. Profile created"
    'Option'      = "Constant"
    'Scope'       = "Global"
} # $Parameters
Set-Variable @Parameters

$Parameters = @{
    'Name'        = "PSProfile"
    'Value'       = "$ENV:OneDrive\Documents\PowerShell"
    'Description' = "Default location for PowerShell Profile. Profile created"
    'Option'      = "Constant"
    'Scope'       = "Global"
} # $Parameters
Set-Variable @Parameters

if ( $ENV:TERM -eq 'vscode') {
    $Console = 'VSCode'
}
else {
    $Console = 'Term'
}

if ( [Security.Principal.WindowsIdentity]::GetCurrent().Groups -contains 'S-1-5-32-544' ) {
    $TranscriptPath = Join-Path $Logs -ChildPath "$(Get-Date -Format FileDate)-$($ENV:COMPUTERNAME)-$Console-$($ENV:USERNAME)-ADMIN.txt"
}
else {
    $TranscriptPath = Join-Path $Logs -ChildPath "$(Get-Date -Format FileDate)-$($ENV:COMPUTERNAME)-$Console-$($ENV:USERNAME).txt"
}

function prompt { "PS: $(Get-Date -Format "ddd dd MMM yyyy HH:mm:ss" )> " }

$Parameters = @{
    'Append'                  = $true
    'Path'                    = $TranscriptPath
    'IncludeInvocationHeader' = $true
}
Start-Transcript @Parameters
>>>>>>> 148790e (Updates)

Write-Output $PSVersionTable