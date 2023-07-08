# Removing duplicated downloads
$files = Get-ChildItem -Recurse -File | Where-Object { $_.BaseName -match ' \(\d{1,2}\)$' }

foreach ( $file in $files ) {

    $Temp =  Get-ChildItem -Path $file.DirectoryName -Name ( $file.Name -replace '\(\d{1,2}\)\.', '.') | Where-Object { $_.Length -eq $file.Length }

     if ( $Temp ) {

        Write-Output $Temp.FullName
        Write-Output $File.FullName

     }
}