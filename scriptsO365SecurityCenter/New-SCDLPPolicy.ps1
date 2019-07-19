function New-SCDLPPolicy {
    <#
.SYNOPSIS
	Function to create a new Office 365 Security and Compliance Center based
	DLP Policy with associated rules.

.DESCRIPTION
	Function to create a new Office 365 Security and Compliance Center based
	DLP Policy with associated rules.

.PARAMETER  Path
	The file path to a JSON formatted configuraiton file containing the
	details for the DLP Policy and Rules to be created.

.EXAMPLE
    New-SCDLPPolicy -path .\DLPPolicy.json

.NOTES
    Additional information about the function or script.
    File Name      : New-SCDLPPolicy.ps1
    Author         : Mark Christman
    Requires       : 
    Version        : 1.0
	Date           : 19 July 2019
	
	Acknowledgements to:
	Greg Bryniarski for sparking the idea to use a JSON config file.
	JotaBe for the snippet for pulling JSON and removing comments
	https://stackoverflow.com/questions/51066978/convert-to-json-with-comments-from-powershell
	Micah Rairdon for file path parameter validation
	https://4sysops.com/archives/validating-file-and-folder-paths-in-powershell-parameters/

.COMPONENT
    Office 365 Security and Compliance Center.

.ROLE
	Must have at least DLP Compliance Management role assigned in the Security
	and Compliance center.

.FUNCTIONALITY
    The intended use of the function. This content appears when the Get-Help
    command includes the Functionality parameter of Get-Help.

.FORWARDHELPTARGETNAME New-DLPPolicy

.FORWARDHELPCATEGORY  CmdLet

#>

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true,
            ValueFromPipeline = $true,
            HelpMessage = "Path to DLP Configuration JSON")]
        [ValidateScript( {
                if (-Not ($_ | Test-Path -PathType Leaf) ) {
                    throw "FilePath parameter is not a valid file.."
                }
                if ($_ -notmatch "(\.json)") {
                    throw "The file specified in the path argument must be a JSON file."
                }
                return $true 
            })]
        [System.IO.FileInfo]$Path
    )

    BEGIN {
        Write-Verbose "[$((get-date).TimeOfDay.ToString()) BEGIN   ] "
        Write-Verbose "[$((get-date).TimeOfDay.ToString()) BEGIN   ] Starting: $($MyInvocation.MyCommand)"
        Write-Verbose "[$((get-date).TimeOfDay.ToString()) BEGIN   ] Execution Metadata:"
        # TODO: Add Get-XMNEnvironmentMetaData helper function
        # $EnvironmentData = Get-XMNEnvironmentMetaData
        # Write-Verbose $EnvironmentData

        $configFile = (Get-Content -Path $Path -raw)
        $configFile = $configFile -replace '(?m)\s*//.*?$' -replace '(?ms)/\*.*?\*/'
        $Configuration = ConvertFrom-Json -InputObject $configFile

    } # BEGIN

    PROCESS {
        Write-Verbose "[$((get-date).TimeOfDay.ToString()) PROCESS ] "
		
        foreach ( $Policy in $Configuration.Policies ) {

            $PolicyProperties = @{
                'Name'                        = $Policy.Name
                'Comment'                     = $Policy.Comment
                'ExchangeLocation'            = $Policy.ExchangeLocation
                'Mode'                        = $Policy.Mode
                'OneDriveLocation'            = $Policy.OneDriveLocation
                'OneDriveLocationException'   = $Policy.OneDriveLocationException
                'SharePointLocation'          = $Policy.SharePointLocation
                'SharePointLocationException' = $Policy.SharePointLocationException
            } # $PolicyProperties
            # New-DlpCompliancePolicy @PolicyProperties
            $object = New-Object -TypeName psobject -Property $PolicyProperties
            write-output $object
			
            foreach ( $Rule in $Policy.Rules ) {

                $SItype = @( 
                    foreach ( $si in $Rule.ContentContainsSensitiveInformation ) {
                        $object = @{
                            'Name'          = $si.Name
                            'minCount'      = $si.minCount
                            'maxCount'      = $si.maxCount
                            'minConfidence' = $si.minConfidence
                            'maxConfidence' = $si.maxConfidence
                        }
                        $object
                    }
                )
                <# Added $SIType processing to force array with object types of
                   System.Collections.Hashtable. Without this pre-processing,
                   the script throws errors about being unable to convert to
                   date type: PswsHashtable. I'm not certain why this is, it
                   needs more investigation - not convinced this is the best
                   way to address the data conversion trouble.
                #>
                $RuleProperties = @{
                    'Name'                                = $Rule.Name
                    'Policy'                              = $Policy.Name
                    'AccessScope'                         = $Rule.AccessScope
                    'BlockAccess'                         = $Rule.BlockAccess
                    'Comment'                             = $Rule.Comment
                    'ContentContainsSensitiveInformation' = $SIType
                    'ContentPropertyContainsWords'        = $Rule.ContentPropertyContainsWords
                    'Disabled'                            = $Rule.Disabled
                    'GenerateAlert'                       = $Rule.GenerateAlert
                    'GenerateIncidentReport'              = $Rule.GenerateIncidentReport
                    'IncidentReportContent'               = $Rule.IncidentReportContent
                    'NotifyAllowOverride'                 = $Rule.NotifyAllowOverride
                    'NotifyEmailCustomText'               = $Rule.NotifyEmailCustomText
                    'NotifyPolicyTipCustomText'           = $Rule.NotifyPolicyTipCustomText
                    'NotifyUser'                          = $Rule.NotifyUser
                    'ReportSeverityLevel'                 = $Rule.ReportSeverityLevel
                    'RuleErrorAction'                     = $Rule.RuleErrorAction
                } # $RuleProperties
                New-DlpComplianceRule @RuleProperties
                $object = New-Object -TypeName psobject -Property $RuleProperties
                write-output $object

                
            } #foreach $Rule
			
        } # foreach $Policy

    } # PROCESS

    END {
        Write-Verbose "[$((get-date).TimeOfDay.ToString()) END     ] Ending: $($MyInvocation.Mycommand)"
        Write-Verbose "[$((get-date).TimeOfDay.ToString()) END     ] "

    } # END

} # function Verb-Noun

#region Function Test Use Cases (Uncomment To Test)

# Call Function with parameters
New-SCDLPPolicy -Path .\DLPPolicy.json

# Call Function via PipeLine

# Call Function via PipeLine By Name

# Call Function with multiple objects in parameter

# Call Function test Error Logging


#endregion