#requires -Module ActiveDirectory
#requires -PsSnapIn 'Microsoft.SharePoint.PowerShell'
#requires -Version 2.0

function Verb-Noun {

    <#

==== Comment based help template ====

.SYNOPSIS
    A brief description of the function or script. This keyword can be used
    only once in each topic.

.DESCRIPTION
    A detailed description of the function or script. This keyword can be
    used only once in each topic.

.PARAMETER  <Parameter-Name>
    The description of a parameter. Add a .PARAMETER keyword for
    each parameter in the function or script syntax.

    Type the parameter name on the same line as the .PARAMETER keyword. 
    Type the parameter description on the lines following the .PARAMETER
    keyword. Windows PowerShell interprets all text between the .PARAMETER
    line and the next keyword or the end of the comment block as part of
    the parameter description. The description can include paragraph breaks.

    The Parameter keywords can appear in any order in the comment block, but
    the function or script syntax determines the order in which the parameters
    (and their descriptions) appear in help topic. To change the order,
    change the syntax.

    You can also specify a parameter description by placing a comment in the
    function or script syntax immediately before the parameter variable name.
    If you use both a syntax comment and a Parameter keyword, the description
    associated with the Parameter keyword is used, and the syntax comment is
    ignored.

.EXAMPLE
    A sample command that uses the function or script, optionally followed
    by sample output and a description. Repeat this keyword for each example.

.INPUTS
    The Microsoft .NET Framework types of objects that can be piped to the
    function or script. You can also include a description of the input 
    objects.

.OUTPUTS
    The .NET Framework type of the objects that the cmdlet returns. You can
    also include a description of the returned objects.

.NOTES
    Additional information about the function or script.
    File Name  : Verb-Noun.ps1
    Author     : Mark Christman
    Requires   : PowerShell Version 2.0 and Active Directory Module
    Version    : 1.0
    Date       : 26 August 2014

.LINK
    The name of a related topic. The value appears on the line below
    the .LINE keyword and must be preceded by a comment symbol (#) or
    included in the comment block. 

    Repeat the .LINK keyword for each related topic.

    This content appears in the Related Links section of the help topic.

    The Link keyword content can also include a Uniform Resource Identifier
    (URI) to an online version of the same help topic. The online version 
    opens when you use the Online parameter of Get-Help. The URI must begin
    with "http" or "https".

.COMPONENT
    The technology or feature that the function or script uses, or to which
    it is related. This content appears when the Get-Help command includes
    the Component parameter of Get-Help.

.ROLE
    The user role for the help topic. This content appears when the Get-Help
    command includes the Role parameter of Get-Help.

.FUNCTIONALITY
    The intended use of the function. This content appears when the Get-Help
    command includes the Functionality parameter of Get-Help.

.FORWARDHELPTARGETNAME <Command-Name>
    Redirects to the help topic for the specified command. You can redirect
    users to any help topic, including help topics for a function, script,
    cmdlet, or provider. 

.FORWARDHELPCATEGORY  <Category>
    Specifies the help category of the item in ForwardHelpTargetName.
    Valid values are Alias, Cmdlet, HelpFile, Function, Provider, General,
    FAQ, Glossary, ScriptCommand, ExternalScript, Filter, or All. Use this
    keyword to avoid conflicts when there are commands with the same name.

.REMOTEHELPRUNSPACE <PSSession-variable>
    Specifies a session that contains the help topic. Enter a variable that
    contains a PSSession. This keyword is used by the Export-PSSession
    cmdlet to find the help topics for the exported commands.

.EXTERNALHELP  <XML Help File>
    Specifies an XML-based help file for the script or function.  

    The ExternalHelp keyword is required when a function or script
    is documented in XML files. Without this keyword, Get-Help cannot
    find the XML-based help file for the function or script.

    The ExternalHelp keyword takes precedence over other comment-based 
    help keywords. If ExternalHelp is present, Get-Help does not display
    comment-based help, even if it cannot find a help topic that matches 
    the value of the ExternalHelp keyword.

    If the function is exported by a module, set the value of the 
    ExternalHelp keyword to a file name without a path. Get-Help looks for 
    the specified file name in a language-specific subdirectory of the module 
    directory. There are no requirements for the name of the XML-based help 
    file for a function, but a best practice is to use the following format:
    <ScriptModule.psm1>-help.xml

    If the function is not included in a module, include a path to the 
    XML-based help file. If the value includes a path and the path contains 
    UI-culture-specific subdirectories, Get-Help searches the subdirectories 
    recursively for an XML file with the name of the script or function in 
    accordance with the language fallback standards established for Windows, 
    just as it does in a module directory.

    For more information about the cmdlet help XML-based help file format,
    see "How to Create Cmdlet Help" in the MSDN (Microsoft Developer Network) 
    library at http://go.microsoft.com/fwlink/?LinkID=123415.
#>


    [CmdletBinding()]
    param ()

    BEGIN {
        Write-Verbose "[$((get-date).TimeOfDay.ToString()) BEGIN   ] "
        Write-Verbose "[$((get-date).TimeOfDay.ToString()) BEGIN   ] Starting: $($MyInvocation.MyCommand)"
        Write-Verbose "[$((get-date).TimeOfDay.ToString()) BEGIN   ] Execution Metadata:"
        # TODO: Add Get-GLWEnvironmentMetaData helper function
        # $EnvironmentData = Get-GLWEnvironmentMetaData
        # Write-Verbose $EnvironmentData

    } # BEGIN

    PROCESS {
        Write-Verbose "[$((get-date).TimeOfDay.ToString()) PROCESS ] "

    } # PROCESS

    END {
        Write-Verbose "[$((get-date).TimeOfDay.ToString()) END     ] Ending: $($MyInvocation.Mycommand)"
        Write-Verbose "[$((get-date).TimeOfDay.ToString()) END     ] "

    } # END

} # function Verb-Noun

#region Function Test Use Cases (Uncomment To Test)

# Call Function with parameters

# Call Function via PipeLine

# Call Function via PipeLine By Name

# Call Function with multiple objects in parameter

# Call Function test Error Logging

#endregion