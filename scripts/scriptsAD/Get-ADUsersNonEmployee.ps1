<#  
.SYNOPSIS  
    This script queries the Active Directory for all Non-Employee Users.
    
.DESCRIPTION  
    This script queries the Active Directory forest and outputs all
    Non-Employee Users.
          
.NOTES  
    File Name  : Get-NonEmployeeUsers.ps1 
    Author     : Mark Christman
    Requires   : PowerShell Version 2.0 and Active Directory Module
    Version    : 1.0
    Date       : 26 August 2014

.LINK  
    This script is not published

.EXAMPLE  
    PS [C:\] .\Get-NonEmployeeUsers.ps1 
      
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
$loc = $null
$searchbasena = $null
$searchbaseeu = $null
$NonEmployees = @()
$Atos = @()
$AtosNP = @()
$UserProperties = $null
$filter = $null
$NPGroup = $null

$NPGroup = "CN=NonUser,OU=Groups,OU=Nonemployee,DC=contoso.org"
$loc = Get-Location
$searchbasena = "ou=users,ou=nonemployee,dc=na,dc=contoso,dc=org"
$searchbaseeu = "ou=users,ou=nonemployee,dc=eu,dc=contoso,dc=org"
$UserProperties = "BadLogonCount","CanonicalName","Company","Description","DisplayName","DistinguishedName","EmployeeID","Enabled","GivenName","LastBadPasswordAttempt","LockedOut","lockouttime","mail","MemberOf","msExchHideFromAddressLists","Name","Organization","PasswordExpired","PasswordLastSet","SamAccountName","SID","Surname","telephoneNumber","useraccountcontrol","UserPrincipalName","whenchanged","whencreated"
$filter = {(organization -eq 'external') -or (company -eq 'external')}
$NPFilter = {memberof -eq $NPGroup}

# Get Non-Employee users from the CONTOSO Domain
$NonEmployees = get-aduser -Filter * -SearchBase $searchbasena -Properties $UserProperties | select @{name="AccountName";Expression={"CONTOSO\"+$_.samaccountname}},*
$Atos = get-aduser -Filter $filter -Properties $UserProperties | select @{name="AccountName";Expression={"CONTOSO\"+$_.samaccountname}},*
$AtosNP = get-aduser -Filter $NPFilter -Properties $UserProperties | select @{name="AccountName";Expression={"CONTOSO\"+$_.samaccountname}},*

# Connect to the CONTOSO Domain
New-PSDrive -name CONTOSO -PSProvider ActiveDirectory -root "dc=eu,dc=contoso,dc=org" -server eu.contoso.org -ErrorAction SilentlyContinue
CD CONTOSO:

# Get Non-Employee users from the CONTOSO Domain
$NonEmployees += get-aduser -Filter * -SearchBase $searchbaseeu -Properties $UserProperties | select @{name="AccountName";Expression={"CONTOSO\"+$_.samaccountname}},*
$Atos += get-aduser -Filter $filter -Properties $UserProperties | select @{name="AccountName";Expression={"CONTOSO\"+$_.samaccountname}},*
$AtosNP += get-aduser -Filter $NPFilter -Properties $UserProperties | select @{name="AccountName";Expression={"CONTOSO\"+$_.samaccountname}},*

# Change back to the original directory location
CD $loc

# Export Users to a CSV file.
$NonEmployees | Export-Csv -NoTypeInformation $env:USERPROFILE\Documents\Nonemployees$(get-date -format yyyyMMdd).csv 
$Atos | Export-Csv -NoTypeInformation $env:USERPROFILE\Documents\Atos$(get-date -format yyyyMMdd).csv 
$AtosNP | Export-Csv -NoTypeInformation $env:USERPROFILE\Documents\AtosNP$(get-date -format yyyyMMdd).csv 

###
# END SCRIPT
###
