#Requires -module ActiveDirectory

$Forest = (Get-ADForest).domains

$Domains = foreach ( $Domain in $Forest ) {
    $objTemp = Get-ADDomain $Domain
    $properties = @{ NetBIOSName       = $objTemp.NetBIOSName
                        DistinguishedName = $objTemp.DistinguishedName
                        DNSRoot           = $objTemp.DNSRoot
                        Drive             = $objTemp.NetBIOSName + ':' }
    $output = New-Object -TypeName PSObject -Property $properties
    New-PSDrive -name $output.NetBIOSName -PSProvider ActiveDirectory -root $output.DistinguishedName -server $output.DNSRoot -ErrorAction SilentlyContinue | Out-Null

    write-output $output
} # Foreach $domain in $forest

Foreach ( $domain in $domains ) {
    Set-Location $Domain.drive
    $Groups = get-adgroup -filter {*} -properties *
    foreach ( $Group in $Groups ) {
        if ( $Group.ManagedBy -ne "" ) {
            $HasOwner = $True
        } ELSE {
            $HasOwner = $false
        } # End IF
        $properties = @{
            'Domain'                          = $Domain.NetBIOSName
            'FQDNAccountName'                 = $Domain.NetBIOSName + "\" + $Group.SamAccountName
            'CanonicalName'                   = $Group.CanonicalName
            'CN'                              = $Group.CN
            'DTG Created'                     = get-date ( $Group.Created ) -format "dd/MM/yyyy hh:mm:ss" 
            'Deleted'                         = $Group.Deleted
            'Description'                     = $Group.Description
            'DisplayName'                     = $Group.DisplayName
            'DistinguishedName'               = $Group.DistinguishedName
            'GroupCategory'                   = $Group.GroupCategory
            'GroupScope'                      = $Group.GroupScope
            'groupType'                       = $Group.groupType
            'HomePage'                        = $Group.HomePage
            'instanceType'                    = $Group.instanceType
            'isDeleted'                       = $Group.isDeleted
            'LastKnownParent'                 = $Group.LastKnownParent
            'legacyExchangeDN'                = $Group.legacyExchangeDN
            'mail'                            = $Group.mail
            'mailNickname'                    = $Group.mailNickname
            'ManagedBy'                       = $Group.ManagedBy
            'Has Owner'                       = $HasOwner
            'Members'                         = ( $Group.Members | measure-object ).count
            'DTG Modified'                    = get-date ( $Group.Modified ) -format "dd/MM/yyyy hh:mm:ss" 
            'Name'                            = $Group.Name
            'ObjectClass'                     = $Group.ObjectClass
            'ObjectGUID'                      = $Group.ObjectGUID
            'objectSid'                       = $Group.objectSid
            'ProtectedFromAccidentalDeletion' = $Group.ProtectedFromAccidentalDeletion
            'proxyAddresses'                  = ( $Group.proxyAddresses | where {$_ -like "smtp:*"} ) -join ';'
            'SamAccountName'                  = $Group.SamAccountName
            'sAMAccountType'                  = $Group.sAMAccountType
            'SID'                             = $Group.SID
            'msExchHideFromAddressLists'      = $Group.msExchHideFromAddressLists
        } # Properties

        $output = New-Object -TypeName PSObject -Property $properties
        write-output $output

    } # Foreach $Group
} # Foreach $domain in $domains

