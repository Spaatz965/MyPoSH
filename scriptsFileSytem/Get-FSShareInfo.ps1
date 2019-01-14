#Requires -version 3.0

<#
===|===|===|===|===|===|===|===|===|===|===|===|===|===|===|===|===|===|===|===|===|===|===|===|===|===|===|===|===|
.SYNOPSIS
    Run on any host with created, non administrative shares. Finds common
    statistics for top level directories within each share.

.DESCRIPTION
    Script was prepared to evaluate File and Shared Workgroup
    service Windows (CIFS) file shares. Output is intended to provide
    key statistical insight to current file storage volumes in preparation
    for migration to Microsoft's Office 365 based SharePoint Online
    and OneDrive for Business Service Offerings

.EXAMPLE
    PS: .\Get-ShareInfo.ps1

    computerName    : EXAMPLE
    folderModified  : 28-May-16 20:12:13
    folderAccessed  : 28-May-16 20:12:13
    folderCreated   : 28-May-16 20:12:13
    pstFileErrors   :
    pstFileSize     :
    shareName       : Downloads
    folderPath      : D:\OneDrive\Downloads\Flat-LAN-Blue-v3
    sharePath       : D:\OneDrive\Downloads
    pstFiles        : 0
    totalFolderSize : 3340693
    folderName      : Flat-LAN-Blue-v3
    totalFiles      : 0

.EXAMPLE
    PS: .\Get-ShareInfo.ps1 | Export-Csv -NoTypeInformation -UseCulture -Path .\outfilename.csv

.INPUTS
    This script is not intended to use any inputs or parameters.

.OUTPUTS
    The output is a psobject with the following attributes
    computerName == the name of the computer the script is run from
    shareName == the file share name as exposed to users
    sharePath == the local system path for the file share
    folderPath == the local system path for the top level folder statistics
        are gathered for
    folderName == the name of the folder statistics are gathered for
    folderCreated == UTC time and date the folder was created
    folderModified == UTC time and date the folder was last modified
    folderAccessed == UTC time and date the folder was last accessed -- may
        not reflect sub folders
    totalFolderSize == Total size in BYTES of all the files contained within
        the folder and nested sub folders
    totalFiles == Total number of files contained within the folder and nested
        sub folders
    pstFiles == Total number of PST files contained within the folder and
        nested sub folders
    pstFileSize == Total size in BYTES of all the PST files contained within
        the folder and nested sub folders
    pstFileErrors == Set to true if there were an error reading PST files
        - typically due to file path length exceeding 260 characters

.NOTES
    Additional information about the function or script.
    File Name  : Get-ShareInfo.ps1
    Author     : Mark Christman
    Requires   : PowerShell Version 3.0 and Run As Administrator
    Version    : 1.0
    Date       : 08 August 2016
    Acknowledgements to Ed Wilson (Hey Scripting Guy's), Don Jones, and Tom White
    For inspiring portions of the script -- use of FSO, Error Variable, and Output
#>

$fso = New-Object -com Scripting.FileSystemObject # Using a FileSystemObject (FSO) - faster than measuring recursive get-childitem (previoiusly used method).
$fileShares = get-wmiobject -Class win32_share #-Filter "not name like '%$'"

foreach ( $share in $fileShares ) {
    $systemFolders = get-childitem -Directory -Path $share.Path
    foreach ( $folder in $systemFolders ) {
        $folderFSO = $fso.GetFolder( $folder.fullname )
        $pstFiles = $(Get-ChildItem -File -Path $folder.FullName -filter *.pst -Recurse -ErrorVariable pstFileErrors -ErrorAction Continue | Measure-Object -Property length -sum)

        $properties = @{ computerName    = $share.PSComputerName
                         shareName       = $share.Name
                         sharePath       = $share.Path
                         folderPath      = $folder.FullName
                         folderName      = $folder.Name
                         folderCreated   = $folder.CreationTimeUtc
                         folderModified  = $folder.LastWriteTimeUtc
                         folderAccessed  = $folder.LastAccessTimeUtc
                         totalFolderSize = $folderFSO.Size
                         totalFiles      = $folderFSO.Files.Count
                         pstFiles        = $pstFiles.count
                         pstFileSize     = $pstFiles.sum
                         pstFileErrors   = $pstFileErrors }

        $output = New-Object -TypeName PSObject -Property $properties
        Write-Output $output
    } # foreach $folder
} # foreach $share