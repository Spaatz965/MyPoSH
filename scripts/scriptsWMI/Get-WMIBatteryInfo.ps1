<#
    Battery Status - Win32_Battery
    See https://msdn.microsoft.com/en-us/library/aa394074(v=vs.85).aspx for details
    Windows Management Interface Data
    For PowerShell 2.0, use Get-WMIObject
    For PowerShell 3.0 and newer, use Get-CIMInstance
    $ComputerNames should be a list of computer names
#>

$ComputerNames = @(
    "LocalHost"
)

foreach ( $ComputerName in $ComputerNames ) {

    #$BatteryObject = Get-WMIObject -Class Win32_QuickFixEngineering -ComputerName $ComputerName
    $BatteryObjects = Get-CIMInstance -ClassName Win32_battery -ComputerName $ComputerName
    foreach ( $BatteryObject in $BatteryObjects ) {

        $Properties = @{
            'Caption'                  = $BatteryObject.Caption
            'Description'              = $BatteryObject.Description
            'Name'                     = $BatteryObject.Name
            'Status'                   = $BatteryObject.Status
            'Availability'             = Switch ($BatteryObject.Availability) {
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
            'ConfigManagerErrorCode'   = $BatteryObject.ConfigManagerErrorCode
            'ConfigManagerUserConfig'  = $BatteryObject.ConfigManagerUserConfig
            'DeviceID'                 = $BatteryObject.DeviceID
            'ErrorCleared'             = $BatteryObject.ErrorCleared
            'ErrorDescription'         = $BatteryObject.ErrorDescription
            'LastErrorCode'            = $BatteryObject.LastErrorCode
            'SystemName'               = $BatteryObject.SystemName
            'BatteryStatus'            = switch ($BatteryObject.BatteryStatus) {
                                            1 {"Other. The battery is discharging."}
                                            2 {"Unknown. The system has access to AC so no battery is being discharged. However, the battery is not necessarily charging."}
                                            3 {"Fully Charged"}
                                            4 {"Low"}
                                            5 {"Critical"}
                                            6 {"Charging"}
                                            7 {"Charging and High"}
                                            8 {"Charging and Low"}
                                            9 {"Charging and Critical"}
                                            10 {"Undefined"}
                                            11 {"Partially Charged"}
                                        }
            'Chemistry'                = switch ($BatteryObject.Chemistry) {
                                            1 {"Other"}
                                            2 {"Unknown"}
                                            3 {"Lead Acid"}
                                            4 {"Nickel Cadmium"}
                                            5 {"Nickel Metal Hydride"}
                                            6 {"Lithium-ion"}
                                            7 {"Zinc air"}
                                            8 {"Lithium Polymer"}
                                        }
            'DesignCapacity'           = $BatteryObject.DesignCapacity
            'DesignVoltage'            = $BatteryObject.DesignVoltage
            'EstimatedChargeRemaining' = $BatteryObject.EstimatedChargeRemaining
            'EstimatedRunTime'         = $BatteryObject.EstimatedRunTime
            'ExpectedLife'             = $BatteryObject.ExpectedLife
            'FullChargeCapacity'       = $BatteryObject.FullChargeCapacity
            'MaxRechargeTime'          = $BatteryObject.MaxRechargeTime
            'SmartBatteryVersion'      = $BatteryObject.SmartBatteryVersion
            'TimeOnBattery'            = $BatteryObject.TimeOnBattery
            'TimeToFullCharge'         = $BatteryObject.TimeToFullCharge
            'ExpectedBatteryLife'      = $BatteryObject.ExpectedBatteryLife
        }

        $Output = New-Object -TypeName PSObject -Property $Properties
        Write-Output $Output
    }
}
