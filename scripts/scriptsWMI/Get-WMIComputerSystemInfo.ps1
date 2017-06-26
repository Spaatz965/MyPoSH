<#
    Computer System - Win32_ComputerSystem
    Windows Management Interface Data
    For PowerShell 2.0, use Get-WMIObject
    For PowerShell 3.0 and newer, use Get-CIMInstance
    $ComputerNames should be a list of computer names
#>

$ComputerNames = @(
    "LocalHost"
)

foreach ( $ComputerName in $ComputerNames ) {

    #$CompSystemObject = Get-WMIObject -Class Win32_ComputerSystem -ComputerName $ComputerName
    $CompSystemObjects = Get-CIMInstance -ClassName Win32_ComputerSystem -ComputerName $ComputerName
    foreach ( $CompSystemObject in $CompSystemObjects ) {

        $Properties = @{
            'BootupState'                 = $CompSystemObject.BootupState
            'Status'                      = $CompSystemObject.Status
            'Name'                        = $CompSystemObject.Name
            'PowerManagementCapabilities' = $CompSystemObject.PowerManagementCapabilities
            'PowerManagementSupported'    = $CompSystemObject.PowerManagementSupported
            'Caption'                     = $CompSystemObject.Caption
            'Description'                 = $CompSystemObject.Description
            'InstallDate'                 = $CompSystemObject.InstallDate
            'NameFormat'                  = $CompSystemObject.NameFormat
            'PrimaryOwnerContact'         = $CompSystemObject.PrimaryOwnerContact
            'PrimaryOwnerName'            = $CompSystemObject.PrimaryOwnerName
            'Roles'                       = $CompSystemObject.Roles -join "; "
            'ResetCapability'             = $CompSystemObject.ResetCapability
            'AutomaticManagedPagefile'    = $CompSystemObject.AutomaticManagedPagefile
            'AutomaticResetBootOption'    = $CompSystemObject.AutomaticResetBootOption
            'AutomaticResetCapability'    = $CompSystemObject.AutomaticResetCapability
            'BootOptionOnLimit'           = $CompSystemObject.BootOptionOnLimit
            'BootOptionOnWatchDog'        = $CompSystemObject.BootOptionOnWatchDog
            'BootROMSupported'            = $CompSystemObject.BootROMSupported
            'ChassisSKUNumber'            = $CompSystemObject.ChassisSKUNumber
            'CurrentUTCOffset'            = $CompSystemObject.CurrentTimeZone / 60
            'DaylightInEffect'            = $CompSystemObject.DaylightInEffect
            'DNSHostName'                 = $CompSystemObject.DNSHostName
            'Domain'                      = $CompSystemObject.Domain
            'DomainRole'                  = $CompSystemObject.DomainRole
            'EnableDaylightSavingsTime'   = $CompSystemObject.EnableDaylightSavingsTime
            'HypervisorPresent'           = $CompSystemObject.HypervisorPresent
            'InfraredSupported'           = $CompSystemObject.InfraredSupported
            'Manufacturer'                = $CompSystemObject.Manufacturer
            'Model'                       = $CompSystemObject.Model
            'NetworkServerModeEnabled'    = $CompSystemObject.NetworkServerModeEnabled
            'NumberOfLogicalProcessors'   = $CompSystemObject.NumberOfLogicalProcessors
            'NumberOfProcessors'          = $CompSystemObject.NumberOfProcessors
            'OEMStringArray'              = $CompSystemObject.OEMStringArray -join "; "
            'PartOfDomain'                = $CompSystemObject.PartOfDomain
            'SupportContactDescription'   = $CompSystemObject.SupportContactDescription
            'SystemFamily'                = $CompSystemObject.SystemFamily
            'SystemSKUNumber'             = $CompSystemObject.SystemSKUNumber
            'SystemStartupDelay'          = $CompSystemObject.SystemStartupDelay
            'SystemStartupOptions'        = $CompSystemObject.SystemStartupOptions
            'SystemStartupSetting'        = $CompSystemObject.SystemStartupSetting
            'SystemType'                  = $CompSystemObject.SystemType
            'TotalPhysicalMemory'         = $CompSystemObject.TotalPhysicalMemory
            'TotalPhysicalMemory (GB)'    = "{0:N2}" -f ($CompSystemObject.TotalPhysicalMemory / 1gb)
            'WakeUpType'                  = $CompSystemObject.WakeUpType
            'Workgroup'                   = $CompSystemObject.Workgroup
        }

        $Output = New-Object -TypeName PSObject -Property $Properties
        Write-Output $Output
    }
}

