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
3. Figure out a way to get the configuraiton data into non-tech people format
   for sharing with key stakeholders.
4. Figure out a way to get changes based on the non-tech people format into the
   config file after stakeholder input.

Side Note
---------
I am disappointed that JSON doesn't allow for comments. I'm thinking about
flipping to XML for the data format instead. Basically, comments will be useful
for tracking changes over time.

But otherwise, it was a good excercise to acquaint myself with JSON.