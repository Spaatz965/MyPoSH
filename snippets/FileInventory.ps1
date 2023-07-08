
$files = Get-ChildItem -Recurse -File

$fileInventory = foreach ( $file in $files ) {

    $hash = Get-FileHash -Path $file.FullName -Algorithm MD5

    $properties = [ordered]@{

        'FullName'          = $file.FullName
        'ResolvedTarget'    = $file.ResolvedTarget
        'Name'              = $file.Name
        'BaseName'          = $file.BaseName
        'Extension'         = $file.Extension
        'Length'            = $file.Length
        'Algorithm'         = $hash.Algorithm
        'Hash'              = $hash.Hash
        'IsReadOnly'        = $file.IsReadOnly
        'Directory'         = $file.Directory
        'DirectoryName'     = $file.DirectoryName
        'CreationTime'      = $file.CreationTime
        'CreationTimeUtc'   = $file.CreationTimeUtc
        'LastAccessTime'    = $file.LastAccessTime
        'LastAccessTimeUtc' = $file.LastAccessTimeUtc
        'LastWriteTime'     = $file.LastWriteTime
        'LastWriteTimeUtc'  = $file.LastWriteTimeUtc
    }

    $Output = New-Object -TypeName PSObject -Property $properties
    Write-Output $Output

}

$fileInventory | Export-Csv -Path "$pwd\fileInventory$(get-date -format FileDateTime).csv" -Encoding utf8BOM



$exifAttributeInventory = foreach ( $attribute in $attributes ) {

    $properties = [ordered]@{
        'attribute' = $attribute
        'count'     = ( ($exifInfo.$attribute -ne '').Count)
    }

    $Output = New-Object -TypeName PSObject -Property $properties
    Write-Output $Output

}


write-output "$attribute : $( ($exifInfo.$attribute -ne '').Count)"