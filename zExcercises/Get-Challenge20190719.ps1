<#
Posted 19 July 2019
https://ironscripter.us/a-powershell-scripting-challenge-for-everyone/

A POWERSHELL SCRIPTING CHALLENGE FOR EVERYONE
Hopefully, everyone has had an opportunity to work on the previously posted
beginner challenge. For those of you with a bit more experience, it was probably
an easy task. Now that you have a solution that you can run at a PowerShell
prompt, your next challenge will build from it. The basic challenge is to take
your code and turn it into a PowerShell function. However, depending on your
skill level you will be asked to accomplish a little bit more.

Beginner
Using your solution from the previous beginner challenge, turn this into a
simple PowerShell function that will allow the user to specify the path. Your
function should write the same result to the pipeline.

Intermediate
Create a similar function as the beginner level but accept piping in a directory
name. Your function only needs to process a single path. You should also include
parameter validation and error handling. The output must include the path.
Include comment-based help.

Advanced
Create an advanced function that meets the Intermediate requirements. Your
function should also accept parameters for remote computernames with
credentials, it should accept mulitple paths, and an option to run as a
background job. It would be nice if the user could specify the job name.

#>