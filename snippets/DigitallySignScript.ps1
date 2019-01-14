<#
    Digitally Sign Script
    TODO Describe how to obtain and implement certificate
#>

$SignatureParameters = @{
    'filepath' = "$env:userprofile\OneDrive\scripts\file.ps1" #File path to be digitally signed
    'certificte' = @(Get-ChildItem cert:\CurrentUser\My -codesign)[0]
} # $SignatureParameters

Set-AuthenticodeSignature @SignatureParameters
