<# 
    Unzip all zips in a folder
#>

$zips = ls *.zip
foreach ($zip in $zips) {
    $destpath =  $pwd.path + "\" + $zip.basename
    Expand-Archive -path $zip -DestinationPath $destpath
}
 
