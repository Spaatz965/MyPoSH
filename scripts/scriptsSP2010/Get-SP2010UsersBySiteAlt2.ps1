<#  
.SYNOPSIS  
    This script runs through all site collections in a specified web application
    and details which users are a member of the site collections.
    
.DESCRIPTION  
    This script will use a web application url and then loop through
    every site collection in the web application and extract all the users
    of those site collections - outputting to a CSV file. PowerShell Reference to 
    getting User Information List info:
    http://davidlozzi.com/2012/03/07/using-powershell-to-access-sharepoint-sites/

    The variable $web will need to be updated for the correct Web Application.
      
.NOTES  
    File Name  : Get-UsersBySite.ps1 
    Author     : Mark Christman
    Requires   : PowerShell Version 2.0 and SharePoint PSSnapin
    Version    : 1.0
    Date       : 26 August 2014

.LINK  
    This script is not published

.EXAMPLE  
    PS [C:\] .\Get-UsersBySite.ps1
      
#> 


###
# START SCRIPT
###

# Load SharePoint PSSnaping
Add-PSSnapin "Microsoft.SharePoint.PowerShell"  -ErrorAction SilentlyContinue

# Variable Declaration
$site = $null
$users = $null
$web = $null
$webapp = $null
$time = @()
$path = $null
$mpath = $null

$time += Get-Date
$web = "https://sharepoint.example.com"
# $sites = get-spsite -limit all -WebApplication $web
$webapp = get-spwebapplication $web
$path = "$env:userprofile\Documents\UserBySite$(get-date -format yyyyMMdd)"
$mpath = "$path/sites"

if ((test-path -PathType Container -Path $path) -eq $false)
{
New-Item -ItemType Directory -Force -Path $mpath
}

# Get list of users in each site.
foreach ($site in $webapp.sites)
{
$filepath = $path + $site.ServerRelativeURL + ".csv"
$site.RootWeb | select -ExpandProperty siteusers | select @{name="url"; expression={$site.url}},userlogin,displayname,issiteadmin,isdomaingroup,email | export-csv -NoTypeInformation $filepath
$site.dispose()
}

# $users | export-csv $env:userprofile\documents\UsersBySite$(get-date -format yyyyMMdd).csv -notypeinformation
$time += Get-Date
$time | Out-File $env:userprofile\documents\time.txt
###
# END SCRIPT
###
