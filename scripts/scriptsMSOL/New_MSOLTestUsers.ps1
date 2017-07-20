$NumberOfAccounts = 30
$DisplayNameBase  = "TestUser"
$DomainName       = "@example.onmicrosoft.com"
$Password         = "P@ssw0rd!"


For ($I=1 ; $I -le $NumberOfAccounts ; $I++) {
    $DisplayName = $DisplayNameBase + $I.ToString("00")

    $Parameters = @{
		#'AlternateEmailAddresses'          = '<String[]>'
		#'AlternateMobilePhones'            = '<String[]>'
		#'BlockCredential'                  = $false
		#'City'                             = '<String>'
		#'Country'                          = '<String>'
		#'Department'                       = '<String>'
		'DisplayName'                      = $DisplayName
		#'Fax'                              = '<String>'
		#'FirstName'                        = '<String>'
		'ForceChangePassword'              = $false
		#'ImmutableId'                      = '<String>'
		#'LastName'                         = '<String>'
		#'LicenseAssignment'                = '<String[]>'
		#'LicenseOptions'                   = '<LicenseOption[]>'
		#'MobilePhone'                      = '<String>'
		#'Office'                           = '<String>'
		'Password'                         = $Password
		'PasswordNeverExpires'             = $true
		#'PhoneNumber'                      = '<String>'
		#'PostalCode'                       = '<String>'
		#'PreferredDataLocation'            = '<String>'
		#'PreferredLanguage'                = '<String>'
		#'State'                            = '<String>'
		#'StreetAddress'                    = '<String>'
		'StrongPasswordRequired'           = $false
		#'TenantId'                         = '<Guid>'
		#'Title'                            = '<String>'
		'UsageLocation'                    = 'US'
		'UserPrincipalName'                = $DisplayName + $DomainName
		#'LastPasswordChangeTimestamp'      = '<DateTime>'
		#'SoftDeletionTimestamp'            = '<DateTime>'
		#'StrongAuthenticationMethods'      = '<StrongAuthenticationMethod[]>'
		#'StrongAuthenticationRequirements' = '<StrongAuthenticationRequirement[]>'
		#'StsRefreshTokensValidFrom'        = '<DateTime>'
		#'UserType'                         = '<UserType>'
    }
    #$Output = New-Object -TypeName psobject -Property $Parameters
    #Write-Output $Output

    New-MsolUser @Parameters

}