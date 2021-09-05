<#
    Get Event Log Info
    Get start/stop info for a computer - System Log 6006 and 6005
#>

$FilterHashTable = @{
    'logname'      = 'system'
    'providername' = 'eventlog'
    #'id'           = 6005,6006
    'id' = 1074
}

$EventLogs = get-winevent -FilterHashtable $FilterHashTable 

foreach ( $EventLog in $EventLogs ) {

    $Properties = @{
        'message' = $EventLog.message
        'id' = $EventLog.id
        'timecreated' = $EventLog.timecreated
    }

    $Output = New-Object -TypeName PSObject -Property $Properties
    Write-Output $Output

}
