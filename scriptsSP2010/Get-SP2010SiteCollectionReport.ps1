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
        [parameter(ValueFromPipeline = $True,
            ValueFromPipelineByPropertyName = $True,
            HelpMessage = "Web Application URL")]
        [alias('WebApp', 'WebApplication')]
        [string]$URL = "https://sharepoint.example.com"
    ) # Param

    $WebApplication = Get-SPWebApplication -identity $url

    Foreach ($Site in $WebApplication.sites) {

        $SiteCollection = get-spsite -identity $Site
        
        $SiteUsers = get-spuser -web $siteCollection.Url -Limit All
        
        $SiteAdmins = foreach ($user in $siteusers) {
            If ($user.isSiteAdmin) { write-output $user.email }
        } # $SiteAdmins
        
        $ADGroups = foreach ($user in $siteusers) {
            If ($user.isDomainGroup) { write-output $user.userlogin }
        } # $ADGroups
        
        # Prevent division by zero errors
        if ($SiteCollection.Quota.StorageMaximumLevel -gt 0 -and $SiteCollection.Usage.Storage -gt 0) {
            $QuotaPercent = $SiteCollection.Usage.Storage/$SiteCollection.Quota.StorageMaximumLevel
        }
        else { 
            $QuotaPercent = 0 
        } # if / else

        $properties = [ordered]@{
            'Web Application'                      = $SiteCollection.HostName
            'Date Collected'                       = ((get-date).ToUniversalTime()).ToString("yyyyMMdd'Z'HHmm.ss")
            'URL'                                  = $SiteCollection.Url
            'Title'                                = $SiteCollection.RootWeb.Title
            'Description'                          = $SiteCollection.RootWeb.Description
            'Root Site Template ID'                = $SiteCollection.RootWeb.WebTemplateId
            'Root Site Template'                   = $SiteCollection.RootWeb.WebTemplate
            'Time Zone'                            = $SiteCollection.RootWeb.RegionalSettings.TimeZone.Description
            'Site Collection GUID'                 = $SiteCollection.ID
            'Relative Path URL'                    = $SiteCollection.ServerRelativeUrl
            'Content Database'                     = $SiteCollection.ContentDatabase.name
            'Sub Sites'                            = ($SiteCollection.AllWebs | measure-object).count - 1
            'Last Modified Date'                   = get-date ($SiteCollection.LastContentModifiedDate) -format "dd/MM/yyyy hh:mm:ss"
            'Last Security Modifid Date'           = get-date ($SiteCollection.LastSecurityModifiedDate) -format "dd/MM/yyyy hh:mm:ss"
            'Creation Date'                        = get-date ($SiteCollection.CertificationDate) -format "dd/MM/yyyy hh:mm:ss"
            'User Confirmation Messages Sent'      = $SiteCollection.DeadWebNotificationCount
            'Warning Notification Sent'            = $SiteCollection.WarningNotificationSent
            'Write Locked'                         = $SiteCollection.WriteLocked
            'Read Locked'                          = $SiteCollection.ReadLocked
            'Read Only'                            = $SiteCollection.ReadOnly
            'Storage in use (MB)'                  = [math]::round($SiteCollection.Usage.Storage / 1mb, 1)
            'Quota (% Used)'                       = $QuotaPercent
            'Quota (Max)'                          = $SiteCollection.Quota.StorageMaximumLevel / 1mb
            'Quota (Warning)'                      = $SiteCollection.Quota.StorageWarningLevel / 1mb
            'Quota ID'                             = $SiteCollection.Quota.QuotaID
            'Resource Quota (Max)'                 = $SiteCollection.Quota.UserCodeMaximumLevel
            'Resource Quota (Warning)'             = $SiteCollection.Quota.UserCodeWarningLevel
            'Resource Usage (Average)'             = $SiteCollection.AverageResourceUsage
            'Resource Usage (Current)'             = $SiteCollection.CurrentResourceUsage
            'Locale'                               = $SiteCollection.RootWeb.Locale.name
            'Multilingual'                         = $SiteCollection.RootWeb.IsMultilingual
            'Language Name'                        = $SiteCollection.RootWeb.UICulture.DisplayName
            'Language'                             = $SiteCollection.RootWeb.UICulture.Name
            'Supported Languages'                  = $SiteCollection.RootWeb.SupportedUICultures -join ";"
            'Supported Languages Count'            = ($SiteCollection.RootWeb.SupportedUICultures | Measure-Object).Count
            'Unique User Count'                    = ($SiteCollection.RootWeb.AllUsers | measure-object).count
            'AD Groups'                            = $ADGroups -join ";"
            'Site Collection Administrators'       = $SiteAdmins -join ";"
            'Site Collection Administrators Count' = ($SiteAdmins | measure-object).Count
            'Audting Flags'                        = $SiteCollection.Audit.AuditFlags
            'Creator Email'                        = $SiteCollection.RootWeb.Author.Email
            'Creator Name'                         = $SiteCollection.RootWeb.Author.DisplayName
            'Creator'                              = $SiteCollection.RootWeb.Author.UserLogin
            'Owner Email'                          = $SiteCollection.Owner.Email
            'Owner Name'                           = $SiteCollection.Owner.DisplayName
            'Owner'                                = $SiteCollection.Owner.UserLogin
            'Secondary Owner Email'                = $SiteCollection.SecondaryContact.Email
            'Secondary Owner Name'                 = $SiteCollection.SecondaryContact.DisplayName
            'Secondary Owner'                      = $SiteCollection.SecondaryContact.UserLogin
            #'Large Lists'                         = ($lists | where {$_.itemcount -ge 4000} | measure-object).count
            #'Lists'                               = ($lists | Measure-Object).count
        } # Properties

        $output = New-Object -TypeName PSObject -Property $properties

        if ( $null -ne $output ) {
            #$Output.PSObject.TypeNames.Insert(0, 'Contoso.SharePoint.SiteCollectionReport')
            write-output $output
        }
        $SiteCollection.Dispose()
        
    } # Foreach $SiteCollection

} # function Get-SPSiteCollectionReport

# TEST Requires PowerShell 3.0

$SPWebApplications = Get-SPWebApplication | where-object { $_.url -notmatch ".*:\d+/" -and $_.url -notlike "*my*" }

$Date = get-date -Format  "yyyyMMddTHHmm"

foreach ( $SPWebApplication in $SPWebApplications ) {

    Get-SPSiteCollectionReport -URL $SPWebApplication.URL | export-csv -NoTypeInformation $env:userprofile\documents\Sites$Date.csv -Append

} 

