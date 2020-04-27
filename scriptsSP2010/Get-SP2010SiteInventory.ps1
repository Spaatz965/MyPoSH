#requires -PsSnapIn 'Microsoft.SharePoint.PowerShell'
#requires -Version 2.0

function Get-SP2010SiteInventory {
    <#
.SYNOPSIS
    A brief description of the function or script. This keyword can be used
    only once in each topic.

.DESCRIPTION
    A detailed description of the function or script. This keyword can be
    used only once in each topic.

.PARAMETER  SiteCollection
    The description of a parameter. Add a .PARAMETER keyword for
    each parameter in the function or script syntax.

    Type the parameter name on the same line as the .PARAMETER keyword. 
    Type the parameter description on the lines following the .PARAMETER
    keyword. Windows PowerShell interprets all text between the .PARAMETER
    line and the next keyword or the end of the comment block as part of
    the parameter description. The description can include paragraph breaks.

    The Parameter keywords can appear in any order in the comment block, but
    the function or script syntax determines the order in which the parameters
    (and their descriptions) appear in help topic. To change the order,
    change the syntax.

    You can also specify a parameter description by placing a comment in the
    function or script syntax immediately before the parameter variable name.
    If you use both a syntax comment and a Parameter keyword, the description
    associated with the Parameter keyword is used, and the syntax comment is
    ignored.

.EXAMPLE
    A sample command that uses the function or script, optionally followed
    by sample output and a description. Repeat this keyword for each example.

.NOTES
    Additional information about the function or script.
    File Name      : Get-SP2010SiteInventory.ps1
    Author         : Mark Christman
    Requires       : PowerShell Version 2.0 and SharePoint Add-In
    Version        : 1.0
    Date           : 24 April 2020

#>

    [CmdletBinding()]
    param (
        [Parameter(    
            ValueFromPipelineByPropertyName = $true,
            Mandatory = $true,
            HelpMessage = "Site Collection Application URL")]
        [string[]]$SiteCollection
    )

    BEGIN {
        Write-Verbose "[$((get-date).TimeOfDay.ToString()) BEGIN   ] "

        if ( $null -eq ( Get-PSSnapin "Microsoft.SharePoint.PowerShell" -ErrorAction SilentlyContinue ) ) {
            Add-PSSnapin "Microsoft.SharePoint.PowerShell" 
        }
       
        # TODO: Add Get-EnvironmentMetadata helper function

    } # BEGIN

    PROCESS {
        Write-Verbose "[$((get-date).TimeOfDay.ToString()) PROCESS ] "

        foreach ( $Site in $SiteCollection ) {
            Write-Verbose "Collecting $Site"
            $SPSite = Get-SPSite -identity $Site
            if ( $SPSite.RootWeb.ID ) {
                Write-Verbose "Connected to $($SPSite.url)"
                $SPUsers = Get-SPUser -web $SPSite.URL -Limit All
                $SPSiteAdmins = $SPUsers | Where-Object { $_.isSiteAdmin }
                $ADGroups = $SPUsers | where-object { $_.isDomainGroup } | Select-Object -expandproperty UserLogin
                #$ADGroups = foreach ( $SPUser in $SPusers ){
                #    if ( $SPUser.isDomainGroup ) { write-output $SPUser.UserLogin }
                #} # ADGroups foreach
                # Prevent division by zero errors
                if ($SPSite.Quota.StorageMaximumLevel -gt 0 -and $SPSite.Usage.Storage -gt 0) {
                    $QuotaPercent = "{0:P2}" -f $SPSite.Usage.Storage / $SPSite.Quota.StorageMaximumLevel
                }
                else { 
                    $QuotaPercent = 0 
                } # if / else
                $properties = [ordered]@{
                    'AD Groups'                            = $ADGroups -join ";"
                    'AD Groups #'                          = $ADGroups.count
                    'Audting Flags'                        = $SPSite.Audit.AuditFlags
                    'Bandwidth'                            = $SPSite.usage.bandwidth
                    'Content Database'                     = $SPSite.ContentDatabase.Name
                    'Content Database Size (gb)'           = "{0:N2}" -f ($SPSite.ContentDatabase.DiskSizeRequired / 1gb)
                    'Creation Date'                        = get-date -date $SPSite.CertificationDate -format "MM/dd/yyyy hh:mm:ss"
                    'Creator Email'                        = $SPSite.RootWeb.Author.Email
                    'Creator Name'                         = $SPSite.RootWeb.Author.DisplayName
                    'Creator'                              = $SPSite.RootWeb.Author.UserLogin
                    'Date/Time Collected'                  = (get-date).ToUniversalTime().ToString("yyyyMMdd'Z'HHmm.ss")
                    'Date Collected'                       = (get-date).ToUniversalTime().ToString("yyyyMMdd'Z'")
                    'Description'                          = $SPSite.RootWeb.Description
                    'Features'                             = (Get-SPFeature -Site $SPSite | select-object -expandproperty displayname | out-string -stream ) -join '; '
                    'Hits'                                 = $SPSite.Usage.Hits
                    'Host Header Site Collection'          = $SPSite.HostHeaderIsSiteName
                    'Language Name'                        = $SPSite.RootWeb.UICulture.DisplayName
                    'Language'                             = $SPSite.RootWeb.UICulture.Name
                    'Last Modified Date'                   = get-date ($SPSite.LastContentModifiedDate) -format "MM/dd/yyyy hh:mm:ss"
                    'Last Security Modified Date'          = get-date ($SPSite.LastSecurityModifiedDate) -format "MM/dd/yyyy hh:mm:ss"
                    #'Large Lists'                         = ($lists | where {$_.itemcount -ge 4000} | measure-object).count
                    #'Lists'                               = ($lists | Measure-Object).count
                    'Locale'                               = $SPSite.RootWeb.Locale.name
                    'Multilingual'                         = $SPSite.RootWeb.IsMultilingual
                    'Owner Email'                          = $SPSite.Owner.Email
                    'Owner Name'                           = $SPSite.Owner.DisplayName
                    'Owner'                                = $SPSite.Owner.UserLogin
                    'Quota (% Used)'                       = $QuotaPercent
                    'Quota (Max)'                          = "{0:N2}" -f $SPSite.Quota.StorageMaximumLevel / 1mb
                    'Quota (Warning)'                      = "{0:N2}" -f $SPSite.Quota.StorageWarningLevel / 1mb
                    'Quota ID'                             = $SPSite.Quota.QuotaID
                    'Read Locked'                          = $SPSite.ReadLocked
                    'Read Only'                            = $SPSite.ReadOnly
                    'Relative Path URL'                    = $SPSite.ServerRelativeUrl
                    'Resource Quota (Max)'                 = $SPSite.Quota.UserCodeMaximumLevel
                    'Resource Quota (Warning)'             = $SPSite.Quota.UserCodeWarningLevel
                    'Resource Usage (Average)'             = $SPSite.AverageResourceUsage
                    'Resource Usage (Current)'             = $SPSite.CurrentResourceUsage
                    'Root Site Owners Group'               = $SPSite.RootWeb.AssociatedOwnerGroup
                    'Root Site Owners'                     = ( Get-SPUser -Group $SPSite.RootWeb.AssociatedOwnerGroup -web $SPSite.Url -limit all ) -join '; '
                    'Root Site ID'                         = $SPSite.RootWeb.ID
                    'Root Site Template ID'                = $SPSite.RootWeb.WebTemplateId
                    'Root Site Template'                   = $SPSite.RootWeb.WebTemplate
                    'Secondary Owner Email'                = $SPSite.SecondaryContact.Email
                    'Secondary Owner Name'                 = $SPSite.SecondaryContact.DisplayName
                    'Secondary Owner'                      = $SPSite.SecondaryContact.UserLogin
                    'Site Collection Administrators'       = ( $SPSiteAdmins | Select-Object -expandproperty userlogin | out-string -stream ) -join ";"
                    'Site Collection Administrators Email' = ( $SPSiteAdmins | where-object { $null -ne $_.email } | select-object -expandproperty email | out-string -stream ) -join ";"
                    'Site Collection Administrators Count' = $SiteAdmins.Count
                    'Site Collection GUID'                 = $SPSite.ID
                    'Site Collection URL'                  = $SPSite.Url
                    'Storage in use (MB)'                  = "{0:N2}" -f ( $SPSite.Usage.Storage / 1mb )
                    'Sub Sites'                            = $SPSite.AllWebs.count - 1
                    'Supported Languages'                  = $SPSite.RootWeb.SupportedUICultures -join ";"
                    'Supported Languages Count'            = $SPSite.RootWeb.SupportedUICultures.Count
                    'Time Zone'                            = $SPSite.RootWeb.RegionalSettings.TimeZone.Description
                    'Title'                                = $SPSite.RootWeb.Title
                    'Unique User Count'                    = $SPSite.RootWeb.AllUsers.count
                    'User Confirmation Messages Sent'      = $SPSite.DeadWebNotificationCount
                    'Visits'                               = $SPSite.Usage.Visits
                    'Warning Notification Sent'            = $SPSite.WarningNotificationSent
                    'Web Application'                      = $SPSite.WebApplication.DisplayName
                    'Write Locked'                         = $SPSite.WriteLocked
                } # Properties
            }
            else {
                $properties = [ordered]@{
                    'Audting Flags'                   = $SPSite.Audit.AuditFlags
                    'Bandwidth'                       = $SPSite.usage.bandwidth
                    'Content Database'                = $SPSite.ContentDatabase.Name
                    'Content Database Size (gb)'      = "{0:N2}" -f ($SPSite.ContentDatabase.DiskSizeRequired / 1gb)
                    'Creator Email'                   = $SPSite.RootWeb.Author.Email
                    'Creator Name'                    = $SPSite.RootWeb.Author.DisplayName
                    'Creator'                         = $SPSite.RootWeb.Author.UserLogin
                    'Description'                     = $SPSite.RootWeb.Description
                    'Hits'                            = $SPSite.Usage.Hits
                    'Host Header Site Collection'     = $SPSite.HostHeaderIsSiteName
                    'Language Name'                   = $SPSite.RootWeb.UICulture.DisplayName
                    'Language'                        = $SPSite.RootWeb.UICulture.Name
                    #'Large Lists'                         = ($lists | where {$_.itemcount -ge 4000} | measure-object).count
                    #'Lists'                               = ($lists | Measure-Object).count
                    'Locale'                          = $SPSite.RootWeb.Locale.name
                    'Multilingual'                    = $SPSite.RootWeb.IsMultilingual
                    'Owner Email'                     = $SPSite.Owner.Email
                    'Owner Name'                      = $SPSite.Owner.DisplayName
                    'Owner'                           = $SPSite.Owner.UserLogin
                    'Quota (Max)'                     = "{0:N2}" -f $SPSite.Quota.StorageMaximumLevel / 1mb
                    'Quota (Warning)'                 = "{0:N2}" -f $SPSite.Quota.StorageWarningLevel / 1mb
                    'Quota ID'                        = $SPSite.Quota.QuotaID
                    'Read Locked'                     = $SPSite.ReadLocked
                    'Read Only'                       = $SPSite.ReadOnly
                    'Relative Path URL'               = $SPSite.ServerRelativeUrl
                    'Resource Quota (Max)'            = $SPSite.Quota.UserCodeMaximumLevel
                    'Resource Quota (Warning)'        = $SPSite.Quota.UserCodeWarningLevel
                    'Resource Usage (Average)'        = $SPSite.AverageResourceUsage
                    'Resource Usage (Current)'        = $SPSite.CurrentResourceUsage
                    'Root Site Owners Group'          = $SPSite.RootWeb.AssociatedOwnerGroup
                    'Root Site ID'                    = $SPSite.RootWeb.ID
                    'Root Site Template ID'           = $SPSite.RootWeb.WebTemplateId
                    'Root Site Template'              = $SPSite.RootWeb.WebTemplate
                    'Secondary Owner Email'           = $SPSite.SecondaryContact.Email
                    'Secondary Owner Name'            = $SPSite.SecondaryContact.DisplayName
                    'Secondary Owner'                 = $SPSite.SecondaryContact.UserLogin
                    'Site Collection GUID'            = $SPSite.ID
                    'Site Collection URL'             = $SPSite.Url
                    'Storage in use (MB)'             = "{0:N2}" -f ( $SPSite.Usage.Storage / 1mb )
                    'Supported Languages'             = $SPSite.RootWeb.SupportedUICultures -join ";"
                    'Supported Languages Count'       = $SPSite.RootWeb.SupportedUICultures.Count
                    'Time Zone'                       = $SPSite.RootWeb.RegionalSettings.TimeZone.Description
                    'Title'                           = $SPSite.RootWeb.Title
                    'Unique User Count'               = $SPSite.RootWeb.AllUsers.count
                    'User Confirmation Messages Sent' = $SPSite.DeadWebNotificationCount
                    'Visits'                          = $SPSite.Usage.Visits
                    'Warning Notification Sent'       = $SPSite.WarningNotificationSent
                    'Web Application'                 = $SPSite.WebApplication.DisplayName
                    'Write Locked'                    = $SPSite.WriteLocked
                } # Properties

            } # if/else rootweb id
            
            $output = New-Object -TypeName PSObject -Property $properties
            if ( $null -ne $output ) {
                #$Output.PSObject.TypeNames.Insert(0, 'Contoso.SharePoint.SPSite.Inventory')
                write-output $output
            }
            $SPSite.Dispose()

        } # foreach spsite

    } # PROCESS

    END {
        Write-Verbose "[$((get-date).TimeOfDay.ToString()) END     ] "

    } # END

} # function Get-GLWSPSiteInventory