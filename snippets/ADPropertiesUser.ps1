<#
    Useful sets of AD Properties
#>

$ADUserProperties = @(
    # Password and Logon Properties
    'badlogoncount',
    'badPwdCount',
    'lastbadpasswordattempt',
    'lockedout',
    'logonCount',
    'PasswordExpired',
    'PasswordLastSet',

    # Location Properties
    'c', # Country, 2-letter ISO Country Code
    'co', # Country, All CAPS, ISO Country Name
    'countryCode', # Country, ISO numeric code
    'l', # City
    'physicalDeliveryOfficeName', # Also office
    'POBox', 
    'PostalCode',
    'st', # State
    'StreetAddress', # Multiple Lines (May have Carriage Returns and/or Line Feeds)

    # User Account  and Identity Properties
    'AccountExpirationDate', # Not usually populated
    'CanonicalName', # Unique Identifier - good for structurally storting
    'Description',
    'DistinguishedName', # Also DN
    'EmployeeID', 
    'EmployeeNumber', # HR Employee Number
    'employeeType', # Person Classification
    'Enabled',
    'info',
    'isdeleted',
    'managedObjects', # Multivalue, DistinguishedName of Comuters and Groups user manages/owns - BackLink to the object
    'MemberOf', # Multivalue, DistinguishedName of AD Security and Distribution Groups - Backlink
    'Name', # CommonName, CN
    'ObjectClass',
    'PrimaryGroup',
    'primaryGroupID',
    'ProfilePath', # Not usually populated
    'SamAccountName',
    'SID',
    'SIDHistory', # Multivalue
    'userAccountControl',
    'UserPrincipalName',
    'whenChanged',
    'whenCreated',

    # Telepohone Properties
    'fax',
    'ipPhone',
    'otherHomePhone', # Multivalue
    'otherTelephone', # Multivalue
    'telephoneNumber', # Also officePhone

    # Language Localization Properties
    'codepage',
    'msexchuserculture', # localization as defined in exchange

    # Organizatioon Properties
    'Company', # Also organization
    'Department',
    'Division', # Not usualy populated
    'Manager',
    'o', # Organization - multivalued property
    'Title', # Organizational Title. Ex. Sales Analyst
    'directReports', # Multivalue property. DistinguishedName

    # Name Properties
    'DisplayName',
    'GivenName', # First Name
    'Initials',
    'sn', # Last Name, same as Surname
    'Surname', # Last Name, same as sn

    # Other Properties
    'extensionAttribute11',

    # Personal File Share Properties
    'HomeDirectory',
    'HomeDrive',

    # Email and Exchange Properties
    'homeMDB', # Exchange Mailbox Server / Database - DistinguishedName
    'homeMTA', # Exchange Message Transfer Agent - DistinguishedName
    'mail',
    'mailNickname',
    'msDS-PrincipalName',
    'msExchHomeServerName', # DistinguishedName of Exchange Home Server
    'msExchHideFromAddressLists',
    'msExchIMAddress',
    'msExchRequireAuthToSendTo',
    'msExchUserAccountControl',
    'msExchWhenMailboxCreated',
    'userSMIMECertificate', # Not readable - useful to know it exists

    # Instant Messaging Properties
    'msExchIMAddress' # IM / SIP Address


)