#Requires -module ActiveDirectory

<#
	Create an XML user account mapping file for use with Metalogix Content Matrix
#>

$adUserParams = @{
    'properties' = "employeeid","employeetype"
    'filter' = {
        employeeid -like '*' -and
        employeetype -notlike 'ext*'
    }
}

Write-Output '<Mappings>'

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
    $names = (get-aduser @adUserParams | Where-Object {$_.DistinguishedName -notmatch 'ou=nonemployee,dc=na,dc=contoso,dc=org'} | select samaccountname)
    foreach ( $name in $names ) {
        $aduser = get-aduser -Identity $name.samaccountname -Properties UserPrincipalName
        $properties = @{
            FQDNAccountName   = $Domain.NetBIOSName + '\' + $aduser.SamAccountName
            UserPrincipalName = $aduser.UserPrincipalName
        } # Properties

        $output = New-Object -TypeName PSObject -Property $properties
        write-output "    <Mapping Source`=`"$($output.FQDNAccountName)`" Target`=`"i:0#.f|membership|$($output.UserPrincipalName)`" />"

    } # Foreach $Name
} # Foreach $domain in $domains

Write-Output '</Mappings>'