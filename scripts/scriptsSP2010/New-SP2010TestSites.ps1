<#  
.SYNOPSIS  
    This script creates a large number of site collections for testing purposes
      
.DESCRIPTION  
    This script uses creates an automatically incremented number of site
    collections based on variable input. Variable definition for the root URL 
    (inclusive of managed path), sitename prefix, and number of site collections
    to create. This is intended to create site collections for testing purposes.

    Assumes managed path is /sites/

    Check content database names before starting - duplicates would be bad

    There is no error handling in this script.
      
.NOTES  
    File Name  : New-SP2010TestSites.ps1 
    Author     : Mark Christman
    Requires   : PowerShell Version 2.0 and SharePoint PSSnapin
    Version    : 1.0
    Date       : 20 August 2014

.LINK  
    This script is not published

.EXAMPLE  
    PS [C:\] .\Add-RandomUsers.ps1
      
#> 

##  
# Start of Script  
## 

# Load SharePoint PSSnaping
Add-PSSnapin "Microsoft.SharePoint.PowerShell"  -ErrorAction SilentlyContinue

# Variable Declaration
$url = $null
$manpath = $null
$base = $null
$sitenum = $null
$webapp = $null
$dbname = $null
$dbserver = $null
$contdb = $null
$template = $null
$site = $null
$owner = $null
$secown = $null

$url = "http://sharepoint.contoso.com"
$manpath = "/sites/"
$base = "sitetest"
$sitenum = 5
$dbname = "wss_team_sitetest"
$dbserver = "sqlserver"
$template = Get-SPWebTemplate "STS#0"
$owner = "NTDomain\samAccountName"
$secown = "NTDomain\samAccountName"

# Get web application object
$webapp = Get-SPWebApplication $url

# Create a segregated content database
New-SPContentDatabase $dbname -DatabaseServer $dbserver -WebApplication $webapp
$contdb = get-SPContentDatabase $dbname

# Create site collections
for ($i=1; $i -le $sitenum; $i++)
{
$site = $url+$manpath+$base+$i.tostring("0000")
New-SPSite $site -OwnerAlias $owner -SecondaryOwnerAlias $secown -Template $template -ContentDatabase $contdb
}
