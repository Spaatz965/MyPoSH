#Requires -module ActiveDirectory

<#
	Create an XML group mapping file for use with Metalogix Content Matrix
#>

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
    $groups = Get-ADGroup -Filter {GroupCategory -eq "security"} -Properties SID,SamAccountName,DisplayName
    foreach ( $group in $groups ) {
        if ($group.DisplayName -eq $null) {
            $displayName = $group.Name
        } Else {
            $displayName = $group.DisplayName
        }
        $properties = @{
            GroupSID   = $group.sid
            DisplayName = $displayName
        } # Properties

        $output = New-Object -TypeName PSObject -Property $properties
        write-output "    <Mapping Source`=`"c:0+.w|$($output.GroupSid)`" Target`=`"$($output.DisplayName)`" />"

    } # Foreach $Group
} # Foreach $domain in $domains

Write-Output '</Mappings>'