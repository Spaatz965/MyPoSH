#
# Script1.ps1
#
$Parameters = @{
	'Name'                                        = '<String>'
	'Policy'                                      = '<PolicyIdParameter>'
	'AccessScope'                                 = '<InOrganization | NotInOrganization>'
	'BlockAccess'                                 = '<$true | $false>'
	'Comment'                                     = '<String>'
	'ContentContainsSensitiveInformation'         = '<PswsHashtable[]>'
	'ContentPropertyContainsWords'                = '<MultiValuedProperty>'
	'Disabled'                                    = '<$true | $false>'
	'ExceptIfAccessScope'                         = '<InOrganization | NotInOrganization>'
	'ExceptIfContentContainsSensitiveInformation' = '<PswsHashtable[]>'
	'ExceptIfContentPropertyContainsWords'        = '<MultiValuedProperty>'
	'GenerateAlert'                               = '<MultiValuedProperty>'
	'GenerateIncidentReport'                      = '<MultiValuedProperty>'
	'IncidentReportContent'                       = '<ReportContentOption[]>'
	'NotifyAllowOverride'                         = '<OverrideOption[]>'
	'NotifyEmailCustomText'                       = '<String>'
	'NotifyPolicyTipCustomText'                   = '<String>'
	'NotifyPolicyTipCustomTextTranslations'       = '<MultiValuedProperty>'
	'NotifyUser'                                  = '<MultiValuedProperty>'
	'ReportSeverityLevel'                         = '<Low | Medium | High | None>'

}

New-DlpComplianceRule @Parameters