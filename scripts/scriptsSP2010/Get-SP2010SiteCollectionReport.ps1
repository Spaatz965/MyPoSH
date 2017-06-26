#Requires -PSSnapin "Microsoft.SharePoint.PowerShell"

function Get-SPSiteCollectionReport {

    <#
    .SYNOPSIS
    Retrieves key service delivery management information for site collections
    within a web application.
    .DESCRIPTION
    Get-SPSiteCollectionReport uses the SharePoint management snap-in for
    PowerShell to retrieve information for all Site Collections within
    a specified SharePoint Web Application.
    .PARAMETER URL
    One or more Web Application URL's. Must be within the same SharePoint
    Farm.
    .EXAMPLE
    Get-SPSiteCollectionReport -URL "https://sharepoint.example.com"
    .EXAMPLE
    $URLS = "https://sharepoint.example.com","https://my-sharepoint.example.com"
    $URLS | Get-SPSiteCollectionReport
    .EXAMPLE
    $URLS = "https://sharepoint.example.com","https://my-sharepoint.example.com"
    Get-SPSiteCollectionReport -URL $URLS
    #>

    Param (
        [parameter(ValueFromPipeline=$True,
                   ValueFromPipelineByPropertyName=$True,
                   HelpMessage="Web Application URL")]
        [alias('WebApp','WebApplication')]
        [string]$URL="https://sharepoint.example.com"
    ) # Param

    $WebApplication = Get-SPWebApplication -identity $url

    Foreach ($Site in $WebApplication.sites) {

        $SiteCollection = get-spsite -identity $Site
        
        $SiteUsers = get-spuser -web $siteCollection.Url -Limit All
        
        $SiteAdmins = foreach ($user in $siteusers) {
            If ($user.isSiteAdmin) {write-output $user.email}
        } # $SiteAdmins
        
        $ADGroups = foreach ($user in $siteusers) {
            If ($user.isDomainGroup) {write-output $user.userlogin}
        } # $ADGroups
        
        # Prevent division by zero errors
        if ($SiteCollection.Quota.StorageMaximumLevel -gt 0 -and $SiteCollection.Usage.Storage -gt 0) {
            $QuotaPercent = $SiteCollection.Usage.Storage/$SiteCollection.Quota.StorageMaximumLevel
        } else { 
            $QuotaPercent = 0 
        } # if / else

        $properties = @{
                        'AD Groups'                            = $ADGroups -join ";"
                        'Audting Flags'                        = $SiteCollection.Audit.AuditFlags
                        'Content Database'                     = $SiteCollection.ContentDatabase.name
                        'Creation Date'                        = get-date ($SiteCollection.CertificationDate) -format "dd/MM/yyyy hh:mm:ss"
                        'Creator Email'                        = $SiteCollection.RootWeb.Author.Email
                        'Creator Name'                         = $SiteCollection.RootWeb.Author.DisplayName
                        'Creator'                              = $SiteCollection.RootWeb.Author.UserLogin
                        'Date Collected'                       = ((get-date).ToUniversalTime()).ToString("yyyyMMdd'Z'HHmm.ss")
                        'Description'                          = $SiteCollection.RootWeb.Description
                        'Language Name'                        = $SiteCollection.RootWeb.UICulture.DisplayName
                        'Language'                             = $SiteCollection.RootWeb.UICulture.Name
                        'Last Modified Date'                   = get-date ($SiteCollection.LastContentModifiedDate) -format "dd/MM/yyyy hh:mm:ss"
                        'Last Security Modifid Date'           = get-date ($SiteCollection.LastSecurityModifiedDate) -format "dd/MM/yyyy hh:mm:ss"
                        #'Large Lists'                         = ($lists | where {$_.itemcount -ge 4000} | measure-object).count
                        #'Lists'                               = ($lists | Measure-Object).count
                        'Locale'                               = $SiteCollection.RootWeb.Locale.name
                        'Multilingual'                         = $SiteCollection.RootWeb.IsMultilingual
                        'Owner Email'                          = $SiteCollection.Owner.Email
                        'Owner Name'                           = $SiteCollection.Owner.DisplayName
                        'Owner'                                = $SiteCollection.Owner.UserLogin
                        'Quota (% Used)'                       = $QuotaPercent
                        'Quota (Max)'                          = $SiteCollection.Quota.StorageMaximumLevel / 1mb
                        'Quota (Warning)'                      = $SiteCollection.Quota.StorageWarningLevel / 1mb
                        'Quota ID'                             = $SiteCollection.Quota.QuotaID
                        'Read Locked'                          = $SiteCollection.ReadLocked
                        'Read Only'                            = $SiteCollection.ReadOnly
                        'Relative Path URL'                    = $SiteCollection.ServerRelativeUrl
                        'Resource Quota (Max)'                 = $SiteCollection.Quota.UserCodeMaximumLevel
                        'Resource Quota (Warning)'             = $SiteCollection.Quota.UserCodeWarningLevel
                        'Resource Usage (Average)'             = $SiteCollection.AverageResourceUsage
                        'Resource Usage (Current)'             = $SiteCollection.CurrentResourceUsage
                        'Root Site Template ID'                = $SiteCollection.RootWeb.WebTemplateId
                        'Root Site Template'                   = $SiteCollection.RootWeb.WebTemplate
                        'Secondary Owner Email'                = $SiteCollection.SecondaryContact.Email
                        'Secondary Owner Name'                 = $SiteCollection.SecondaryContact.DisplayName
                        'Secondary Owner'                      = $SiteCollection.SecondaryContact.UserLogin
                        'Site Collection Administrators'       = $SiteAdmins -join ";"
                        'Site Collection Administrators Count' = ($SiteAdmins | measure-object).Count
                        'Site Collection GUID'                 = $SiteCollection.ID
                        'Storage in use (MB)'                  = [math]::round($SiteCollection.Usage.Storage / 1mb,1)
                        'Sub Sites'                            = ($SiteCollection.AllWebs | measure-object).count -1
                        'Supported Languages'                  = $SiteCollection.RootWeb.SupportedUICultures -join ";"
                        'Supported Languages Count'            = ($SiteCollection.RootWeb.SupportedUICultures | Measure-Object).Count
                        'Time Zone'                            = $SiteCollection.RootWeb.RegionalSettings.TimeZone.Description
                        'Title'                                = $SiteCollection.RootWeb.Title
                        'Unique User Count'                    = ($SiteCollection.RootWeb.AllUsers | measure-object).count
                        'URL'                                  = $SiteCollection.Url
                        'User Confirmation Messages Sent'      = $SiteCollection.DeadWebNotificationCount
                        'Warning Notification Sent'            = $SiteCollection.WarningNotificationSent
                        'Web Application'                      = $SiteCollection.HostName
                        'Write Locked'                         = $SiteCollection.WriteLocked
        } # Properties

        $output = New-Object -TypeName PSObject -Property $properties
        $Output.PSObject.TypeNames.Insert(0,'Contoso.SharePoint.SiteCollectionReport')
        write-output $output

        $SiteCollection.Dispose()
        
    } # Foreach $SiteCollection

} # function Get-SPSiteCollectionReport

Get-SPSiteCollectionReport -URL "https://sharepoint.example.com" | export-csv -NoTypeInformation $env:userprofile\documents\test20160912.csv
