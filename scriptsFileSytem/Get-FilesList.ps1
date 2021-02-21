$files = Get-ChildItem -Path D:\ -File -Recurse | Select-Object BaseName, FullName, Name, CreationTime, Extension, Directory, DirectoryName, Length, Attributes, Mode
foreach ( $file in $files ) {
    $FullName = $file | Select-Object -ExpandProperty FullName
    $properties = [ordered]@{
        'DirectoryName' = $file.DirectoryName
        'FullName'      = $file.FullName
        'BaseName'      = $file.BaseName
        'Extension'     = $file.Extension
        'Name'          = $file.Name
        'CreationTime'  = $file.CreationTime
        'Size'          = $file.Length
        'CRC'           = (Get-FileHash -LiteralPath $FullName -Algorithm SHA256).Hash
        'Attributes'    = $file.attributes
        'Mode'          = $file.Mode
        'Owner'         = (get-acl -LiteralPath $FullName).Owner
    }
    $Output = New-Object -TypeName PSObject -Property $Properties
    Write-Output $Output
}