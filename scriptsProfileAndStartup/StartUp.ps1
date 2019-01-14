<#
.SYNOPSIS
Startup script for Mark Christman's work computer

.DESCRIPTION
STartup Script to run via timer job upon logon. Runs Outlook, One Note, and FooBar2000
#>

Start-Sleep -Seconds 30
Start-Process -FilePath 'C:\Program Files (x86)\foobar2000\foobar2000.exe'
Start-Sleep -Seconds 5
Start-Process -FilePath onenote.exe
Start-Sleep -Seconds 30
Start-Process -FilePath outlook.exe
Start-Process -FilePath "$env:localappdata\Wunderlist\Wunderlist.exe"