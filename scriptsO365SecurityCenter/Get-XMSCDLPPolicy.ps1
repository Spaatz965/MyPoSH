#requires -Version 5.1

function Get-XMSCDLPPolicy {
    <#
.SYNOPSIS
    Function to pull an XML formatted report of all or specific Office 365
    Security and Compliance Center Data Loss Prevention (DLP) Policies with
    rules included.

.DESCRIPTION
    Function to pull an XML formatted report of all or specific Office 365
    Security and Compliance Center Data Loss Prevention (DLP) Policies with
    rules included. The XML file is intended to be used for configuration
    audit, change management, and to faciliate configuration change.

.PARAMETER  Path
    The full file path to the intended output file. If not included, the
    default value will be:
    $ENV:USERPROFILE\Documents\DLPPolicyReport$(Get-Date -Format FileDateTime).xml

.PARAMETER  Policy
    The name or names of the policy/policies to be reported on. If omitted,
    all policies will be reported.

.EXAMPLE
    Get-XMSCDLPPolicy -Path "C:\Policy.xml"
    Reports all DLP Policies into a file located in the root directory.

.EXAMPLE
    Get-XMSCDLPPolicy -Policy "Example1"
    Reports the policy named "Example1" into the default file location.

.EXAMPLE
    Get-XMSCDLPPolicy -Policy "Example1","Example2"
    Reports the policies named "Example1" and "Example2" into the default file
    location.

.NOTES
    Additional information about the function or script.
    File Name      : Get-XMSCDLPPolicy.ps1
    Author         : Mark Christman
    Requires       : PowerShell Version 5.1 and Remote Connection to O365
                     Security & Compliance Center with sufficient permissions
                     to read DLP Policies and Rules.
    Version        : 1.0
    Date           : 12 February 2020

    ACKNOWLEDGEMENTS
    Bertrand, Adam, 18 Nov 2015, "Using PowerShell to create XML documents",
        https://searchwindowsserver.techtarget.com/tip/Using-PowerShell-to-create-XML-documents
    Hicks, Jeff, 6 Jan 2017, "Creating Custom XML from .NET and PowerShell",
        https://www.petri.com/creating-custom-xml-net-powershell
    Weltner, Tobias, 19 Aug 2013, "Mastering everyday XML tasks in PowerShell",
        https://www.powershellmagazine.com/2013/08/19/mastering-everyday-xml-tasks-in-powershell/

.LINK
https://docs.microsoft.com/en-us/powershell/exchange/office-365-scc/connect-to-scc-powershell/connect-to-scc-powershell?view=exchange-ps

.COMPONENT
    Office 365 Security and Compliance Center.

.ROLE
	Must have at least DLP Compliance Management role assigned in the Security
	and Compliance center.

.FUNCTIONALITY
    The intended use of the function. This content appears when the Get-Help
    command includes the Functionality parameter of Get-Help.

.FORWARDHELPTARGETNAME Get-DLPPolicy

.FORWARDHELPCATEGORY  CmdLet

#>

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false,
            ValueFromPipeline = $true)]
        [String] $Path = "$ENV:USERPROFILE\Documents\DLPPolicyReport$(Get-Date -Format FileDateTime).xml",
        [Parameter(Mandatory = $false)]
        [String] $Policy
    )

    BEGIN {
        Write-Verbose "[$((get-date).TimeOfDay.ToString()) BEGIN   ] "
        Write-Verbose "[$((get-date).TimeOfDay.ToString()) BEGIN   ] Starting: $($MyInvocation.MyCommand)"
        Write-Verbose "[$((get-date).TimeOfDay.ToString()) BEGIN   ] Execution Metadata:"
        # TODO: Add Get-XMNEnvironmentMetaData helper function
        # $EnvironmentData = Get-XMNEnvironmentMetaData
        # Write-Verbose $EnvironmentData
        # TODO: Error Checking to ensure remoting to tenant S&C PowerShell


        Write-Verbose "[$((get-date).TimeOfDay.ToString()) BEGIN   ] Getting Policies"

        Write-Verbose "[$((get-date).TimeOfDay.ToString()) BEGIN   ] Initiating XML File"
        $xmlWriter = New-Object System.XMl.XmlTextWriter( $Path, $Null )
        $xmlWriter.Formatting = 'Indented'
        $xmlWriter.Indentation = 1
        $XmlWriter.IndentChar = "`t"
        $xmlWriter.WriteStartDocument()
        $xmlWriter.WriteStartElement( 'Policies' )

    } # BEGIN

    PROCESS {
        Write-Verbose "[$((get-date).TimeOfDay.ToString()) PROCESS ] "
        $CompliancePolicies = Get-DLPCompliancePolicy


        foreach ( $CompliancePolicy in $CompliancePolicies) {

            Write-Verbose "[$((get-date).TimeOfDay.ToString()) PROCESS ] Writing policy elements"
            Write-Verbose "[$((get-date).TimeOfDay.ToString()) PROCESS ] $($CompliancePolicy.name)"

            $xmlWriter.WriteStartElement( 'Policy' )
            $xmlWriter.WriteElementString( 'Name', "$($CompliancePolicy.Name)" )
            $xmlWriter.WriteElementString( 'Comment', $CompliancePolicy.Comment )
            $xmlWriter.WriteElementString( 'Priority', $CompliancePolicy.Priority )
            $xmlWriter.WriteElementString( 'Mode', $CompliancePolicy.Mode )
            $xmlWriter.WriteComment(' Mode Options: Enable | TestWithNotifications | TestWithoutNotifications | Disable | PendingDeletion ')
            $xmlWriter.WriteElementString( 'Workload', $CompliancePolicy.Workload )
            $xmlWriter.WriteElementString( 'CreatedBy', $CompliancePolicy.CreatedBy )
            $xmlWriter.WriteElementString( 'LastModifiedBy', $CompliancePolicy.LastModifiedBy )
            $xmlWriter.WriteElementString( 'CreationTimeUtc', $CompliancePolicy.CreationTimeUtc )
            $xmlWriter.WriteElementString( 'ModificationTimeUtc', $CompliancePolicy.ModificationTimeUtc )

            foreach ( $ExchangeLocation in $CompliancePolicy.ExchangeLocation ) {
                $xmlWriter.WriteElementString( 'ExchangeLocation', $ExchangeLocation )
            } # foreach $ExchangeLocation in $CompliancePolicy.ExchangeLocation

            foreach ( $SharePointLocation in $CompliancePolicy.SharePointLocation ) {
                $xmlWriter.WriteElementString( 'SharePointLocation', $SharePointLocation.Name )
            } # foreach $SharePointLocation in $CompliancePolicy.SharePointLocation

            foreach ( $SharePointLocationException in $CompliancePolicy.SharePointLocationException ) {
                $xmlWriter.WriteElementString( 'SharePointLocationException', $SharePointLocationException.Name )
            } # foreach $SharePointLocationException in $CompliancePolicy.SharePointLocationException

            foreach ( $OneDriveLocation in $CompliancePolicy.OneDriveLocation ) {
                $xmlWriter.WriteElementString( 'OneDriveLocation', $OneDriveLocation.Name )
            } # foreach $OneDriveLocation in $CompliancePolicy.OneDriveLocation

            foreach ( $OneDriveLocationException in $CompliancePolicy.OneDriveLocationException ) {
                $xmlWriter.WriteElementString( 'OneDriveLocationException', $OneDriveLocationException.Name )
            } # foreach $OneDriveLocationException in $CompliancePolicy.OneDriveLocationException

            foreach ( $ExchangeOnPremisesLocation in $CompliancePolicy.ExchangeOnPremisesLocation ) {
                $xmlWriter.WriteElementString( 'ExchangeOnPremisesLocation', $ExchangeOnPremisesLocation )
            } # foreach $ExchangeOnPremisesLocation in $CompliancePolicy.ExchangeOnPremisesLocation

            foreach ( $SharePointOnPremisesLocation in $CompliancePolicy.SharePointOnPremisesLocation ) {
                $xmlWriter.WriteElementString( 'SharePointOnPremisesLocation', $SharePointOnPremisesLocation )
            } # foreach $SharePointOnPremisesLocation in $CompliancePolicy.SharePointOnPremisesLocation

            foreach ( $SharePointOnPremisesLocationException in $CompliancePolicy.SharePointOnPremisesLocationException ) {
                $xmlWriter.WriteElementString( 'SharePointOnPremisesLocationException', $SharePointOnPremisesLocationException )
            } # foreach $SharePointOnPremisesLocationException in $CompliancePolicy.SharePointOnPremisesLocationException

            foreach ( $TeamsLocation in $CompliancePolicy.TeamsLocation ) {
                $xmlWriter.WriteElementString( 'TeamsLocation', $TeamsLocation )
            } # foreach $TeamsLocation in $CompliancePolicy.TeamsLocation

            foreach ( $TeamsLocationException in $CompliancePolicy.TeamsLocationException ) {
                $xmlWriter.WriteElementString( 'TeamsLocationException', $TeamsLocationException )
            } # foreach $TeamsLocationException in $CompliancePolicy.TeamsLocationException

            foreach ( $EndpointDlpLocation in $CompliancePolicy.EndpointDlpLocation ) {
                $xmlWriter.WriteElementString( 'EndpointDlpLocation', $EndpointDlpLocation )
            } # foreach $EndpointDlpLocation in $CompliancePolicy.EndpointDlpLocation

            foreach ( $EndpointDlpLocationException in $CompliancePolicy.EndpointDlpLocationException ) {
                $xmlWriter.WriteElementString( 'EndpointDlpLocationException', $EndpointDlpLocationException )
            } # foreach $EndpointDlpLocationException in $CompliancePolicy.EndpointDlpLocationException

            foreach ( $ExchangeSender in $CompliancePolicy.ExchangeSender ) {
                $xmlWriter.WriteElementString( 'ExchangeSender', $ExchangeSender )
            } # foreach $ExchangeSender in $CompliancePolicy.ExchangeSender

            foreach ( $ExchangeSenderMemberOf in $CompliancePolicy.ExchangeSenderMemberOf ) {
                $xmlWriter.WriteElementString( 'ExchangeSenderMemberOf', $ExchangeSenderMemberOf )
            } # foreach $ExchangeSenderMemberOf in $CompliancePolicy.ExchangeSenderMemberOf

            foreach ( $ExchangeSenderException in $CompliancePolicy.ExchangeSenderException ) {
                $xmlWriter.WriteElementString( 'ExchangeSenderException', $ExchangeSenderException )
            } # foreach $ExchangeSenderException in $CompliancePolicy.ExchangeSenderException

            foreach ( $ExchangeSenderMemberOfException in $CompliancePolicy.ExchangeSenderMemberOfException ) {
                $xmlWriter.WriteElementString( 'ExchangeSenderMemberOfException', $ExchangeSenderMemberOfException )
            } # foreach $ExchangeSenderMemberOfException in $CompliancePolicy.ExchangeSenderMemberOfException

            Write-Verbose "[$((get-date).TimeOfDay.ToString()) PROCESS ] Getting Rules"
            Write-Verbose "[$((get-date).TimeOfDay.ToString()) PROCESS ] $($CompliancePolicy.Name)"

            $rules = Get-DLPComplianceRule -Policy $CompliancePolicy.Name

            foreach ( $rule in $rules ) {
                $xmlWriter.WriteStartElement( 'Rule' )
                $xmlWriter.WriteElementString( 'Name', $rule.Name )
                $xmlWriter.WriteElementString( 'ParentPolicyName', $CompliancePolicy.Name )
                $xmlWriter.WriteElementString( 'Priority', $rule.Priority )
                $xmlWriter.WriteElementString( 'AccessScope', $rule.AccessScope )
                $xmlWriter.WriteComment(' AccessScope Options: InOrganization | NotInOrganization ')
                $xmlWriter.WriteElementString( 'BlockAccess', $rule.BlockAccess )
                $xmlWriter.WriteElementString( 'BlockAccessScope', $rule.BlockAccessScope )
                $xmlWriter.WriteComment(' BlockAccessScope Options: All | PerUser ')
                $xmlWriter.WriteElementString( 'Comment', $rule.Comment )
                $xmlWriter.WriteElementString( 'ContentPropertyContainsWords', $rule.ContentPropertyContainsWords )
                $xmlWriter.WriteElementString( 'Disabled', $rule.Disabled )
                $xmlWriter.WriteElementString( 'StopPolicyProcessing', $rule.StopPolicyProcessing )
                $xmlWriter.WriteElementString( 'ReportSeverityLevel', $rule.ReportSeverityLevel )
                $xmlWriter.WriteComment(' ReportSeverityLevel Options: Low | Medium | High | None ')
                $xmlWriter.WriteElementString( 'RuleErrorAction', $rule.RuleErrorAction )
                $xmlWriter.WriteComment(' RuleErrorAction Options: Ignore | RetryThenBlock | null ')
                $xmlWriter.WriteElementString( 'ActivationDate', $rule.ActivationDate )
                $xmlWriter.WriteElementString( 'ExpiryDate', $rule.ExpiryDate )

                foreach ( $Alert in $rule.GenerateAlert ) {
                    $xmlWriter.WriteElementString( 'GenerateAlert', $Alert )
                } # foreach $Alert in $rule.GenerateAlert
                
                foreach ( $Report in $rule.GenerateIncidentReport ) {
                    $xmlWriter.WriteElementString( 'GenerateIncidentReport', $Report )
                } # foreach $Report in $rule.GenerateIncidentReport
                
                foreach ( $ReportContent in $rule.IncidentReportContent ) {
                    $xmlWriter.WriteElementString( 'IncidentReportContent', $ReportContent )
                } # foreach $ReportContent in $rule.IncidentReportContent
                $xmlWriter.WriteComment(' IncidentReportContent Options: All | Default | Detections | DocumentAuthor | DocumentLastModifier | MatchedItem | RulesMatched | Service | Severity | Service | Title ')

                foreach ( $NotifyOverride in $rule.NotifyAllowOverride ) {
                    $xmlWriter.WriteElementString( 'NotifyAllowOverride', $NotifyOverride )
                } # foreach $NotifyOverride in $rule.NotifyAllowOverride
                $xmlWriter.WriteComment(' NotifyAllowOverride Options: FalsePositive | WithoutJustification | WithJustification ')

                $xmlWriter.WriteElementString( 'NotifyEmailCustomText', $rule.NotifyEmailCustomText )
                $xmlWriter.WriteElementString( 'NotifyPolicyTipCustomText', $rule.NotifyPolicyTipCustomText )

                foreach ( $NotifyUser in $rule.NotifyUser ) {
                    $xmlWriter.WriteElementString( 'NotifyUser', $NotifyUser )
                } # foreach $NotifyUser in $rule.NotifyUser
                $xmlWriter.WriteComment(' NotifyUser Options: LastModifier | Owner | SiteAdmin | email address ')
                

                foreach ( $SIType in $rule.ContentContainsSensitiveInformation) {
                    $xmlWriter.WriteStartElement( 'ContentContainsSensitiveInformation' )
                    $xmlWriter.WriteElementString( 'Name', $SIType.Name )
                    $xmlWriter.WriteElementString( 'id', $SIType.id )
                    $xmlWriter.WriteElementString( 'minCount', $SIType.minCount )
                    $xmlWriter.WriteElementString( 'maxCount', $SIType.maxCount )
                    $xmlWriter.WriteElementString( 'minConfidence', $SIType.minConfidence )
                    $xmlWriter.WriteElementString( 'maxConfidence', $SIType.maxConfidence )
                    $xmlWriter.WriteComment(' -1 equals "ANY" ')
                    $xmlWriter.WriteEndElement()
                } # foreach $SIType in $rule.ContentContainsSensitiveInformation

                $xmlWriter.WriteEndElement()
            } # foreach $rule in $rules

            $xmlWriter.WriteEndElement()
        } # foreach $CompliancePolicy in $CompliancePolicies

    } # PROCESS

    END {
        Write-Verbose "[$((get-date).TimeOfDay.ToString()) END     ] Ending: $($MyInvocation.Mycommand)"
        Write-Verbose "[$((get-date).TimeOfDay.ToString()) END     ] "

        $xmlWriter.WriteEndElement()
        $xmlWriter.WriteEndDocument()
        $xmlWriter.Flush()
        $xmlWriter.Close()

    } # END

} # function Verb-Noun

#region Function Test Use Cases (Uncomment To Test)

# Call Function with parameters

# Call Function via PipeLine

# Call Function via PipeLine By Name

# Call Function with multiple objects in parameter

# Call Function test Error Logging
Get-XMSCDLPPolicy -Verbose

#endregion