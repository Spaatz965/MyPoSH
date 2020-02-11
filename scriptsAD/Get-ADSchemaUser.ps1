<#
    Export properties for users (requires AD Snapin)

#>

$schema = [DirectoryServices.ActiveDirectory.ActiveDirectorySchema]::GetCurrentSchema()
$OptionalProperties = $schema.findclass("user").optionalproperties
foreach ( $OptionalProperty in $OptionalProperties ) {
    $Properties = [ordered]@{
        'name'              = $OptionalProperty.name
        'commonName'        = $OptionalProperty.commonname
        'isSingleValued'    = $OptionalProperty.issinglevalued
        'isIndexed'         = $OptionalProperty.isindexed
        'isInGlobalCatalog' = $OptionalProperty.isinglobalcatalog
        'link'              = $OptionalProperty.link
    }
    $Output = New-Object -TypeName PSObject -Property $Properties
    Write-Output $Output
}
