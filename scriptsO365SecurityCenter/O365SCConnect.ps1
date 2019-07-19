$UserCredential = Get-Credential

$SessionProperties = @{
    'ConfigurationName' = "Microsoft.Exchange"
    'ConnectionUri'     = "https://ps.compliance.protection.outlook.com/powershell-liveid/"
    'Credential'        = $UserCredential
    'Authentication'    = "Basic"
    'AllowRedirection'  = $true
}
$Session = New-PSSession @SessionProperties

Import-PSSession $Session -DisableNameChecking