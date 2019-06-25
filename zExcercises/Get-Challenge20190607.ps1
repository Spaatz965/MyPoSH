<#
Posted 7 June 2019
https://ironscripter.us/let-the-powershell-challenges-begin/

LET THE POWERSHELL CHALLENGES BEGIN
string playThe Chairman has decided that it is in the best interests of his Iron
Scripters, and those that wish to attain that valued designation, that training
continue year-round. To that end, he has commissioned a series of PowerShell
challenges. These challenges will range in complexity and be tagged accordingly.
Although, you are encouraged to try your hand at all posted challenges. Some
solutions may require complex coding, perhaps a PowerShell function. Others might
be no more than a line or two of PowerShell that you would type interactively in
the console. You are encouraged to share your work in social media, blogs, or
sites like GitHub.  You are welcome to post links to your work in comments to
each challenge. Shall we begin?

For your first challenge exercise, consider these two arrays of strings.

$target = "Spooler", "Spork Client", "WinRM", "Spork Agent Service", "BITS", "WSearch"
$list = "winrm", "foo", "spooler", "spor*", "bar"

Your goal is to find the values in $List that do not match anything in $Target.
Your code will be successful if you get foo and bar for results. This exercise is
classified with an Intermediate level.

Good Luck and check back later for a suggested solution.

Solution 11 June 2019
#>

$target = "Spooler", "Spork Client", "WinRM", "Spork Agent Service", "BITS", "WSearch"
$list = "winrm", "foo", "spooler", "spor*", "bar"

# Original Response

foreach ( $item in $list ) {

    $compare = $target | Where-Object { $_ -like $item }

    if ( $null -eq $compare ) { Write-Output "$item" }

}

# Solution from PS Users Group

foreach ( $item in $list ) {

    if ( -not ( $target -like $item )) { write-output $item }

}


# Favorite answer from the challenge comments

$list | Where-Object { -not ( $target -like $_ )}