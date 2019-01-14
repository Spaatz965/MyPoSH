<#
    HOTFIXES - Win32_QuickFixEngineering
    Windows Management Interface Data
    For PowerShell 2.0, use Get-WMIObject
    For PowerShell 3.0 and newer, use Get-CIMInstance
    $ComputerNames should be a list of computer names
#>

$ComputerNames = @(
    "LocalHost"
)

foreach ( $ComputerName in $ComputerNames ) {

    #$QFEObject = Get-WMIObject -Class Win32_QuickFixEngineering -ComputerName $ComputerName
    $QFEObjects = Get-CIMInstance -ClassName Win32_QuickFixEngineering -ComputerName $ComputerName
    foreach ( $QFEObject in $QFEObjects ) {

        $Properties = @{
            'InstalledOn' = $QFEObject.installedOn
            'HostName'    = $QFEObject.CSName
            'Hotfix'      = $QFEObject.HotfixID
            'InstalledBy' = $QFEObject.InstalledBy
            'Caption'     = $QFEObject.Caption
            'Description' = $QFEObject.Description
            'Name'        = $QFEObject.Name
            'ServicePack' = $QFEObject.ServicePackInEffect
        }

        $Output = New-Object -TypeName PSObject -Property $Properties
        Write-Output $Output
    }
}
