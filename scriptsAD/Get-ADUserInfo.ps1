﻿#Requires -module ActiveDirectory
function Get-ADUserInfo {

    [CmdletBinding()]
    [Alias()]

    param(
        [parameter(ValueFromPipeline=$True,
                   ValueFromPipelineByPropertyName=$True,
                   HelpMessage="samAccountName, Mail, or surName")]
        [alias('mail','email','user','samaccountname','sn','name','lname')]
        [string[]]$Names=$env:USERNAME
    ) # param

    BEGIN{
        $Location = Get-Location

        $Forest = (Get-ADForest).domains

        $Domains = foreach ( $Domain in $Forest ) {
            $objTemp = Get-ADDomain $Domain
            $properties = @{ 
                NetBIOSName       = $objTemp.NetBIOSName
                DistinguishedName = $objTemp.DistinguishedName
                DNSRoot           = $objTemp.DNSRoot
                Drive             = $objTemp.NetBIOSName + ':' 
            } # Properties
            $output = New-Object -TypeName PSObject -Property $properties
            New-PSDrive -name $output.NetBIOSName -PSProvider ActiveDirectory -root $output.DistinguishedName -server $output.DNSRoot -ErrorAction SilentlyContinue | Out-Null

            write-output $output
        } # Foreach $domain in $forest
    } # Begin

    PROCESS {
        Foreach ( $domain in $domains ) {
            Write-Debug $domain
            #New-PSDrive -name $Domain.NetBIOSName -PSProvider ActiveDirectory -root $Domain.DistinguishedName -server $Domain.DNSRoot -ErrorAction SilentlyContinue | Out-Null
            Set-Location $Domain.drive
    
            foreach ( $Name in $Names ) {
                $NAMEMail = "smtp:"+$NAME
                $filter = {(samaccountname -eq $NAME) -or (proxyaddresses -eq $NAMEMail) -or (sn -eq $NAME)}
                $users = get-aduser -filter $filter -Properties *

                if ( $null -ne $users ) {
        
                    foreach ( $aduser in $users ) {
                        $properties = [ordered]@{
                            # Name Data
                            NameDisplay                     = $aduser.DisplayName
                            NameGiven                       = $aduser.GivenName
                            NameLast                        = $aduser.sn
                            NameOther                       = $aduser.OtherName
                            Initials                        = $aduser.Initials

                            # Physical Address Data
                            Office                          = $aduser.Office
                            StreetAddress                   = $aduser.StreetAddress
                            POBox                           = $aduser.POBox
                            City                            = $aduser.l
                            State                           = $aduser.st
                            PostalCode                      = $aduser.PostalCode
                            Country                         = $aduser.co
                            CountryISO2                     = $aduser.c
                            CountryISONumeric               = $aduser.countryCode

                            # AD Name Data
                            CanonicalName                   = $aduser.CanonicalName
                            CommonName                      = $aduser.CN
                            DistinguishedName               = $aduser.DistinguishedName

                            # Organization Data
                            Title                           = $aduser.Title
                            Company                         = $aduser.Company
                            Department                      = $aduser.Department
                            Division                        = $aduser.Division
                            DirectReports                   = $aduser.directReports -join "`n"
                            Manager                         = $aduser.Manager
                            Organization                    = $aduser.Organization
                            Organizations                   = $aduser.o -join "`n"

                            # HR Data
                            EmployeeNumber                  = $aduser.EmployeeNumber
                            EmployeeType                    = $aduser.employeeType

                            # Instant Messenger Data
                            IMAddress                       = $aduser.msExchIMAddress
                            IMFederationEnabled             = $aduser.'msRTCSIP-FederationEnabled'
                            IMInternetAccessEnabled         = $aduser.'msRTCSIP-InternetAccessEnabled'
                            IMPrimaryUserAddress            = $aduser.'msRTCSIP-PrimaryUserAddress'

                            # E-Mail Data
                            MailAddresses                   = ( $aduser.proxyAddresses | Where-Object {$_ -like "smtp:*"} ) -join ';'
                            MailAuthToSendMailto            = $aduser.authOrigBL -join "`n"
                            MailDLOwnership                 = $aduser.msExchCoManagedObjectsBL -join "`n"
                            MailHideFromAddressBook         = $aduser.msExchHideFromAddressLists
                            MailHomeServerName              = $aduser.msExchHomeServerName
                            MailmDBUseDefaults              = $aduser.mDBUseDefaults
                            MailNickname                    = $aduser.mailNickname
                            MailPrimary                     = $aduser.mail
                            MailShadowMailNickname          = $aduser.msExchShadowMailNickname
                            MailUserAccountControl          = $aduser.msExchUserAccountControl
                            MailUserCulture                 = $aduser.msExchUserCulture
                            legacyExchangeDN                = $aduser.legacyExchangeDN
                            WhenMailboxCreated              = $aduser.msExchWhenMailboxCreated

                            # Phone Data
                            PhoneFax                        = $aduser.Fax
                            PhoneHome                       = $aduser.HomePhone
                            PhoneHomeOther                  = $aduser.otherHomePhone -join "`n"
                            PhoneIP                         = $aduser.ipPhone
                            PhoneIPcisco                    = $aduser.ciscoEcsbuDtmfId
                            PhoneMobile                     = $aduser.MobilePhone
                            PhoneOffice                     = $aduser.OfficePhone
                            PhoneTelephoneNumber            = $aduser.telephoneNumber
                            PhoneTelephoneOther             = $aduser.otherTelephone -join "`n"

                            # User Names, Group Memberships, and extra stuff
                            FQDNAccountName                 = $Domain.NetBIOSName + '\' + $aduser.SamAccountName
                            SamAccountName                  = $aduser.SamAccountName
                            UserPrincipalName               = $aduser.UserPrincipalName
                            Description                     = $aduser.Description
                            GroupMemberships                = $aduser.MemberOf -join "`n"
                            HomePage                        = $aduser.HomePage
                            ManagedObjects                  = $aduser.managedObjects -join "`n"
                            RoamingProfilePath              = $aduser.ProfilePath

                            # File Share Info
                            HomeDirectory                   = $aduser.HomeDirectory
                            HomedirRequired                 = $aduser.HomedirRequired
                            HomeDrive                       = $aduser.HomeDrive

                            # Password & Logon Info
                            PasswordExpired                 = $aduser.PasswordExpired
                            PasswordLastSet                 = $aduser.PasswordLastSet
                            PasswordNeverExpires            = $aduser.PasswordNeverExpires
                            PasswordNotRequired             = $aduser.PasswordNotRequired
                            LockedOut                       = $aduser.LockedOut
                            LockoutTime                     = $aduser.lockoutTime
                            AccountLockoutTime              = $aduser.AccountLockoutTime
                            BadLogonCount                   = $aduser.BadLogonCount
                            CannotChangePassword            = $aduser.CannotChangePassword
                            LastBadPasswordAttempt          = $aduser.LastBadPasswordAttempt
                            LastLogoff                      = $aduser.lastLogoff
                            LastLogonDate                   = $aduser.LastLogonDate
                            LogonCount                      = $aduser.logonCount

                            # Account Dates
                            AccountExpirationDate           = $aduser.AccountExpirationDate
                            WhenChanged                     = $aduser.whenChanged
                            WhenCreated                     = $aduser.whenCreated

                            # Account Under the Hood Data
                            Enabled                         = $aduser.Enabled
                            IsDeleted                       = $aduser.isDeleted
                            ObjectGUID                      = $aduser.ObjectGUID
                            objectSid                       = $aduser.objectSid
                            ProtectedFromAccidentalDeletion = $aduser.ProtectedFromAccidentalDeletion
                            SID                             = $aduser.SID
                            SIDHistory                      = $aduser.SIDHistory -join "`n"
                            UserAccountControl              = $aduser.userAccountControl


                        } # Properties

                        $output = New-Object -TypeName PSObject -Property $properties
                        write-output $output

                    } #Foreach $aduser

                } # If $user not null

            } # Foreach $Name

        } # Foreach $domain in $domains
    } # PROCESS

    END{
        set-location $Location
    }
} # Function Get-ADUserInfo

#region testing the function

Get-ADUserInfo

#endregion
