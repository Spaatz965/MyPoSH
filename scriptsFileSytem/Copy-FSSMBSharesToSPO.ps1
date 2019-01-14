<#
	Need to update to use parameters
	Robocopy used to work around file path length errors and enable logging
	with restartable copy.
#>

$LogPath = "D:\CopyLogs\"
$CopyLocations = @()
$CopyLocations = import-csv "p:\CopySMBFileSharesWB20161219.csv"
#$CopyLocations = import-csv "p:\CopySMBFileSharesWV20161219.csv"

###
# Net Use connections used because Robocopy does not handle PSDrives well
###
$ScriptDeleteSDrive = "Net Use X: /Delete /y"
$ScriptDeleteDDrive = "Net Use Y: /Delete /y"

$MaxFileSize=10737418000 #Max File Size 10GB (2^30*10) less 240 bytes

$Head = "#" * 115

$params = New-Object System.Collections.Arraylist
$params.AddRange(@(
    "/e", #Copy subdirectories, including empty
    "/z", #Restartable Copy
    #"/purge", #Delete desination files not in source
    "/mt:16", #16 Threads
    "/max:$MaxFileSize", #Don't copy files over $MaxFileSize
    "/xj", #Ignore Junction Points
    "/r:10", #10 Retries (default is 1,000,000)
    "/w:2", #2 Second wait between retries (Default 30)
    "/v", #verbose logging
    "/fp", #Include full path names in log
    "/bytes" #File sizes in bytes
    #"/tee"
    #"/unilog+:$LogFile" #logfile location
))

if ( ( test-path -PathType Container -Path $LogPath ) -eq $false ) {
    New-Item -ItemType Directory -Force -Path $LogPath
}


foreach ( $Location in $CopyLocations ) {
    $SourceDirectory = $Location.Source
    $DestinationDirectory = $Location.DestinationHTTP
    $LogFile = "d:\CopyLogs\$($Location.Title)$(get-date -format yyyyMMdd).log"
    $Logging = "/unilog+:`"$LogFile`""

    $ScriptSourceDrive = "Net Use X: `"$SourceDirectory`""
    $ScriptDestinationDrive = "Net Use Y: `"$DestinationDirectory`""
    $ScriptCopy = "Robocopy X:\ Y:\ $params $Logging"

    $start = "$head`r`n### STARTING $SourceDirectory`r`n$head"
    $end = "$head`r`n### COMPLETED $SourceDirectory`r`n$head"
    $tail = "SOURCE: $SourceDirectory`r`nTARGET: $DestinationDirectory`r`nOwner: $($Location.OWNERUPN)"

    Write-Output $start

    Invoke-Expression $ScriptDeleteSDrive | Out-Null
    Invoke-Expression $ScriptDeleteDDrive | Out-Null
    Invoke-Expression $ScriptSourceDrive
    Invoke-Expression $ScriptDestinationDrive
    Invoke-Expression $ScriptCopy

    $tail | Out-File $LogFile -Append -Encoding ascii
    
    Write-Output $end

} #foreach Location
