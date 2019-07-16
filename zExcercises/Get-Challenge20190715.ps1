<#
Posted 15 July 2019
https://ironscripter.us/powershell-beginners-have-to-start-somewhere/

POWERSHELL BEGINNERS HAVE TO START SOMEWHERE
As promised, the Chairman is offering up the following challenge for PowerShell
beginners.

Get all files in a given folder including subfolders and display a result that
shows the total number of files, the total size of all files, the average file
size, the computer name, and the date when you ran the command.

This should not be written as a script or function. It should be one or two 
lines of PowerShell that you would type at the console to generate the desired
result.

The Chairman would like to stress that this is a challenge targeted for PowerShell
beginners. No doubt many readers could solve this in seconds. But for someone
just getting started with PowerShell, this is more difficult than you might think.
Try to remember how much you knew when you were first starting out. If you know
someone in the early stages of learning PowerShell, encourage them to try this
challenge.

Please don’t submit any solutions as comments. They will not be approved. This
isn’t a competition. You are welcome to share links to your work.

Even if you are more advanced, you are encouraged to jot down your solution.
Upcoming challenges will be building on this and they will increase in difficulty.

Solution 16 July 2019
#>

# Nicely Formated
Get-ChildItem -Recurse -File | Measure-Object -Property length -Sum -Average | 
Select-Object @{Name = 'Computer Name'; Expression = { $env:COMPUTERNAME } },
@{Name = 'Date'; Expression = { get-date } },
@{Name = 'Files'; Expression = { "{0:N0}" -f $_.Count } },
@{Name = 'Total Size (GB)'; Expression = { "{0:N2}" -f ($_.Sum / 1GB) } },
@{Name = 'Average Size (MB)'; Expression = { "{0:N2}" -f ($_.average / 1MB) } }



# Just get 'er done
Write-Output "Computer: $env:COMPUTERNAME`r`nDate: $(get-date)"
gci -Recurse -file | measure -property Length -Sum -Average