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
    Version    : 1.1
    Date       : 08 September 2014

.LINK  
    This script is not published

.EXAMPLE  
    PS [C:\] .\Get-UsersBySite.ps1
      
#> 

###
# START SCRIPT
###

# Load SharePoint PSSnapin
Add-PSSnapin "Microsoft.SharePoint.PowerShell"  -ErrorAction SilentlyContinue

# Variable Declaration in order of use
$web = $null
$starttime = $null
$dtg = $null
$path = $null
$timefile = $null
$webapp = $null
$site = $null
$i = 0
$filepath = $null
$endtime = $null
$runtime =$null
$output = $null

# Identify the Web Application URL to capture site info for
$web = "https://sharepoint.example.com"

# Capture Script Start Time
$starttime = Get-Date

# Capture UTC Date/Time for use in path
$dtg = ((get-date).ToUniversalTime()).ToString("yyyyMMdd'Z'HHmm.ss")

# Set path for all files to be stored in and Time File Name
$path = "$env:userprofile\Documents\UserBySiteTEST$dtg\"
$timefile = $path + "time.txt"

# Capture the web application object in a variable
$webapp = get-spwebapplication $web

# Create output directory if it doesn't exist
if ((test-path -PathType Container -Path $path) -eq $false)
{
New-Item -ItemType Directory -Force -Path $path
}

# Get list of users in each site.
foreach ($site in $webapp.sites)
{
$i++ # Increment $i to ensure unique output file

if ($i -ge 100) {Exit}


# Set site output file name
$filepath = $path + "site" + $i.tostring("0000") + ".csv"

# export list of site users to the output file $filepath
$site.RootWeb | select -ExpandProperty siteusers | select @{name="url";
   expression={$site.url}},userlogin,displayname,issiteadmin,isdomaingroup,`
   email | export-csv -NoTypeInformation $filepath

# Dispose of the SP-Site object to preserve memory
$site.dispose()
}

# Capture script end time and calculate run time
$endtime = Get-Date
$runtime = $endtime - $starttime
$output = "Start Time: " + $starttime + ". End Time: " + $endtime + ". Total Run Time: " + $runtime

# Output script start and end time to the file $timefile
$output | Out-File $timefile

###
# END SCRIPT
###