param (
    <#
    [ValidateScript({
        if ( -not ( $_ | Test-Path ) ) {
            throw "File or folder does not exist"
        }
        if ( -not ( $_ | Test-Path -PathType Leaf ) ) {
            throw "The Path argument must be a file. Folder paths are not allowed."
        }
        if ( -not ( $_ -notmatch "(\.csv)" ) ) {
            throw "The file specified in the path argument must be a csv"
        }
        return $true
    })]#>
    [string[]]$Path,
    [ValidateSet("QR", "OptIn", "Survey")]
    [string]$ListSource,
    [int]$MaxEntries = 13
)

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

function Get-RSSRaffleLists {
    [CmdletBinding()]
    param (
        [string[]]$Path,
        [int]$MaxEntries,
        [string]$ListSource
    )

    begin {
        $workingList = foreach ( $file in $Path ) {
            $temp = import-csv -Path $file
            foreach ( $item in $temp ) {
                switch ( $ListSource ) {
                    'QR' {
                        if ( $item.'Survey Content Type' -eq "menu item" -and ( IsValidEmail -EmailAddress $item.'2. Email - Free Response' ) ) {
                            $properties = @{
                                'name'  = $item.'1. Name - Free Response'
                                'email' = $item.'2. Email - Free Response'
                            }
                            $output = New-Object -TypeName PSObject -Property $properties
                            Write-Output $output
                        }
                    }
                    'OptIn' {
                        if ( $item.'Ticket Type' -and ( IsValidEmail -EmailAddress $item.'Attendee Email' ) ) {
                            $properties = @{
                                'name'  = $item.'Attendee First Name' + " " + $item.'Attendee Last Name' + " ( " + $item.'Organization' + " )"
                                'email' = $item.'Attendee Email'
                            }
                            $output = New-Object -TypeName PSObject -Property $properties
                            Write-Output $output
                        }
                    }
                    'Survey' {
                        if ( $item.'Survey Content Type' -eq "session" -and ( IsValidEmail -EmailAddress $item.'2. Your e-mail - Required to verify raffle entry - Free Response' ) ) {
                            $properties = @{
                                'name'  = $item.'1. Your name - Required to be entered into raffle - Free Response'
                                'email' = $item.'2. Your e-mail - Required to verify raffle entry - Free Response'
                            }
                            $output = New-Object -TypeName PSObject -Property $properties
                            Write-Output $output
                        }
                    }
                }
            }

        }
    }

    process {

        if ( $ListSource -eq 'Survey' ) {
            <#
            Setting up a hash table of unique entries - email addresses and the count with a max total.
            This may be over processing
            #>

            # Adam Bertram 24 July 2019 https://adamtheautomator.com/powershell-group-object/

            $entryCountTemp = $WorkingList | Group-Object -Property email
            $entryCount = @{}

          foreach ( $item in $entryCountTemp ) {
                if ( $item.count -gt $maxEntries ) {
                    $countTemp = $maxEntries
                }
                else {
                    $countTemp = $item.count
                }
                $entryCount.Add( $item.name, $countTemp )
            }

            $finalList = foreach ( $listItem in $WorkingList ) {
                [int]$counter = $entryCount.Get_Item( $listItem.email )

                if ( $counter -gt 0 ) {

                    Write-Output $listItem

                }

                $counter = $counter - 1

                $entryCount.Set_Item( $listItem.email, $counter )
            }
          $workingList = $finalList

        }




    }

    end {
        Write-Output $workingList
    }
}

Get-RSSRaffleLists -Path $Path -ListSource $ListSource -MaxEntries $MaxEntries