
<#
    Get Event Log Info
    Get start/stop info for a computer - System Log 6006 and 6005
#>

$date = get-date ((get-date) - (New-TimeSpan -Days 1)) -Hour 7 -Minute 0 -Second 0

$EventLogs = Get-WinEvent -ListLog * | Where-Object {$_.recordcount -and $_.LastWriteTime -ge $date}


foreach ($eventlog in $EventLogs ) {

    $FilterHashTable = @{
        'LogName'   = $EventLog.LogName
        'starttime' = $date
        'level'     = 1, 2, 3
    }

    $Logs = get-winevent -FilterHashtable $FilterHashTable 

    foreach ( $Log in $Logs ) {

        $Properties = @{
            'Message'              = $Log.Message
            'Id'                   = $Log.Id
            'TimeCreated'          = $Log.TimeCreated
            'Level'                = $Log.Level
            'ProviderName'         = $Log.ProviderName
            'LogName'              = $Log.LogName
            'MachineName'          = $Log.MachineName
            'UserId'               = $Log.UserId
            'LevelDisplayName'     = $Log.LevelDisplayName
            'OpcodeDisplayName'    = $Log.OpcodeDisplayName
            'KeywordsDisplayNames' = $Log.KeywordsDisplayNames -join " | "
            'Properties'           = $Log.Properties.value -join " | "

        }

        $Output = New-Object -TypeName PSObject -Property $Properties
        Write-Output $Output
        Export-csv -InputObject $Output -Path "$pwd\eventlogs$(get-date -Format filedate).csv" -NoTypeInformation -Append

    }

}