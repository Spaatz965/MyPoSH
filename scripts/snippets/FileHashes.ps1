<#
    Get file hashes in a directory structure. Useful when looking for duplicates.
#>

$files = (Get-ChildItem -File -Recurse | select-object -Property name,fullname,basename,extension,directoryname,length)

foreach ( $file in $files ) {

    $Properties = @{
        'name'          = $file.name
        'fullname'      = $file.fullname
        'basename'      = $file.basename
        'extension'     = $file.extension
        'directoryname' = $file.directoryname
        'length'        = $file.length
        'hash'          = (Get-FileHash -Path $file.FullName -Algorithm MD5).hash
    } # $Properties

    $Output = New-Object -TypeName PSObject -Property $Properties
    Write-Output $Output

} # foreach
