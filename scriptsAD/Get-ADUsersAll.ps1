<#  
.SYNOPSIS  
    This script queries the  Active Directory for all Users.
    
.DESCRIPTION  
    This script queries the Active Directory forest and outputs all
    Users based on specified filter criteria
          
.NOTES  
    File Name  : Get-AllADUsers.ps1
    Author     : Mark Christman
    Requires   : PowerShell Version 2.0 and Active Directory Module
    Version    : 1.0
    Date       : 26 August 2014

.LINK  
    This script is not published

.EXAMPLE  
    PS [C:\] .\Get-AllADUsers.ps1 

	TO DO: Convert to using splatting      
#>

###
# START SCRIPT
###

# Load Active Directory Module
if(-not(Get-Module -Name "ActiveDirectory"))
{
    if(Get-Module -ListAvailable | Where-Object {$_.name -eq "ActiveDirectory"})
    {
    Import-Module -Name "ActiveDirectory"
    }
    else
    {
    'ActiveDirectory Module not installed on this computer'
    }
}
else {}

# Variable Declaration
$users = @()
$filter = $null
$UserProperties = $null
$loc = $null
$domains = $null

$filter = {(enabled -eq $true) -and (msExchHideFromAddressLists -ne $true) -and (employeeID -like "*") }
$UserProperties = "BadLogonCount","CanonicalName","Description","DisplayName","DistinguishedName","EmployeeID","Enabled","GivenName","LastBadPasswordAttempt","LockedOut","lockouttime","mail","msExchHideFromAddressLists","Name","PasswordExpired","PasswordLastSet","SamAccountName","SID","Surname","telephoneNumber","useraccountcontrol","UserPrincipalName","whenchanged","whencreated"
$SelectProperties = @()
$SelectProperties += @{name="AccountName";Expression={$domain.netbiosname + "\" + $_.samaccountname}}
$SelectProperties += $UserProperties

$loc = Get-Location

CD $env:USERPROFILE

$Domains = ((Get-ADForest).domains | Get-ADDomain | select NetBIOSName,ChildDomains,DistinguishedName,DNSRoot,@{name="drive";e={$_.netbiosname + ':'}})

# Attach Domains
ForEach ($domain in $domains)
{
    New-PSDrive -name $Domain.NetBIOSName -PSProvider ActiveDirectory -root $Domain.DistinguishedName -server $Domain.DNSRoot -ErrorAction SilentlyContinue | Out-Null
}

# Get User Information
$users = ForEach ($domain in $domains)
{
    CD $Domain.drive
    # Get-ADUser -filter $filter -searchbase $domain.DistinguishedName -properties $UserProperties | select @{name="AccountName";Expression={$domain.netbiosname+"\"+$_.samaccountname}},*
    # Get-ADUser -filter * -searchbase $domain.DistinguishedName -properties $UserProperties | select @{name="AccountName";Expression={$domain.netbiosname+"\"+$_.samaccountname}},*
    Get-ADUser -filter $filter -searchbase $domain.DistinguishedName -properties $UserProperties | select $SelectProperties
}


CD $loc

# Export Data to CSV
$users | Export-Csv -NoTypeInformation $env:USERPROFILE\Documents\allADUsers$(get-date -format yyyyMMdd).csv 

###
# END SCRIPT
###