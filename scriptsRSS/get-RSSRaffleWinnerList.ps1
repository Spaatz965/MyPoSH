function IsValidEmail {
    # from Mathias R. Jessen's 14 Jan 2018 response 
    # at https://stackoverflow.com/questions/48253743/powershell-to-validate-email-addresses 

    param([string]$EmailAddress)

    try {
        $null = [mailaddress]$EmailAddress
        return $true
    }
    catch {
        return $false
    }
}


function Get-RSSWorkingList {

    [CmdletBinding()]
    param (
        [string]$filePath,
        [int]$maxEntries = 8
    )

    BEGIN {
        Write-Verbose "[$((get-date).TimeOfDay.ToString()) BEGIN   ] "
        Write-Verbose "[$((get-date).TimeOfDay.ToString()) BEGIN   ] Starting: $($MyInvocation.MyCommand)"
        Write-Verbose "[$((get-date).TimeOfDay.ToString()) BEGIN   ] Execution Metadata:"

        Write-Verbose "[$((get-date).TimeOfDay.ToString()) BEGIN   ] File Path is $filePath"
        Write-Verbose "[$((get-date).TimeOfDay.ToString()) BEGIN   ] maxEntries is $maxEntries"
    
        $fileContent = Get-Content -Path $filePath
        
        if ( $fileContent[0] -match "device") {
            $header = 'DeviceID', 'Name', 'Email'
            $uniqueProperty = 'DeviceID'
        }
        else {
            $header = 'givenName', 'familyName', 'Email'
            $uniqueProperty = 'Email'           
        }
        
        Write-Verbose "[$((get-date).TimeOfDay.ToString()) BEGIN   ] Header is $header"
        Write-Verbose "[$((get-date).TimeOfDay.ToString()) BEGIN   ] uniqueProperty is $uniqueProperty"
        
        $list = ConvertFrom-Csv -InputObject $fileContent -Header $header
    
        Write-Verbose "[$((get-date).TimeOfDay.ToString()) BEGIN   ] List contains $(($list | measure-object).count) items"

    } # BEGIN

    PROCESS {
        Write-Verbose "[$((get-date).TimeOfDay.ToString()) PROCESS ] "


        # Remove invalid entries from the workingset
        # Entries where there is no name or no validly formatted email address
        if ( $uniqueProperty -eq 'DeviceID' ) {
            Write-Verbose "[$((get-date).TimeOfDay.ToString()) PROCESS ] uniqueProperty is DeviceID"

            $workingList = foreach ( $listItem in $list ) {
                if ( IsValidEmail -EmailAddress $listItem.Email ) {
                    Write-Verbose "[$((get-date).TimeOfDay.ToString()) PROCESS ] $($listItem.Email) is a validly formated email address"

                    if ( $null -ne $listItem.Name ) {
                        Write-Verbose "[$((get-date).TimeOfDay.ToString()) PROCESS ] $($listItem.Name) is not null"
                        
                        Write-Output $listItem

                    } else {
                        Write-Verbose "[$((get-date).TimeOfDay.ToString()) PROCESS ] listItem.Name is a null value - $($listItem.Name)"
                    }
                
                } else {
                    Write-Verbose "[$((get-date).TimeOfDay.ToString()) PROCESS ] $($listItem.Email) is NOT a validly formated email address"
                }
            }

        } else {
            Write-Verbose "[$((get-date).TimeOfDay.ToString()) PROCESS ] uniqueProperty is Email"

            $workingList = foreach ( $listItem in $list ) {
                if (IsValidEmail -EmailAddress $listItem.Email) {
                    Write-Verbose "[$((get-date).TimeOfDay.ToString()) PROCESS ] $($listItem.Email) is a validly formated email address"
                    Write-Output $listItem
                
                } else {
                    Write-Verbose "[$((get-date).TimeOfDay.ToString()) PROCESS ] $($listItem.Email) is NOT a validly formated email address"
                }
            }   
        }

        Write-Verbose "[$((get-date).TimeOfDay.ToString()) PROCESS ] Creating the entryCount array"
        # Adam Bertram 24 July 2019 https://adamtheautomator.com/powershell-group-object/

        $entryCountTemp = $WorkingList | Group-Object -Property $uniqueProperty

        $entryCount = @{}

        foreach ( $item in $entryCountTemp) {
            if ( $item.count -gt $maxEntries) {
                $countTemp = $maxEntries
            } else {
                $countTemp = $item.count
            }

            $entryCount.Add($item.name,$countTemp)
        }

        Write-Verbose "[$((get-date).TimeOfDay.ToString()) PROCESS ] entryCount hashtable has $($entryCount.count) objects"

        Write-Verbose "[$((get-date).TimeOfDay.ToString()) PROCESS ] Setting the working list"
        $finalList = foreach ( $listItem in $workingList ){

            [int]$counter = $entryCount.Get_Item($listItem.$uniqueProperty)
            Write-Verbose "[$((get-date).TimeOfDay.ToString()) PROCESS ] counter temporary variable set to $counter"

            Write-Verbose "[$((get-date).TimeOfDay.ToString()) PROCESS ] Evaluating $($listItem.Email)"
            if ( $counter -gt 0 ) {
                Write-Verbose "[$((get-date).TimeOfDay.ToString()) PROCESS ] counter greater than zero - storing item"

                Write-Output $listItem
    
            } else {

                Write-Verbose "[$((get-date).TimeOfDay.ToString()) PROCESS ] counter was less than or equal to zero - item not stored"

            }

            $counter = $counter-1
            Write-Verbose "[$((get-date).TimeOfDay.ToString()) PROCESS ] counter temporary variable decremented to $counter"

            Write-Verbose "[$((get-date).TimeOfDay.ToString()) PROCESS ] updating entryCount to $counter"

            $entryCount.Set_Item($listItem.$uniqueProperty,$counter)

        }

        Write-Verbose "[$((get-date).TimeOfDay.ToString()) PROCESS ] outputting final list"
        Write-Output $finalList

    } # PROCESS

    END {
        Write-Verbose "[$((get-date).TimeOfDay.ToString()) END     ] Ending: $($MyInvocation.Mycommand)"
        Write-Verbose "[$((get-date).TimeOfDay.ToString()) END     ] "

    } # END

} # function Get-RSSWorkingList

#region Function Test Use Cases (Uncomment To Test)

# Call Function with parameters

$myList = Get-RSSWorkingList -Verbose -maxEntries 2
$timestamp = Get-Date -Format o | ForEach-Object { $_ -replace ":", "." }
$myList | Export-Csv -Path "\testoutput$timestamp.csv"

$myList | Get-Random -Count 10

# Call Function via PipeLine

# Call Function via PipeLine By Name

# Call Function with multiple objects in parameter

# Call Function test Error Logging


#endregion

