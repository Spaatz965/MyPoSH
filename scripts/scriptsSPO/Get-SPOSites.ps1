#Requires -module Microsoft.Online.SharePoint.PowerShell

$SPOSites = Get-SPOSite -Limit All | select *

foreach ( $SPOSite in $SPOSites ) {

<#
	COMMENTED OUT -- REQUIRES User be SCA in every site collection.

	IF ( $SPOSite.url -like "*contentTypeHub" ) {
		$SiteCollectionAdministrators = "N/A"
		$SPOUsers = "N/A"
	} Else {
		$SiteCollectionAdministrators = Get-SPOUser -Site $SPOSite.url | Where-Object {$_.IsSiteAdmin} | select LoginName
		$SPOUsers = (Get-SPOUser -site $SPOSite.url | Where-Object { -not $_.isgroup -and $_.LoginName -notmatch '\\' -and $_.LoginName -notlike "*@sharepoint"}).count
	}
#>


	IF ( $SPOSite.SharingCapability -eq "Disabled" ) {
		$ExternalUsers = "External Sharing Disabled"
	} ELSE {
		$ExternalUsers = (Get-SPOExternalUser -SiteUrl $SPOSite.url).count
	} #if
	
    $properties = @{
		#'SiteUsers'                                   = $SPOUsers 
		#'SiteCollectoinAdministrators'                = ($SiteCollectionAdministrators.loginname) -join ";"
		'LastModified'                                = $SPOSite.LastContentModifiedDate
		'Status'                                      = $SPOSite.Status
		'StorageUsed'                                 = $SPOSite.StorageUsageCurrent
		'LockIssue'                                   = $SPOSite.LockIssue
		'WebsCount'                                   = $SPOSite.WebsCount
		'CompatibilityLevel'                          = $SPOSite.CompatibilityLevel
		'DisableSharingForNonOwnersStatus'            = $SPOSite.DisableSharingForNonOwnersStatus
		'Url'                                         = $SPOSite.Url
		'LocaleId'                                    = $SPOSite.LocaleId
		'LockState'                                   = $SPOSite.LockState
		'Owner'                                       = $SPOSite.Owner
		'StorageQuota'                                = $SPOSite.StorageQuota
		'StorageQuotaWarningLevel'                    = $SPOSite.StorageQuotaWarningLevel
		'ResourceQuota'                               = $SPOSite.ResourceQuota
		'ResourceQuotaWarningLevel'                   = $SPOSite.ResourceQuotaWarningLevel
		'Template'                                    = $SPOSite.Template
		'Title'                                       = $SPOSite.Title
		'AllowSelfServiceUpgrade'                     = $SPOSite.AllowSelfServiceUpgrade
		'DenyAddAndCustomizePages'                    = $SPOSite.DenyAddAndCustomizePages
		'PWAEnabled'                                  = $SPOSite.PWAEnabled
		'SharingCapability'                           = $SPOSite.SharingCapability
		'SandboxedCodeActivationCapability'           = $SPOSite.SandboxedCodeActivationCapability
		'DisableCompanyWideSharingLinks'              = $SPOSite.DisableCompanyWideSharingLinks
		'DisableAppViews'                             = $SPOSite.DisableAppViews
		'DisableFlows'                                = $SPOSite.DisableFlows
		'StorageQuotaType'                            = $SPOSite.StorageQuotaType
		'SharingDomainRestrictionMode'                = $SPOSite.SharingDomainRestrictionMode
		'SharingAllowedDomainList'                    = $SPOSite.SharingAllowedDomainList
		'SharingBlockedDomainList'                    = $SPOSite.SharingBlockedDomainList
    } # Properties

    $output = New-Object -TypeName PSObject -Property $properties
    Write-Output $output

} #foreach $SPOSite
