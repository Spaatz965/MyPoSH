====|====|====|====|====|====|====|====|====|====|====|====|====|====|====|====|====|====|====|====|====|====|====|
====|====|====|====|====|====|====|====|====|====|====|====|====|====|====|


<#
    Convert UTF-8 to ASCII. Useful for converting to XML format.
#>

Get-Content -en utf8 in.txt | Out-File -en ascii out.txt

<#
    Edit Profile
#>

ise $profile


<#
    Output file name formatting with sortable date
#>

$outfile = "$env:userprofile\documents\filename$(get-date -format yyyyMMdd).csv"

<#
    Common #Requires Statements
#>

#Requires -module ActiveDirectory
#Requires -PSSnapin "Microsoft.SharePoint.PowerShell"

<#
    Merge CSV Files
#>

dir *.csv | foreach {import-csv $_} | sort url,userlogin | export-csv -NoTypeInformation usersbysite20150112.csv

<#
    Date Formats
    http://blogs.technet.com/b/heyscriptingguy/archive/2015/01/23/create-custom-date-formats-with-powershell.aspx
#>

$dateFormatSort = "%Y%m%d-%H%M"
$dateFormatSortZulu = "%Y%m%d-%H%M.%SZ"
$dateFormat = "%d %h %Y %R"
$dtg = ((get-date).ToUniversalTime()).ToString("yyyyMMdd'Z'HHmm.ss")


<#
    Multi-Valued Attributes
#>

get-aduser samAccountName -Properties proxyAddresses | select-object @{Name=’proxyAddresses';Expression={$_.proxyAddresses -join ";"}}
 
$emails | foreach-object {get-aduser -filter {proxyaddresses -eq $_} -Properties $userProperties | select $userProperties } | export-csv -NoTypeInformation -path "$env:userprofile\Documents\newstakeholders.csv" -Append
 
#Get O365 Users with licenses
$users = (get-msoluser -All | where {$_.islicensed -eq $true})
 
#Get O365 Users leveraging a specific subscription
$users | where {$_.licenses.accountskuid -eq '<tenantID>:OFFICESUBSCRIPTION'}
 
#Get O365 Licensed and Cloud Accounts
Get-MsolUser -all | where {$_.IsLicensed -eq $true -or $_.immutableid -eq $null}


#Connect to SharePoint Online
Import-Module Microsoft.Online.SharePoint.PowerShell -DisableNameChecking
#Pattern
Connect-SPOService -Url https://domainhost-admin.sharepoint.com

#Exchange Online Protection PS Remoting
$UserCredential = Get-Credential
$Parameters = @{
    'ConfigurationName' = 'Microsoft.Exchange'
    'ConnectionUri' = "https://ps.protection.outlook.com/powershell-liveid/"
    'Credential' = $UserCredential
    'Authentication' = "Basic"
    'AllowRedirection' = $true
}
 
$Session = New-PSSession @Parameters
Import-PSSession $Session
 
#Exchange Online PS Remoting
$UserCredential = Get-Credential
$Parameters = @{
    'ConfigurationName' = 'Microsoft.Exchange'
    'ConnectionUri' = "https://outlook.office365.com/powershell-liveid/"
    'Credential' = $UserCredential
    'Authentication' = "Basic"
    'AllowRedirection' = $true
}
$Session = New-PSSession @Parameters
Import-PSSession $Session
 
#Security & Compliance Center PS Remoting
$UserCredential = Get-Credential
$Parameters = @{
    'ConfigurationName' = 'Microsoft.Exchange'
    'ConnectionUri' = "https://ps.compliance.protection.outlook.com/powershell-liveid/"
    'Credential' = $UserCredential
    'Authentication' = "Basic"
    'AllowRedirection' = $true
}
$Session = New-PSSession @Parameters
Import-PSSession $Session


For ( $I = 1; $I -le 36; $I++) {
    $email1 = $email | where {$_.DayBatch -eq $I -and $_.mailprimary -ne ""}
    $output = $email1.mailprimary -join ";"
    $output | Out-File mailing.txt -Append
}



Get-MsolAccountSku | select accountname,accountobjectid,skuid,accountskuid,skupartnumber,activeunits,consumedunits,warningunits | export-csv -NoTypeInformation $doc\O365AccountSKU.csv