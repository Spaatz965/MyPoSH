$UnifiedGroups = Get-UnifiedGroup

foreach ( $UnifiedGroup in $UnifiedGroups ) {
    $GroupOwners = Get-UnifiedGroupLinks -Identity $UnifiedGroup.name -LinkType Owners | Select-Object -ExpandProperty WindowsLiveID
    $GroupMembers = Get-UnifiedGroupLinks -Identity $UnifiedGroup.name -LinkType Members | Select-Object -ExpandProperty WindowsLiveID

    $Properties = [ordered]@{
        'SharePointURL' = $UnifiedGroup.SharePointSiteUrl
        'Owners'        = $GroupOwners
        'Members'       = $GroupMembers
    }
    $Object = New-Object -TypeName psobject -Property $Properties
    Write-Output $Object
} 
$UnifiedGroups = Get-UnifiedGroup

foreach ( $UnifiedGroup in $UnifiedGroups ) {
    $GroupOwners = Get-UnifiedGroupLinks -Identity $UnifiedGroup.name -LinkType Owners | Select-Object -ExpandProperty WindowsLiveID
    $GroupMembers = Get-UnifiedGroupLinks -Identity $UnifiedGroup.name -LinkType Members | Select-Object -ExpandProperty WindowsLiveID

    $Properties = [ordered]@{
        'SharePointURL' = $UnifiedGroup.SharePointSiteUrl
        'Owners'        = $GroupOwners
        'Members'       = $GroupMembers
    }
    $Object = New-Object -TypeName psobject -Property $Properties
    Write-Output $Object
}