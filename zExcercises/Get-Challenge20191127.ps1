<#
Posted 27 November 2019
https://ironscripter.us/are-you-listening-to-me/

ARE YOU LISTENING TO ME
The latest challenge from the Iron Scripter Chairman starts with a simple
exercise aimed at PowerShell beginners. It ends with a more complex set of
requirements for advanced PowerShell scripters. In between, you can embellish
and add as much as you feel comfortable doing. The core of the challenge is
based on the Get-NetTCPConnection cmdlet.

The Beginner Challenge
Write a command to display listening and established connections on a computer’s
primary IPv4 address. That is, the IPv4 address other than 0.0.0.0, 127.0.0.1,
and 169.254.*. You should display:

the computer name
the local port and IP address
the remote port and IP address
the connection state
the owning process
when the connection was created.
If you are feeling motivated, add a property that shows the age of the connection
You can manually specify the local IP address if you know it. Although it would
be better to use another command to retrieve the address.

This is not a one-line challenge. Nor does it really need to be a script. Use as
many commands as you need to achieve the task. Once you have that, then you
might see if you can turn it into a parameterized script that lets you specify a
computer name.

The Advanced Challenge
For those of you with more PowerShell experience, your challenge is based on the
requirements outlined above. However, you should create an advanced function
that allows you to easily query one or more remote computers. Your output should
include everything from the beginner challenge plus:

the account associated with the owning process
the path to the associated application
It is expected that you will programmatically discover the appropriate IPv4
address(es). As a bonus, create a formatted table view of your results grouped
by computer name. You might need to shorten up some of the headings.

For very experienced PowerShell scripters, there a number of features you could
add to your code.

Assuming you are using PowerShell remoting, filter out your connection to the
remote server
Add a property with a text note about the local port such as DNS or FTP
Add an optional parameter to attempt to resolve the remote IP addresses to host names
Create a formatted view with data grouped by local port or remote address

Tips and Suggestions
It should be obvious, but sometimes people need reminders — read full cmdlet
help and examples. Be aware that some values may be empty, which is fine. There
is no expectation that you are creating a one-line solution. You should leverage
the pipeline but there’s no need to get crazy about it.

As always, the Chairman hopes you will post comments with links to your
solutions and work.
#>