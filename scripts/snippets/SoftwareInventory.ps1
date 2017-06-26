<#
    Software Inventory via registry
#>

$Packages = Get-ItemProperty HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*
foreach ( $package in $Packages ) {
    $Properties = @{
        'DisplayName' = $package.displayname
        'DisplayVersion' = $package.displayversion
        'Publisher' = $package.publisher
        'InstallDate' = $package.InstallDate
    }
    $Output = New-Object -TypeName PSObject -Property $Properties
    Write-Output $Output
}

