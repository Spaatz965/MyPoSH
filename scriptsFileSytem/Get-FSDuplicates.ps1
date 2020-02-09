$files = Get-ChildItem -Recurse -File |
Where-Object { $_.Length -gt 0 } |
Group-Object -Property Length |
Where-Object { $_.Count -gt 1 } |
ForEach-Object {
    $_.Group |
    ForEach-Object {
        $_ |
        Add-Member -MemberType NoteProperty -Name ContentHash -Value (Get-FileHash -Path $_.FullName)
    }
    <#
    $_.Group |
    Group-Object -Property ContentHash |
    Where-Object { $_.Count -gt 1 }
    #>
}

Write-Output $files
<#

$Files = Get-ChildItem -Recurse -File | Where-Object { $_.Length -gt 0 } | Group-Object -Property Length | Where-Object { $_.Count -gt 1 }

foreach ( $file in $files ) {




}
#>