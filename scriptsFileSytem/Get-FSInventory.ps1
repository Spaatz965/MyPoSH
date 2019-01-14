<#
	Uses Robocopy to work around file path length errors
	Inspired by Boe Prox
	https://gallery.technet.microsoft.com/scriptcenter/Get-Deeply-Nested-Files-a2148fd7
#>



$Params = @(
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

$FileShares = Get-Content .\shares.txt
#Write-Output $FileShares

foreach ( $Share in $FileShares ) {
    #Write-Output $Share

    $TopLevelFolders = Get-ChildItem -Directory -Path $Share
    #Write-Output $TopLevelFolders

    foreach ( $TopLevelFolder in $TopLevelFolders ) {
        #Write-Output $TopLevelFolder
        $Folder = $TopLevelFolder.FullName

        $Script = "robocopy `"$Folder`" NULL $Params"
        #Write-Output $Script

        Invoke-Expression $Script | foreach {
            If ( $_.Trim() -match "^(?<Size>\d+)\s(?<Date>\S+\s\S+)\s+(?<FullName>.*)" ) {
                $Properties = @{
                    'Share'                = $Share
                    'TopLevelFolder'       = $Folder
                    'ParentFolder'         = $matches.fullname -replace '(.*\\).*','$1'
                    'FullName'             = $matches.FullName
                    'Name'                 = $matches.fullname -replace '.*\\(.*)','$1'
                    'Length'               = $matches.Size
                    'LastWriteTime'        = [datetime]$matches.Date
                    'Extension'            = $matches.fullname -replace '.*\.(.*)','$1'
		            'FullPathLength'       = $matches.FullName.Length
                    'OverLenghth'          = ( ( $matches.FullName.Length ) -ge 260 )
                    'HasIllegalCharacters' =  ( $matches.FullName -match $UnsupportedCharacters )
                }
                $Output = New-Object PSObject -Property $Properties
                Write-Output $Output
            }
    }
    }
}