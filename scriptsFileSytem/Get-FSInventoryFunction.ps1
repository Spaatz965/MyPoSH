function Get-EISFolderInventory {

<#.Synopsis
<!<SnippetShortDescription>!>
.DESCRIPTION
<!<SnippetLongDescription>!>
.EXAMPLE
<!<SnippetExample>!>
.EXAMPLE
<!<SnippetAnotherExample>!>
#>

    [CmdletBinding()]
    [OutputType([int])]
    param(
        # <!<SnippetParam1Help>!>
        [Parameter(
            Mandatory=$true,
            ValueFromPipelineByPropertyName=$true,
            Position=0)]
        [string[]]$TopLevelFolders = $pwd
    )

    Begin {
        $RoboCopyParams = @(
            "/L", #List files only, not copied or other
            "/S", #recurse subdirectories
            "/NJH", #No Job Header
            "/BYTES", #File sizes in bytes
            "/FP", #Full path name in output
            "/NC", #File classes are not logged
            "/NDL", #No Directory Names
            "/TS", #Include file timestamps
            "/XJ", #Exclude Junction Points
            "/R:0", # No Retries
            "/W:0" # No wait between retries
        )

        $UnsupportedCharacters = '[!&{}~#%]'

    } #Begin

    Process {
        foreach ( $Folder in $TopLevelFolders ) {

        $Script = "robocopy `"$Folder`" NULL $RoboCopyParams"

            Invoke-Expression $Script | ForEach {
                If ( $_.Trim() -match "^(?<Size>\d+)\s(?<Date>\S+\s\S+)\s+(?<FullName>.*)" ) {
                    $Properties = @{
                        'Share'                    = $Share
                        'Top Level Folder'         = $Folder
                        'Parent Folder'            = $matches.fullname -replace '(.*\\).*','$1'
                        'Full Name'                = $matches.FullName
                        'Name'                     = $matches.fullname -replace '.*\\(.*)','$1'
                        'Length (Bytes)'           = $matches.Size
                        'Length (KB)'              = ('{0:N6}' -f ($matches.Size / 1kb))
                        'Length (MB)'              = ('{0:N6}' -f ($matches.Size / 1mb))
                        'Length (GB)'              = ('{0:N6}' -f ($matches.Size / 1gb))
                        'Last Write Time'          = [datetime]$matches.Date
                        'Extension'                = $matches.fullname -replace '.*\.(.*)','$1'
                        'Full Path Length'         = $matches.FullName.Length
                        'Is Over Lenghth'          = ( ( $matches.FullName.Length ) -ge 260 )
                        'Unsupported Characters'   =  ( $matches.FullName -match $UnsupportedCharacters )
                        'Both Unsupp And Length'   = ( ( $matches.FullName.Length ) -ge 260 ) -and ( $matches.FullName -match $UnsupportedCharacters )
                        'Either Unsupp Or Length'  = ( ( $matches.FullName.Length ) -ge 260 ) -or ( $matches.FullName -match $UnsupportedCharacters )
                    } #$Properties
                    $Output = New-Object PSObject -Property $Properties
                    Write-Output $Output
                } # IF
            } #ForEach
        } #ForEach $Folder
    } #Process

    End {

    } #End
} #Function Get-EISFileInventory

Get-EISFolderInventory $pwd
