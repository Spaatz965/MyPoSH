<#
JotaBe for the snippet for pulling JSON and removing comments
https://stackoverflow.com/questions/51066978/convert-to-json-with-comments-from-powershell
#>

$configFile = (Get-Content path-to-jsonc-file -raw)
$configFile = $configFile -replace '(?m)\s*//.*?$' -replace '(?ms)/\*.*?\*/'