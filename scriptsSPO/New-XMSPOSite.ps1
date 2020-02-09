


foreach ( $site in $sites ) {





    $SiteParameters = @{
        #'CompatibilityLevel' = 15
        'LocaleId'     = 1033
        'NoWait'       = $true
        'Owner'        = $site.Owner
        #'ResourceQuota'      = 300
        'StorageQuota' = 26214400
        'Template'     = 'STS#3'
        #TimeZoneID https://docs.microsoft.com/en-us/previous-versions/office/sharepoint-server/ms453853(v=office.15)
        'TimeZoneId'   = 10
        #'Title'              = "Title"
        'Url'          = $site.Url
    }

    New-SPOSite @SiteParameters

} 


foreach ( $site in $sites ) {





    $SiteParameters = @{
        #'CompatibilityLevel' = 15
        'LocaleId'     = 1033
        'NoWait'       = $true
        'Owner'        = $site.Owner
        #'ResourceQuota'      = 300
        'StorageQuota' = 26214400
        'Template'     = 'STS#3'
        #TimeZoneID https://docs.microsoft.com/en-us/previous-versions/office/sharepoint-server/ms453853(v=office.15)
        'TimeZoneId'   = 10
        #'Title'              = "Title"
        'Url'          = $site.Url
    }

    New-SPOSite @SiteParameters

}


foreach ( $site in $sites ) {





    $SiteParameters = @{
        #'CompatibilityLevel' = 15
        'LocaleId'     = 1033
        'NoWait'       = $true
        'Owner'        = $site.Owner
        #'ResourceQuota'      = 300
        'StorageQuota' = 26214400
        'Template'     = 'STS#3'
        #TimeZoneID https://docs.microsoft.com/en-us/previous-versions/office/sharepoint-server/ms453853(v=office.15)
        'TimeZoneId'   = 10
        #'Title'              = "Title"
        'Url'          = $site.Url
    }

    New-SPOSite @SiteParameters

}