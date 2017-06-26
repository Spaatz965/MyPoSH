<#
    Import XML Files. Add file date as a property of each record. Export to a single file.
	Used for enumerated sharepoint site xml output.
#>

foreach ($file in $files) {
    Write-Verbose $file.Filename
    [xml]$temp = get-content $file.filename
    $sites = $temp.sites.childnodes
    $sites | Add-Member -MemberType NoteProperty -Name Date -Value $file.date -Force
    $sites | export-csv -NoTypeInformation .\enumMySites.csv -append
}
 
