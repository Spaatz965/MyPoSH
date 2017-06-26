#Requires -module ActiveDirectory

<#
	Output is child/parent pairs in DN format.
#>

$Forest = (Get-ADForest).domains

$Domains = foreach ( $Domain in $Forest ) {
    $objTemp = Get-ADDomain $Domain
    $properties = @{ 
        NetBIOSName       = $objTemp.NetBIOSName
        DistinguishedName = $objTemp.DistinguishedName
        DNSRoot           = $objTemp.DNSRoot
        Drive             = $objTemp.NetBIOSName + ':' }
    $output = New-Object -TypeName PSObject -Property $properties
    New-PSDrive -name $output.NetBIOSName -PSProvider ActiveDirectory -root $output.DistinguishedName -server $output.DNSRoot -ErrorAction SilentlyContinue | Out-Null

    write-output $output
} # Foreach $domain in $forest

Foreach ( $domain in $domains ) {
    Set-Location $Domain.drive
    $Groups = get-adgroup -filter {*}
    foreach ( $Group in $Groups ) {
        $Members = ( get-adgroup -Identity $Group.SamAccountName -Properties Members | select-object -ExpandProperty Members )
        foreach ( $Member in $Members ) {
            $properties = @{
                'ParentDistinguishedName' = $Group.DistinguishedName
                'ChildDistinguishedName'  = $Member.DistinguishedName
            } # Properties

            $output = New-Object -TypeName PSObject -Property $properties
            write-output $output

        } # Foreach $Member
    } # Foreach $Group
} # Foreach $domain in $domains

