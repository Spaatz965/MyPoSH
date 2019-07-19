

$Parameters = @{
    'Name'                                  = '<String>' #Rule Name
    'Policy'                                = '<PolicyIdParameter>' #Name of existing policy
    'AccessScope'                           = "InOrganization" #'<InOrganization | NotInOrganization>'
    'BlockAccess'                           = $false #'<$true | $false>'
    'Comment'                               = '<String>'
    'ContentContainsSensitiveInformation'   = @{ #'<PswsHashtable[]>'
        'name'          = "Canada Bank Account Number"
        # names come from Get-DlpSensitiveInformationType
        'minCount'      = "1"
        'maxCount'      = "-1" # -1 Equals "Any"
        'minConfidence' = "-1"
        'maxConfidence' = "100"
    },
    @{
        'name'          = "Canada Health Service Number"
        'minCount'      = "1"
        'maxCount'      = "-1"
        'minConfidence' = "-1"
        'maxConfidence' = "100"
    },
    @{
        'name'          = "Canada Personal Health Identification Number (PHIN)"
        'minCount'      = "1"
        'maxCount'      = "-1"
        'minConfidence' = "-1"
        'maxConfidence' = "100"
    },
    @{
        'name'          = "Canada Social Insurance Number"
        'minCount'      = "1"
        'maxCount'      = "-1"
        'minConfidence' = "-1"
        'maxConfidence' = "100"
    },
    @{
        'name'          = "Canada Driver's License Number"
        'minCount'      = "1"
        'maxCount'      = "-1"
        'minConfidence' = "-1"
        'maxConfidence' = "100"
    },
    @{
        'name'          = "Canada Passport Number"
        'minCount'      = "1"
        'maxCount'      = "-1"
        'minConfidence' = "-1"
        'maxConfidence' = "100"
    }
    #'ContentPropertyContainsWords'                = '<MultiValuedProperty>'
    'Disabled'                              = $false #'<$true | $false>'
    #'ExceptIfAccessScope'                         = '<InOrganization | NotInOrganization>'
    #'ExceptIfContentContainsSensitiveInformation' = '<PswsHashtable[]>'
    #'ExceptIfContentPropertyContainsWords'        = '<MultiValuedProperty>'
    'GenerateAlert'                         = '<MultiValuedProperty>'
    'GenerateIncidentReport'                = "admin1@example.com", "admin2@example.com", "adminDistributionList@example.com", "SiteAdmin" #'<MultiValuedProperty>'
    'IncidentReportContent'                 = "all" #'<ReportContentOption[]>'. Options include all,default,detections,documentauthor,documentlastmodifier,
    # matcheditem,rulesematched,service,severity,service,title. Default == DocumentAuthor,MatchedItem,RulesMatched,Service,Title
    'NotifyAllowOverride'                   = "WithJustification" #'<OverrideOption[]>' options include "FalsePostive","WithoutJustification","WithJustification"
    'NotifyEmailCustomText'                 = '<String>' # 5000 character limit. Alloss plain text or HTML and the following variables
    # %%AppliedActions%% %%ContentURL%% %%matchedConditions%%
    'NotifyPolicyTipCustomText'             = '<String>' # Max length 256 characters. No HTML or variables
    'NotifyPolicyTipCustomTextTranslations' = '<MultiValuedProperty>' # each language variation preceded by language designation
    # eg "fr\L'acces...."
    'NotifyUser'                            = "user@example.com", "LastModifier", "Owner", "SiteAdmin" #'<MultiValuedProperty>'
    'ReportSeverityLevel'                   = "Medium" #'<Low | Medium | High | None>'

}

New-DlpComplianceRule @Parameters

# See https://technet.microsoft.com/en-us/library/mt627838(v=exchg.160).aspx for more information

<#
New-DlpComplianceRule -Name <String> -Policy <PolicyIdParameter> [-AccessScope <InOrganization | NotInOrganization
    | None>] [-AccessTimeControl <PswsHashtable>] [-ActivationDate <DateTime>] [-BlockAccess <$true | $false>]
    [-Comment <String>] [-ContentContainsSensitiveInformation <PswsHashtable[]>] [-ContentPropertyContainsWords
    <MultiValuedProperty>] [-Disabled <$true | $false>] [-ExceptIfAccessScope <InOrganization | NotInOrganization |
    None>] [-ExceptIfContentContainsSensitiveInformation <PswsHashtable[]>] [-ExceptIfContentPropertyContainsWords
    <MultiValuedProperty>] [-ExceptIfDocumentIsUnsupported <$true | $false>] [-ExceptIfFrom <SmtpAddress[]>]
    [-ExceptIfFromMemberOf <SmtpAddress[]>] [-ExceptIfProcessingLimitExceeded <$true | $false>] [-ExpiryDate
    <DateTime>] [-From <SmtpAddress[]>] [-FromMemberOf <SmtpAddress[]>] [-GenerateAlert <MultiValuedProperty>]
    [-GenerateIncidentReport <MultiValuedProperty>] [-ImmutableId <Guid>] [-IncidentReportContent
    <ReportContentOption[]>] [-NotifyAllowOverride <OverrideOption[]>] [-NotifyEmailCustomText <String>]
    [-NotifyPolicyTipCustomText <String>] [-NotifyPolicyTipCustomTextTranslations <MultiValuedProperty>] [-NotifyUser
    <MultiValuedProperty>] [-ReportSeverityLevel <Low | Medium | High | None>] [-RuleErrorAction <Ignore |
    RetryThenBlock>] [-Confirm <SwitchParameter>] [-DocumentIsUnsupported <$true | $false>] [-ProcessingLimitExceeded
    <$true | $false>] [-WhatIf <SwitchParameter>] [<CommonParameters>]

    New-DlpComplianceRule -Policy <PolicyIdParameter> [-Confirm <SwitchParameter>] [-DocumentIsUnsupported <$true |
    $false>] [-ProcessingLimitExceeded <$true | $false>] [-WhatIf <SwitchParameter>] [<CommonParameters>]

    New-DlpComplianceRule -Policy <PolicyIdParameter> [-Confirm <SwitchParameter>] [-DocumentIsUnsupported <$true |
    $false>] [-ProcessingLimitExceeded <$true | $false>] [-WhatIf <SwitchParameter>] [<CommonParameters>]

    New-DlpComplianceRule -Policy <PolicyIdParameter> [-Confirm <SwitchParameter>] [-DocumentIsUnsupported <$true |
    $false>] [-ProcessingLimitExceeded <$true | $false>] [-WhatIf <SwitchParameter>] [<CommonParameters>]

-Name <String>
-Policy <PolicyIdParameter>
[-AccessScope <InOrganization | NotInOrganization | None>]
[-AccessTimeControl <PswsHashtable>]
[-ActivationDate <DateTime>]
[-BlockAccess <$true | $false>]
[-Comment <String>]
[-ContentContainsSensitiveInformation <PswsHashtable[]>]
[-ContentPropertyContainsWords <MultiValuedProperty>]
[-Disabled <$true | $false>]
[-ExceptIfAccessScope <InOrganization | NotInOrganization | None>]
[-ExceptIfContentContainsSensitiveInformation <PswsHashtable[]>]
[-ExceptIfContentPropertyContainsWords <MultiValuedProperty>]
[-ExceptIfDocumentIsUnsupported <$true | $false>]
[-ExceptIfFrom <SmtpAddress[]>]
[-ExceptIfFromMemberOf <SmtpAddress[]>]
[-ExceptIfProcessingLimitExceeded <$true | $false>]
[-ExpiryDate <DateTime>]
[-From <SmtpAddress[]>]
[-FromMemberOf <SmtpAddress[]>]
[-GenerateAlert <MultiValuedProperty>]
[-GenerateIncidentReport <MultiValuedProperty>]
[-ImmutableId <Guid>]
[-IncidentReportContent <ReportContentOption[]>]
[-NotifyAllowOverride <OverrideOption[]>]
[-NotifyEmailCustomText <String>]
[-NotifyPolicyTipCustomText <String>]
[-NotifyPolicyTipCustomTextTranslations <MultiValuedProperty>]
[-NotifyUser <MultiValuedProperty>]
[-ReportSeverityLevel <Low | Medium | High | None>]
[-RuleErrorAction <Ignore | RetryThenBlock>]
[-Confirm <SwitchParameter>]
[-DocumentIsUnsupported <$true | $false>]
[-ProcessingLimitExceeded <$true | $false>]
[-WhatIf <SwitchParameter>]
[<CommonParameters>]



#>