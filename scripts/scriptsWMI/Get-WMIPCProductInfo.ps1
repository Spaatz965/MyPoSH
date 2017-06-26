<#
    Installed Software - Win32_Product
    Windows Management Interface Data
    For PowerShell 2.0, use Get-WMIObject
    For PowerShell 3.0 and newer, use Get-CIMInstance
    $ComputerNames should be a list of computer names
#>

$ComputerNames = @(
    "LocalHost"
)

foreach ( $ComputerName in $ComputerNames ) {

    #$ProductObjects = Get-WMIObject -Class Win32_QuickFixEngineering -ComputerName $ComputerName
    $ProductObjects = Get-CIMInstance -ClassName Win32_QuickFixEngineering -ComputerName $ComputerName
    foreach ( $ProductObject in $ProductObjects ) {

        $Properties = @{
            'Name'              = $ProductObject.Name
            'Version'           = $ProductObject.Version
            'InstallState'      = $ProductObject.InstallState
            'Caption'           = $ProductObject.Caption
            'Description'       = $ProductObject.Description
            'IdentifyingNumber' = $ProductObject.IdentifyingNumber
            'SKUNumber'         = $ProductObject.SKUNumber
            'Vendor'            = $ProductObject.Vendor
            'AssignmentType'    = $ProductObject.AssignmentType
            'HelpLink'          = $ProductObject.HelpLink
            'HelpTelephone'     = $ProductObject.HelpTelephone
            'InstallDate'       = $ProductObject.InstallDate
            'InstallDate2'      = $ProductObject.InstallDate2
            'InstallLocation'   = $ProductObject.InstallLocation
            'InstallSource'     = $ProductObject.InstallSource
            'Language'          = $ProductObject.Language
            'LocalPackage'      = $ProductObject.LocalPackage
            'PackageCache'      = $ProductObject.PackageCache
            'PackageCode'       = $ProductObject.PackageCode
            'PackageName'       = $ProductObject.PackageName
            'ProductID'         = $ProductObject.ProductID
            'RegCompany'        = $ProductObject.RegCompany
            'RegOwner'          = $ProductObject.RegOwner
            'Transforms'        = $ProductObject.Transforms
            'URLInfoAbout'      = $ProductObject.URLInfoAbout
            'URLUpdateInfo'     = $ProductObject.URLUpdateInfo
            'WordCount'         = $ProductObject.WordCount
            'PSComputerName'    = $ProductObject.PSComputerName
        }

        $Output = New-Object -TypeName PSObject -Property $Properties
        Write-Output $Output
    }
}
