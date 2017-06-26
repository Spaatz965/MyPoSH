<#  
.SYNOPSIS  
    This script adds users to site collections for lab testing
    
.DESCRIPTION  
    This script is is intended to add users to site collections for test 
    purposes. It will take input from a file with site collection names and
    numbers of users. It will also take input from a file with Fully Qualified
    Domain Names (FQDN) of test users (e.g. CONTOSO\userxyz). All files are
    expected to be in the current user's documents folder, 
    $env:USERPROFILE\Documents\. Root URL and Managed Path will need to be
    modified for the test environment. No permissions are assigned.
    
    sites.csv is expected to have two columns: SiteName, and Unique. SiteName is
    the unique site name, excluding base url and path (e.g. testsite0001). 
    Unique is the number of unique test users to add to the test site collection
    
    users.csv is expected to have at least one column, AccountName - which is
    the FQDN of the user account (e.g. CONTOSO\userxyz)
      
.NOTES  
    File Name  : Add-SPTestUsers.ps1  
    Author     : Mark Christman
    Requires   : PowerShell Version 2.0 and SharePoint PSSnapin
    Version    : 1.0
    Date       : 23 August 2014

.LINK  
    This script is not published

.EXAMPLE  
    PS [C:\] .\Add-SPTestUsers.ps1
      
#> 


###
# START SCRIPT
###

# Load SharePoint PSSnaping
Add-PSSnapin "Microsoft.SharePoint.PowerShell"  -ErrorAction SilentlyContinue

# Variable Declaration
$url = $null
$manpath = $null
$sites = @()
$users = @()

$url = "http://contosolab01"
$manpath = "/sites/"
$sites = import-csv $env:USERPROFILE\Documents\sites.csv
$users = import-csv $env:USERPROFILE\Documents\users.csv

# Loop through all sites
foreach ($s in $sites)
{

# Reset variables
$spuser = @()
$web = $url + $manpath + $s.SiteName

# Get random list of users based on unique user count
$spuser = get-random $users -count $s.Unique

# Loop through list of random users and assign to site collection
foreach ($u in $spuser)
{
New-SPUser -UserAlias $u.AccountName -Web $web
}

}

<#
Potential alternate method - useful for adding permissions

# Loop through all sites
foreach ($s in $sites)
{

# Reset variables
$spuser = @()
$web = $url + $manpath + $s.SiteName
$SiteColl = get-spweb -ideentity $web

# Get random list of users based on unique user count
$spuser = get-random $users -count $s.Unique

# Loop through list of random users and assign to site collection
foreach ($u in $spuser)
{
# Ensure users is a member of the site collection
$SiteColl.Ennsure($u.AccountName)

# Add to permission group (group would need to be defined)
# Set-SPUser -Identity $u.AccountName -web $web -group $group
}

}
#>