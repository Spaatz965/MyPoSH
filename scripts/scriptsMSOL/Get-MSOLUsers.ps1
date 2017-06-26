#requires -modules MSOnline

$Users = Get-MsolUser -All -EnabledFilter EnabledOnly

$TenantName = ((Get-MsolAccountSku)[0].accountskuid -split ":")[0]


foreach ( $user in $Users ) {

    $AccountType = "Cloud Only"
    If ($user.ImmutableId -ne "") {$AccountType="Synced"}

    $properties = @{ 
        'TenantName'                  = $TenantName
        'roleName'                    = $role.Name
        'AccountType'                 = $AccountType
        'AlternateEmailAddresses'     = $user.AlternateEmailAddresses -join ';'
        'BlockCredential'             = $user.BlockCredential
        'City'                        = $user.City
        'Country'                     = $user.Country
        'Department'                  = $user.Department
        'DisplayName'                 = $user.DisplayName
        'FirstName'                   = $user.FirstName
        'IsLicensed'                  = $user.IsLicensed
        'LastDirSyncTime'             = $user.LastDirSyncTime
        'LastName'                    = $user.LastName
        'LastPasswordChangeTimestamp' = $user.LastPasswordChangeTimestamp
        'LicenseReconciliationNeeded' = $user.LicenseReconciliationNeeded
        'Licenses'                    = $user.Licenses.accountskuid -join ';'
        'MobilePhone'                 = $user.MobilePhone
        'ObjectId'                    = $user.ObjectId
        'Office'                      = $user.Office
        'OverallProvisioningStatus'   = $user.OverallProvisioningStatus
        'PasswordNeverExpires'        = $user.PasswordNeverExpires
        'PhoneNumber'                 = $user.PhoneNumber
        'PostalCode'                  = $user.PostalCode
        'PreferredLanguage'           = $user.PreferredLanguage
        'ProxyAddresses'              = ( $user.ProxyAddresses | where {$_ -like "smtp:*"} ) -join ';'
        'ReleaseTrack'                = $user.ReleaseTrack
        'SignInName'                  = $user.SignInName
        'State'                       = $user.State
        'StreetAddress'               = $user.StreetAddress
        'StrongPasswordRequired'      = $user.StrongPasswordRequired
        'Title'                       = $user.Title
        'UsageLocation'               = $user.UsageLocation
        'UserPrincipalName'           = $user.UserPrincipalName
        'UserType'                    = $user.UserType
        'ValidationStatus'            = $user.ValidationStatus
        'WhenCreated'                 = $user.WhenCreated
    } # Properties

    $output = New-Object -TypeName PSObject -Property $properties
    Write-Output $output

} #foreach $user

