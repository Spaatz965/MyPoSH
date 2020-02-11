<#
Posted 19 August 2019
https://ironscripter.us/a-windows-feature-powershell-challenge/

A WINDOWS FEATURE POWERSHELL CHALLENGE
It is time for a new set of challenges. Please feel free to post a comment with
links back to your solutions and work on previous challenges. The Chairman
doesn’t want to get into a position of having to provide solutions because
there’s no guarantee it would be any “better” than yours. If your code runs and
meets the criteria that should be good enough. Hopefully, you will pick up new
ideas and techniques from other people’s work or even from reading the help.
This challenge is centered on the idea of creating a unified command to enable
or disable an optional feature on a Windows 10 desktop like Containers.
Obviously, your first challenge is to discover what PowerShell commands you can
incorporate into your function. The Chairman is leaning towards a single command
that sets a Windows optional feature to be either enabled or disabled. Additional
criteria will be imposed on intermediate and advanced levels.

Beginner
If you are at the beginner level you should write a function that allows the
user to specify a single Windows optional feature as a parameter value and
whether to enable or disable it on the local host. If the feature is already in
the desired state, you might want to display a message to the user informing
them that no changes are being made.

Intermediate
Building on the beginner requirements, let the user specify multiple features on
the local host via a parameter and through the pipeline. Parameter validation is
encouraged. Your function should support -WhatIf and incorporate the logging
features of the underlying commands. Your function should include appropriate
error handling.

Advanced
Building on the intermediate requirements, let the user specify running the
command to set one or more Windows optional features on multiple remote
computers. As a bonus, auto-complete the feature names for the user.

You are encouraged to push yourself and meet the criteria beyond your comfort
level. Again, you are encouraged to post a comment with links to your work. No
code samples or solutions will be published.

Good Scripting!

#>