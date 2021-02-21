#requires -modules MSOnline

$roles = get-msolrole
$TenantName = ((Get-MsolAccountSku)[0].accountskuid -split ":")[0]

foreach ( $role in $roles) {

    $roleMembers = Get-MsolRoleMember -RoleObjectId $role.ObjectID
    foreach ( $member in $roleMembers ) {

        if ($member.RoleMemberType -ne "ServicePrincipal") {
            $user = Get-MsolUser -ObjectId $member.ObjectId
            $AccountType = "Cloud Only"
            If ($user.ImmutableId.length -gt 3) {$AccountType="Synced"}
            $properties = [ordered]@{ 
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
                'ProxyAddresses'              = ( $user.ProxyAddresses | Where-Object {$_ -like "smtp:*"} ) -join ';'
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
        } #if $member.RoleMemberType -ne "ServicePrincipal"

    } #foreach $member

} #foreach $role