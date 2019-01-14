#Requires -module ActiveDirectory

<#
    Map a PS Drive to an AD Domain, where the computer isn't in the domain
	or doesn't otherwise automatically map the domain when loading the 
	ActiveDirectory module
	#Requires -module ActiveDirectory
#>

$cred            = Get-Credential
$Parameters      = @{
    'Name'       = "ADDomain" #Can be changed to more relevant name
    'PSProvider' = "ActiveDirectory"
    'Root'       = "dc=contoso,dc=org" #Root of the domain in X.500 format
    'server'     = "domaincontroller.contoso.org" #Domain Controller dns name, the domain name might also be usable.
    'Credential' = $cred
} # $Parameters
 
New-PSDrive @Parameters 