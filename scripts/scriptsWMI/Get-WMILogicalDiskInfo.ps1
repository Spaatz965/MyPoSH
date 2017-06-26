<#
    Logical Disk - Win32_LogicalDisk
    Windows Management Interface Data
    For PowerShell 2.0, use Get-WMIObject
    For PowerShell 3.0 and newer, use Get-CIMInstance
    $ComputerNames should be a list of computer names
#>

$ComputerNames = @(
    "LocalHost"
)

foreach ( $ComputerName in $ComputerNames ) {

    #Disk$Object = Get-WMIObject -Class Win32_LogicalDisk -ComputerName $ComputerName
    $DiskObjects = Get-CIMInstance -ClassName Win32_LogicalDisk -ComputerName $ComputerName
    foreach ( $DiskObject in $DiskObjects ) {

        $Properties = @{
            'Status'                       = $Diskobject.Status
            'Availability'                 = $Diskobject.Availability
            'DeviceID'                     = $Diskobject.DeviceID
            'StatusInfo'                   = $Diskobject.StatusInfo
            'Description'                  = $Diskobject.Description
            'ErrorCleared'                 = $Diskobject.ErrorCleared
            'ErrorDescription'             = $Diskobject.ErrorDescription
            'LastErrorCode'                = $Diskobject.LastErrorCode
            'PNPDeviceID'                  = $Diskobject.PNPDeviceID
            'PowerManagementCapabilities'  = $Diskobject.PowerManagementCapabilities
            'PowerManagementSupported'     = $Diskobject.PowerManagementSupported
            'SystemName'                   = $Diskobject.SystemName
            'FreeSpace'                    = $Diskobject.FreeSpace
            'Size'                         = $Diskobject.Size
            'Compressed'                   = $Diskobject.Compressed
            'DriveType'                    = $Diskobject.DriveType
            'FileSystem'                   = $Diskobject.FileSystem
            'MaximumComponentLength'       = $Diskobject.MaximumComponentLength
            'MediaType'                    = $Diskobject.MediaType
            'SupportsDiskQuotas'           = $Diskobject.SupportsDiskQuotas
            'SupportsFileBasedCompression' = $Diskobject.SupportsFileBasedCompression
            'VolumeDirty'                  = $Diskobject.VolumeDirty
            'VolumeName'                   = $Diskobject.VolumeName
            'VolumeSerialNumber'           = $Diskobject.VolumeSerialNumber
        }

        $Output = New-Object -TypeName PSObject -Property $Properties
        Write-Output $Output
    }
}
