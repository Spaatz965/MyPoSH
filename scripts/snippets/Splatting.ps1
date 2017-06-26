<#
    Splatting / Output Formatting
    Be sure to line up '=' equals signs
    Notepad++ CodeAlign addin
#>

$Properties = @{
    'PropertyName1' = $Info1
    'PropertyName2' = $Info2
    'PropertyName3' = $Info3
}

$Output = New-Object -TypeName PSObject -Property $Properties
Write-Output $Output