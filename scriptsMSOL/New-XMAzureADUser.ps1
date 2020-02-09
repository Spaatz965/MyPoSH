[Reflection.Assembly]::LoadWithPartialName("System.Web")



foreach ( $user in $users ) {
    $Password = [system.web.security.membership]::GeneratePassword(12, 3)
    $PasswordProfile = New-Object -TypeName Microsoft.Open.AzureAD.Model.PasswordProfile
    $PasswordProfile.Password = $Password


    $UserParams = @{
        'AccountEnabled'    = $true
        #'City'                       = 'City'
        #'Country'                    = 'Country'
        #'CreationType'               = 'CreationType'
        #'Department'                 = 'Department'
        'DisplayName'       = $user.DisplayName
        #'ExtensionProperty'          = 'ExtensionProperty'
        #'FacsimileTelephoneNumber'   = 'FacsimileTelephoneNumber'
        'GivenName'         = $User.GivenName
        #'ImmutableId'                = 'ImmutableId'
        #'IsCompromised'              = 'IsCompromised'
        #'JobTitle'                   = 'JobTitle'
        'MailNickName'      = $user.MailNickName
        #'Mobile'                     = 'Mobile'
        #'OtherMails'                 = 'OtherMails'
        #'PasswordPolicies'           = 'PasswordPolicies'
        'PasswordProfile'   = $PasswordProfile
        #'PhysicalDeliveryOfficeName' = 'PhysicalDeliveryOfficeName'
        #'PostalCode'                 = 'PostalCode'
        #'PreferredLanguage'          = 'PreferredLanguage'
        #'ShowInAddressList'          = 'ShowInAddressList'
        #'SignInNames'                = 'SignInNames'
        #'State'                      = 'State'
        #'StreetAddress'              = 'StreetAddress'
        'Surname'           = $User.Surname
        #'TelephoneNumber'            = 'TelephoneNumber'
        'UsageLocation'     = 'US'
        'UserPrincipalName' = $User.UPN
        'UserType'          = 'Member'
    }

    New-AzureADUser @UserParams
    $object = New-Object -TypeName psobject -Property $UserParams
    Write-Output $Object
} 