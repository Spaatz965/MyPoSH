New-SCDLPPolicy.ps1
===================

I first started working on this script in 2017, as a way to maintain a consistent
set of documentation for DLP configuration in Office 365, and make it portable
into other environments (test, dev, etc). The script was put on hold. At the time
I'd really only identified parameters to leverage in PowerShell, and hadn't
figured out the data format to leverage for the configuration files.

Shoot forward to 2019. I'm in a talk about Azure and software as code, and the
configuration file format used was JSON. I blinked twice with an audible click.
Next day, I ran through and finished rev 0.1 of the script.

First Oddity
------------

Get-Help on New-DLPCompliancePolicy and New-DLPComplianceRule popped parameters
not currently in use. Speculating they're for future use, and I pulled them
out of the script and the JSON.

Second Oddity
-------------
For some reason, the ContentContainsSensitiveInformation parameter, which is an
array of hash tables, wasn't "Just Working". It was weird. Pulled in from the JSON
when looking at the data, it appeared as {@{name=sitype;...}}, which "looked" right
to me while working with it. But it kept coming back with error messages about
not being able to HashTableto-Object convert the content to PswsHshtble as
expected by the cmdlet parameter. Lots of red. Backing up a bit, I scripted
things out hard coded, without the JSON, and got the data back. it looked like
{System.Collections.Hashtable, System.Collections.Hashtable, ...}. The Red Green
making it work with Duct Tape method of handling it was to pre-process that
particular parameter in a separate variable. Probably not the most efficient
way to do it, but it worked. I'll need to do more research on that later 
(because later will come someday, might be 2 years down the road or so).

Other Next Steps
----------------

1. Figure out a way to process changes.
2. Figure out a good document control format.
3. Figure out a way to get the configuration data into non-tech people format
   for sharing with key stakeholders.
4. Figure out a way to get changes based on the non-tech people format into the
   config file after stakeholder input.

Side Note
---------
I am disappointed that JSON doesn't allow for comments. I'm thinking about
flipping to XML for the data format instead. Basically, comments will be useful
for tracking changes over time.

But otherwise, it was a good excercise to acquaint myself with JSON.

Get-XMSCDLPPolicy.ps1
=====================

Switching to XML
----------------
So, was still unhappy with the lack of commenting in JSON. Along the way I
learned of a way to read in XML (other than the Command Line Interface XML used
by PowerShell) for another project. Part of my trouble with the CliXML format
is, it isn't very human readable. To be fair, XML isn't human readable for folk
outside of IT Ops / Dev. CliXML is jibberish for me. Plain XML, on the otherhand,
can be handed to an IT Pro / Dev, and reasonably be interpretted. Especially if
the XML is formatted reasonably well for human consumption. To change formats,
I switched gears from creating new policies/rules, and started reading them.
Using what I'd previously done, and getting some new info (Teams is added), I 
drafted a function/script to pull the policies and rules from a tenant. Still
needs some polish, but it's about 90% there (I have some other config bits to
comprehend). Another bit to consider is documentation/error checking on things
that will create conflicts. (like Exchange exceptions when Teams is also being
checked)

Acknowledgements for reading and writing XML via PowerShell
-----------------------------------------------------------
Bertrand, Adam, n.d., "PowerShell offers several ways to read XML documents, without writing a lot of code."
   https://www.business.com/articles/powershell-read-xml-files/
Bertrand, Adam, 18 Nov 2015, "Using PowerShell to create XML documents",
   https://searchwindowsserver.techtarget.com/tip/Using-PowerShell-to-create-XML-documents
Hicks, Jeff, 6 Jan 2017, "Creating Custom XML from .NET and PowerShell",
   https://www.petri.com/creating-custom-xml-net-powershell
Weltner, Tobias, 19 Aug 2013, "Mastering everyday XML tasks in PowerShell",
   https://www.powershellmagazine.com/2013/08/19/mastering-everyday-xml-tasks-in-powershell/