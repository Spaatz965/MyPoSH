$UserCredential = Get-Credential

$SessionParameters = @{
    'ConfigurationName' = 'Microsoft.Exchange'
    'ConnectionUri'     = 'https://ps.compliance.protection.outlook.com/powershell-liveid/'
    'Credential'        = $UserCredential
    'Authentication'    = 'Basic'
    'AllowRedirection'  = $true
}
$Session = New-PSSession @SessionParameters

Import-PSSession $Session -DisableNameChecking

Remove-PSSession $Session