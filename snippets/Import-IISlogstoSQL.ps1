# FileName: Import-IISLogsToSQL.ps1
# Date: 2/16/2012
# Version: 1.0
# Author: Chris Weaver
# Usage: .\Import-IISLogsToSQL.ps1
#
# Description of Script
# 	The script will import IIS logs into a SQL DB.
#
# This script has been tested on Windows 2008 and Windows 2008 R2 with SQL 2005 SP3, SQL 2008, and SQL 2008 R2 with that being said 
# here is the Legal disclaimer:
#
# This Sample Code is provided for the purpose of illustration only and is not intended to be used in a production environment.  
# THIS SAMPLE CODE AND ANY RELATED INFORMATION ARE PROVIDED "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED 
# TO THE IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS for A PARTICULAR PURPOSE.  We grant You a nonexclusive, royalty-free right to use and modify 
# the Sample Code and to reproduce and distribute the object code form of the Sample Code, provided that You agree: (i) to not use Our name, logo, or 
# trademarks to market Your software product in which the Sample Code is embedded; (ii) to include a valid copyright notice on Your software product in 
# which the Sample Code is embedded; and (iii) to indemnify, hold harmless, and defend Us and Our suppliers from and against any claims or lawsuits, 
# including attorneys� fees, that arise or result from the use or distribution of the Sample Code.

# Useful articles
#	http://support.microsoft.com/kb/296085
#	http://www.powershell.nu/2009/01/26/sql-through-powershell/
#	http://technet.microsoft.com/en-us/library/bb742398.aspx

function Create_Database
{
	param($SQLSvr, [string]$DatabaseName, [string]$DBServer)

	foreach($db in $SQLSvr.Databases) # Check to see if our Database exists
	{
		if($db.Name -eq $DatabaseName)
		{
			return $db
		}
	}
	$db = New-Object Microsoft.SqlServer.Management.Smo.Database($SQLSvr, $DatabaseName)
	$db.Create()
	return $db
}

#
# Function Create_Table is dependant on function Database_ExecuteNonQuery_Command
#
function Create_Table
{
	param($DB, [string]$TableName)

	$TableScript = New-Object -Type System.Collections.Specialized.StringCollection
	$TableScript.Add("CREATE TABLE [dbo].[$TableName] ([date] [datetime] NULL,[time] [datetime] NULL ,[s-sitename] [varchar] (255) NULL,[s-computername] [varchar] (255) NULL ,[s-ip] [varchar] (50) NULL ,[cs-method] [varchar] (50) NULL ,[cs-uri-stem] [varchar] (512) NULL ,[cs-uri-query] [varchar] (2048) NULL ,[s-port] [varchar] (255) NULL ,[cs-username] [varchar] (255) NULL ,[c-ip] [varchar] (255) NULL ,[cs-version] [varchar] (255) NULL ,[cs(User-Agent)] [varchar] (512) NULL ,[cs(Cookie)] [varchar] (4096) NULL ,[cs(Referer)] [varchar] (2048) NULL,[cs-host] [varchar] (255) NULL ,[sc-status] [int] NULL ,[sc-substatus] [varchar] (255) NULL,[sc-win32-status] [varchar] (255) NULL,[sc-bytes] [int] NULL ,[cs-bytes] [varchar] (255) NULL ,[time-taken] [int] NULL)") | Out-Null
	Database_ExecuteNonQuery_Command $DB $TableScript #Create Table
}

function Database_ExecuteNonQuery_Command
{
	param($SQLDataBase, $CommandScript)
	$Error.Clear()
	$ExecutionType = [Microsoft.SqlServer.Management.Common.ExecutionTypes]::ContinueOnError
	$SQLDataBase.ExecuteNonQuery($CommandScript, $ExecutionType)
	
	trap {Write-Host "[ERROR]: $_"; continue}
}

function Clean_Log_File
{
	param ($LogFile)
	$Content = Get-Content $LogFile.FullName | Select-String -Pattern "^#" -notmatch
	Set-Content $LogFile.FullName $Content
}

# Main

[String]$DatabaseServer = "christwe1\SQLEXPRESS" #Should be servername and instance
[String]$DatabaseName = "LogFileData"
[String]$FullPathtoParentFolder = "C:\Temp\Files"

if($DatabaseServer -like "*\*")
{
	$a = $DatabaseServer.Split("\")
	$DatabaseMachine = $a[0]
}
else
{
	$DatabaseMachine = $DatabaseServer
}

if(!(Test-Connection -ComputerName $DatabaseMachine -Count 3 -ea SilentlyContinue))
{
	Write-Host "Cannot connect to SQL server"
	exit
}

if(!(Test-Path -Path $FullPathtoParentFolder -PathType Container))
{
	Write-Host "Path is invalid"
}
else
{
	#Load all necessary DLL's
	try {add-type -AssemblyName "Microsoft.SqlServer.Smo, Version=10.0.0.0, Culture=neutral, PublicKeyToken=89845dcd8080cc91" -EA Stop; $smoVersion = 10}
	catch {add-type -AssemblyName "Microsoft.SqlServer.Smo"; $smoVersion = 9}

	$SQLServer = New-Object Microsoft.SqlServer.Management.Smo.Server $DatabaseServer #Connect to SQL Server and create object
	$Database = Create_Database $SQLServer $DatabaseName $DatabaseServer	#Create Database and retrieve object

	$WebApplications = Get-ChildItem -Path $FullPathtoParentFolder	# Connect to File System
	foreach($WebApplication in $WebApplications)
	{
		[string]$TableName = $WebApplication.Name
		Create_Table $Database $TableName
		$LogFiles = Get-ChildItem -Recurse $WebApplication.FullName | Where-Object {!$_.PSIsContainer}	#Get all log files to be inserted into Table
	
		foreach($LogFile in $LogFiles)
		{
			if($LogFile.extension -ne ".old")	#Skip old files that have already been added to table
			{
				Clean_Log_File $LogFile
				$File = $LogFile.FullName
				$LineScript = New-Object -Type System.Collections.Specialized.StringCollection					
				$LineScript.Add("BULK INSERT $Database.[dbo].[$TableName] FROM `"$File`" WITH (BATCHSIZE = 10,FIRSTROW = 1,FIELDTERMINATOR = ' ', ROWTERMINATOR = '\n')") | Out-Null
				Database_ExecuteNonQuery_Command $Database $LineScript
				Rename-Item $File (($LogFile.FullName).TrimEnd($LogFile.extension) + ".old")	#Insure we don't add contents of file to table again
			}
		}
	}
}
