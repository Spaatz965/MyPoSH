<#  
.SYNOPSIS  
    This script gets useful user information from Active Directory based on email address file input
      
.DESCRIPTION  
    This script uses the Active Directory module to obtain and return information about users. There is limited
    error handling included in this version.
      
.NOTES  
    File Name  : Get-ADUsersByEmail.ps1  
    Author     : Mark Christman
    Requires   : PowerShell Version 2.0 and Active Directory module from the Remote Server Administration Tools (RSAT)
    Version    : 1.0
    Date       : 25 August 2014

.LINK  
    This script is not published

.EXAMPLE  
    PS [C:\] .\Get-ADUsersByEmail.ps1

	TO DO: Leverage splatting.
      
#> 

##  
# Start of Script  
## 

# Variable Declaration
$Domain = $null
$Domains = $null
$Drive = $null
$User = $null
$Users = $null
$UserProperties = $null
$UserTest = $null

$Drive = get-location
$UserProperties = "c","CanonicalName","City","CN","co","codePage","Company","Country","countryCode","Created","Deleted","Department","Description","DisplayName","DistinguishedName","Division","EmailAddress","EmployeeID","EmployeeNumber","employeeType","Enabled","Fax","GivenName","HomeDirectory","HomeDrive","HomePage","HomePhone","Initials","ipPhone","l","LastLogonDate","mail","mailNickname","MobilePhone","Modified","msExchHideFromAddressLists","msExchIMAddress","msExchUserCulture","msRTCSIP-PrimaryUserAddress","msRTCSIP-UserEnabled","Name","o","ObjectClass","ObjectGUID","Office","OfficePhone","Organization","OtherName","otherTelephone","PasswordExpired","PasswordLastSet","physicalDeliveryOfficeName","POBox","PostalCode","proxyaddresses","SamAccountName","SID","sn","st","State","StreetAddress","Surname","telephoneNumber","Title","UserPrincipalName"
$emailaddresses = import-csv $env:USERPROFILE\documents\dns.csv

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
    ForEach ($mail in $emailaddresses)
    {
        $filter = "SMTP:"+$mail.mail
        Get-ADUser -filter {proxyaddresses -eq $filter} -searchbase $domain.DistinguishedName -properties $UserProperties | select @{name="AccountName";Expression={$domain.netbiosname+"\"+$_.samaccountname}},*
    }
}


CD $Drive

# Export Data to CSV
$users | Export-Csv -NoTypeInformation $env:USERPROFILE\Documents\AddressBookEmail$(get-date -format yyyyMMdd).csv 

