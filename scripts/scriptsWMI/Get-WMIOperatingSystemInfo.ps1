<#
    Operating System Data - Win32_OperatingSystem
    Windows Management Interface Data
    For PowerShell 2.0, use Get-WMIObject
    For PowerShell 3.0 and newer, use Get-CIMInstance
    $ComputerNames should be a list of computer names
#>

$ComputerNames = @(
    "LocalHost"
)

foreach ( $ComputerName in $ComputerNames ) {

    #$OSObject = Get-WMIObject -Class Win32_OperatingSystem -ComputerName $ComputerName
    $OSObjects = Get-CIMInstance -ClassName CIM_OperatingSystem -ComputerName $ComputerName
    foreach ( $OSObject in $OSObjects ) {

        $Properties = @{
            'Status'                     = $OSObject.Status
            'Name'                       = $OSObject.Name
            'FreePhysicalMemory'         = $OSObject.FreePhysicalMemory
            'FreeSpaceInPagingFiles'     = $OSObject.FreeSpaceInPagingFiles
            'FreeVirtualMemory'          = $OSObject.FreeVirtualMemory
            'Caption'                    = $OSObject.Caption
            'Description'                = $OSObject.Description
            'InstallDate'                = $OSObject.InstallDate
            'CSName'                     = $OSObject.CSName
            'CurrentUTCOffset'           = $OSObject.CurrentTimeZone / 60
            'Distributed'                = $OSObject.Distributed
            'LastBootUpTime'             = $OSObject.LastBootUpTime
            'LocalDateTime'              = $OSObject.LocalDateTime
            'NumberOfUsers'              = $OSObject.NumberOfUsers
            'TotalVirtualMemorySize'     = $OSObject.TotalVirtualMemorySize
            'TotalVisibleMemorySize'     = $OSObject.TotalVisibleMemorySize
            'Version'                    = $OSObject.Version
            'BootDevice'                 = $OSObject.BootDevice
            'BuildNumber'                = $OSObject.BuildNumber
            'BuildType'                  = $OSObject.BuildType
            'CodeSet'                    = $OSObject.CodeSet
            'CountryCode'                = $OSObject.CountryCode
            'Debug'                      = $OSObject.Debug
            'EncryptionLevel'            = $OSObject.EncryptionLevel
            'ForegroundApplicationBoost' = $OSObject.ForegroundApplicationBoost
            'Locale'                     = $OSObject.Locale
            'Manufacturer'               = $OSObject.Manufacturer
            'MUILanguages'               = $OSObject.MUILanguages -join ";"
            'OperatingSystemSKU'         = $OSObject.OperatingSystemSKU
            'Organization'               = $OSObject.Organization
            'OSArchitecture'             = $OSObject.OSArchitecture
            'OSLanguage'                 = $OSObject.OSLanguage
            'OSProductSuite'             = $OSObject.OSProductSuite
            'PortableOperatingSystem'    = $OSObject.PortableOperatingSystem
            'Primary'                    = $OSObject.Primary
            'ProductType'                = $OSObject.ProductType
            'RegisteredUser'             = $OSObject.RegisteredUser
            'SerialNumber'               = $OSObject.SerialNumber
            'ServicePackMajorVersion'    = $OSObject.ServicePackMajorVersion
            'ServicePackMinorVersion'    = $OSObject.ServicePackMinorVersion
            'SuiteMask'                  = $OSObject.SuiteMask
            'SystemDevice'               = $OSObject.SystemDevice
            'SystemDirectory'            = $OSObject.SystemDirectory
            'SystemDrive'                = $OSObject.SystemDrive
            'WindowsDirectory'           = $OSObject.WindowsDirectory
        }

        $Output = New-Object -TypeName PSObject -Property $Properties
        Write-Output $Output
    }
}