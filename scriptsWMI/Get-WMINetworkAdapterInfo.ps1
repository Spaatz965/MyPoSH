<#
    Network Adapter - Win32_NetworkAdapter
    See https://msdn.microsoft.com/en-us/library/aa394216(v=vs.85).aspx for details
    Windows Management Interface Data
    For PowerShell 2.0, use Get-WMIObject
    For PowerShell 3.0 and newer, use Get-CIMInstance
    $ComputerNames should be a list of computer names
#>

$ComputerNames = @(
    "LocalHost"
)

foreach ( $ComputerName in $ComputerNames ) {

    $NetAdpaterObjects = Get-CIMInstance -ClassName Win32_NetworkAdapter -ComputerName $ComputerName -Filter "AdapterType LIKE '%'"
    foreach ( $NetAdpaterObject in $NetAdpaterObjects ) {

        $Properties = @{
            'Availability'                = Switch ( $NetAdpaterObject.Availability ) {
                                                1 {"Other"}
                                                2 {"Unknown"}
                                                3 {"Running/Full Power"}
                                                4 {"Warning"}
                                                5 {"In Test"}
                                                6 {"Not Applicable"}
                                                7 {"Power Off"}
                                                8 {"Off Line"}
                                                9 {"Off Duty"}
                                                10 {"Degraded"}
                                                11 {"Not Installed"}
                                                12 {"Install Error"}
                                                13 {"Power Save - Unknown"}
                                                14 {"Power Save - Low Power Mode"}
                                                15 {"Power Save - Standby"}
                                                16 {"Power Cycle"}
                                                17 {"Power Save - Warning"}
                                                18 {"Paused"}
                                                19 {"Not Ready"}
                                                20 {"Not Configured"}
                                                21 {"Quiesced"}
                                                default {"Status could not be determined"}
                                            }
            'Name'                        = $NetAdpaterObject.Name
            'Status'                      = $NetAdpaterObject.Status
            'StatusInfo'                  = Switch ( $NetAdpaterObject.StatusInfo ) {
                                                1 {"Other"}
                                                2 {"Unknown"}
                                                3 {"Enabled"}
                                                4 {"Disabled"}
                                                5 {"Not Applicable"}
                                            }
            'DeviceID'                    = $NetAdpaterObject.DeviceID
            'Caption'                     = $NetAdpaterObject.Caption
            'Description'                 = $NetAdpaterObject.Description
            'InstallDate'                 = $NetAdpaterObject.InstallDate
            'ConfigManagerErrorCode'      = Switch ( $NetAdpaterObject.ConfigManagerErrorCode ) {
                                                0 {"This device is working properly."}
                                                1 {"This device is not configured correctly."}
                                                2 {"Windows cannot load the driver for this device."}
                                                3 {"The driver for this device might be corrupted, or your system may be running low on memory or other resources."}
                                                4 {"This device is not working properly. One of its drivers or your registry might be corrupted."}
                                                5 {"The driver for this device needs a resource that Windows cannot manage."}
                                                6 {"The boot configuration for this device conflicts with other devices."}
                                                7 {"Cannot filter."}
                                                8 {"The driver loader for the device is missing."}
                                                9 {"This device is not working properly because the controlling firmware is reporting the resources for the device incorrectly."}
                                                10 {"This device cannot start."}
                                                11 {"This device failed."}
                                                12 {"This device cannot find enough free resources that it can use."}
                                                13 {"Windows cannot verify this device's resources."}
                                                14 {"This device cannot work properly until you restart your computer."}
                                                15 {"This device is not working properly because there is probably a re-enumeration problem."}
                                                16 {"Windows cannot identify all the resources this device uses."}
                                                17 {"This device is asking for an unknown resource type."}
                                                18 {"Reinstall the drivers for this device."}
                                                19 {"Failure using the VxD loader."}
                                                20 {"Your registry might be corrupted."}
                                                21 {"System failure: Try changing the driver for this device. If that does not work, see your hardware documentation. Windows is removing this device."}
                                                22 {"This device is disabled."}
                                                23 {"System failure: Try changing the driver for this device. If that doesn't work, see your hardware documentation."}
                                                24 {"This device is not present, is not working properly, or does not have all its drivers installed."}
                                                25 {"Windows is still setting up this device."}
                                                26 {"Windows is still setting up this device."}
                                                27 {"This device does not have valid log configuration."}
                                                28 {"The drivers for this device are not installed."}
                                                29 {"This device is disabled because the firmware of the device did not give it the required resources."}
                                                30 {"This device is using an Interrupt Request (IRQ) resource that another device is using."}
                                                31 {"This device is not working properly because Windows cannot load the drivers required for this device."}
                                            }
            'ErrorCleared'                = $NetAdpaterObject.ErrorCleared
            'ErrorDescription'            = $NetAdpaterObject.ErrorDescription
            'LastErrorCode'               = $NetAdpaterObject.LastErrorCode
            'PowerManagementCapabilities' = $NetAdpaterObject.PowerManagementCapabilities
            'PowerManagementSupported'    = $NetAdpaterObject.PowerManagementSupported
            'SystemName'                  = $NetAdpaterObject.SystemName
            'AutoSense'                   = $NetAdpaterObject.AutoSense
            'MaxSpeed'                    = $NetAdpaterObject.MaxSpeed
            'NetworkAddresses'            = $NetAdpaterObject.NetworkAddresses
            'PermanentAddress'            = $NetAdpaterObject.PermanentAddress
            'Speed'                       = $NetAdpaterObject.Speed
            'AdapterType'                 = $NetAdpaterObject.AdapterType
            'AdapterTypeId'               = $NetAdpaterObject.AdapterTypeId
            'Index'                       = $NetAdpaterObject.Index
            'InterfaceIndex'              = $NetAdpaterObject.InterfaceIndex
            'MACAddress'                  = $NetAdpaterObject.MACAddress
            'Manufacturer'                = $NetAdpaterObject.Manufacturer
            'MaxNumberControlled'         = $NetAdpaterObject.MaxNumberControlled
            'NetConnectionID'             = $NetAdpaterObject.NetConnectionID
            'NetConnectionStatus'         = Switch ( $NetAdpaterObject.NetConnectionStatus ) {
                                                0 {"Disconnected"}
                                                1 {"Connecting"}
                                                2 {"Connected"}
                                                3 {"Disconnecting"}
                                                4 {"Hardware Not Present"}
                                                5 {"Hardware Disabled"}
                                                6 {"Hardware Malfunction"}
                                                7 {"Media Disconnected"}
                                                8 {"Authenticating"}
                                                9 {"Authentication Succeeded"}
                                                10 {"Authentication Failed"}
                                                11 {"Invalid Address"}
                                                12 {"Credentials Required"}
                                            }
            'NetEnabled'                  = $NetAdpaterObject.NetEnabled
            'PhysicalAdapter'             = $NetAdpaterObject.PhysicalAdapter
            'ProductName'                 = $NetAdpaterObject.ProductName
            'ServiceName'                 = $NetAdpaterObject.ServiceName
            'TimeOfLastReset'             = $NetAdpaterObject.TimeOfLastReset
        }

        $Output = New-Object -TypeName PSObject -Property $Properties
        Write-Output $Output
    }
}
