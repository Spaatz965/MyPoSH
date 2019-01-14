#Requires -module ActiveDirectory
<#
    Change user password (Requires AD Module)
#>

$Parameters = @{
    'Identity' = 'sanAccountName' # samAccountName
    'OldPassword' = ConvertTo-SecureString -AsPlainText '<old password>' -Force # use hard single quotes for password to ensure no escaping of characters is needed'
    'NewPassword' = ConvertTo-SecureString -AsPlainText '<new password>' -Force
} # $Parameters

Set-ADAccountPassword @Parameters

