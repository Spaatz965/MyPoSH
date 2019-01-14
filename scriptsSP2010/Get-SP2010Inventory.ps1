<#
.SYNOPSIS
	Output server and service account information for the Corporate SharePoint Environments in Production and the Developer's Environment
.VARIABLES
	$UserProp: Properties to collect for Service Accounts
	$SvrProp: Properties to collect for Servers
	$ProdSearch: Search Base for Production
	$DEVSearch: Search Base for the Developer's Environment
	$NewDir: Directory to create - where files are saved to
	$UserFile: Output file for Service Account Informaiton
	$SvrFile: Output file for Server Information
	$DnsFile: Output file for DNS Lookup Information
	$PtrFile: Output file for DNS Reverse Lookup Information
	$PrdOcts: The set of sub-nets in production (3rd Octet)
	$DROcts: The set of sub-nets in the Developers Environment (3rd Octet)
	$hosts: Temporary Array to house server objects with registered DNS name
	$3oct: Temporary variable for use with $PrdOcts and $DROcts in a For Each loop
	$I: Temporary value to cycle through digits [1..255] in a for next loop
#>

<# SET VARIABLES #>
$UserProp = "AccountLockoutTime","AccountNotDelegated","BadLogonCount","CannotChangePassword","CanonicalName","CN","Deleted","Description","DisplayName","DistinguishedName","Enabled","IsDeleted","LastBadPasswordAttempt","LastLogonDate","LockedOut","Manager","Name","ObjectClass","PasswordExpired","PasswordLastSet","PasswordNeverExpires","PasswordNotRequired","SamAccountName","WhenChanged","WhenCreated"
$SvrProp = "CanonicalName","CN","Deleted","Description","DisplayName","DistinguishedName","DNSHostName","Enabled","IPv4Address","IPv6Address","LastBadPasswordAttempt","LastLogonDate","LockedOut","ManagedBy","Name","ObjectGUID","objectSid","OperatingSystem","OperatingSystemServicePack","OperatingSystemVersion","PasswordExpired","PasswordLastSet","PasswordNeverExpires","PasswordNotRequired","SamAccountName","SID","TrustedForDelegation","TrustedToAuthForDelegation","UseDESKeyOnly","userAccountControl","whenChanged","whenCreated"
$ProdSearch = "OU=SharePoint,OU=ENT,dc=na,dc=contoso,dc=org"
$DEVSearch = "OU=SharePoint,OU=ENT,dc=na,dc=contoso,dc=org"
$PrdOcts = @(64,65,66,68)
$DROcts = @(64,68)
$hosts = ''
# Capture UTC Date/Time for use in path
$dtg = ((get-date).ToUniversalTime()).ToString("yyyyMMdd'Z'HHmm.ss")
$path = "$env:userprofile\Documents\SharePointInventory$dtg\"
$archive = "$env:userprofile\Documents\@AUDIT"
$arcName = "SharePointInventory$dtg.zip"
$arcFile = Join-Path -Path $archive -ChildPath $arcName
$UserFile = "$path\serviceaccounts.csv"
$SvrFile = "$path\SharePointServers.csv"
$DnsFile = "$path\dnsinfo.txt"
$PtrFile = "$path\ptrinfo.txt"
$hostfilter = {(name -like "usa01sp*") -or (name -like "usa02sp*") -or (name -like "usa01sq*") -or (name -like "usa02sq*") -or (name -like "DEV01sq*") -or (name -like "DEV01sp*") -or (name -like "usa01aa*") -or (name -like "DEV01aa*") -or (name -like "usa01as*") -or (name -like "DEV01as*")}

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



# Create output directory if it doesn't exist
if ((test-path -PathType Container -Path $path) -eq $false)
{
New-Item -ItemType Directory -Force -Path $path
}

# Create Archive directory if it doesn't exist
if ((test-path -PathType Container -Path $archive) -eq $false)
{
New-Item -ItemType Directory -Force -Path $archive
}

<# ATTACH TO DEV AD DOMAIN #>
New-PSDrive -name DEV -PSProvider ActiveDirectory -root "dc=na,dc=contoso,dc=org" -server na.contoso.org

<# ENSURE CURRENT DRIVE IS C: --- may want to obtain from an environment variable --- AD CONTEXT IS DEFAULTED TO CONTOSO #>
cd c:

<# COLLECT PRODUCTION SERVER INFORMATION #>
get-adcomputer -filter * -Properties $SvrProp -searchbase $ProdSearch | export-csv $SvrFile -notypeinformation
# get-adcomputer -filter $hostfilter -Properties $SvrProp | export-csv $SvrFile -notypeinformation

<# COLLECT PRODUCTION SERVICE ACCOUNT INFORMATION #>
get-aduser -filter * -Properties $UserProp -searchbase $ProdSearch | Export-Csv $UserFile -notypeinformation

<# SAVE PRODUCTION HOST INFORMATION INTO THE $hosts ARRAY #>
$hosts = get-adcomputer -filter * -Properties DNSHostName -searchbase $ProdSearch
# $hosts = get-adcomputer -filter $hostfilter -Properties DNSHostName

<# CHANGE AD CONTEXT TO DEV DOMAIN #>
CD DEV:

<# COLLECT DEV SERVER INFORMATION #>
get-adcomputer -filter * -Properties $SvrProp -searchbase $DEVsearch | export-csv $SvrFile -notypeinformation -Append
# get-adcomputer -filter $hostfilter -Properties $SvrProp | export-csv $SvrFile -notypeinformation -Append

<# COLLECT DEV SERVICE ACCOUNT INFORMATION #>
get-aduser -filter * -Properties $UserProp -searchbase $DEVSearch | Export-Csv $UserFile -notypeinformation -Append

<# SAVE DEV HOST INFORMATION INTO THE $hosts ARRAY #>
$hosts += get-adcomputer -filter * -Properties DNSHostName -searchbase $DEVsearch
# $hosts += get-adcomputer -filter $hostfilter -Properties DNSHostName

<# ENSURE CURRENT DRIVE IS C: --- may want to obtain from an environment variable --- AD CONTEXT IS DEFAULTED TO CONTOSO #>
cd c:

<# REMOVE FROM $hosts ANY ENTRY WHERE THERE IS A NULL FOR DNSHOSTNAME #>
$hosts = $hosts | ? {$_.dnshostname -notlike $null}

<# USE DIG TO PULL DNS LOOKUP INFORMATION FOR ALL $hosts #>
$hosts | % {dig +nocmd $_.dnshostname +noall +answer} | Out-File $DnsFile

<# USE DIG TO PULL DNS REVERSE LOOKUP INFORMATION FROM ALL SUBNETS IN Area1 #>
foreach ($3oct in $PrdOcts) {For ($i=1; $i -lt 256; $i++)  {dig +nocmd -x 10.41.$3oct.$I +noall +answer | Out-File $PtrFile -Append} }

<# USE DIG TO PULL DNS REVERSE LOOKUP INFORMATION FROM ALL SUBNETS IN Area2 #>
foreach ($3oct in $DROcts) {For ($i=1; $i -lt 256; $i++)  {dig +nocmd -x 10.40.$3oct.$I +noall +answer | Out-File $PtrFile -Append} }

<# Archive Inventory #>
If(Test-path $arcFile) {Remove-item $arcfile}
Add-Type -assembly "system.io.compression.filesystem"
[io.compression.zipfile]::CreateFromDirectory($path, $arcfile)
