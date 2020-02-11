<#
Posted 28 April 2019
https://ironscripter.us/are-you-worthy-of-the-dark-faction/

ARE YOU WORTHY OF THE DARK FACTION?
Recently the Chairman posted a challenge from the Dark Faction. However the Dark
Faction is not satisfied. They have delivered another challenge for those of you
who wish to prove your worthiness as an Iron Scripter.

The Dark Faction often shares code among its members. You are challenged to
develop a set of tools that will meet the following requirements.

Create a text file in either json or xml format that can be securely copied
across the Internet. The file should contain the code the recipient can run and
a set of parameters. The recipient should be able to unravel the file and
execute the code with parameters.

You need to make sure that only the intended recipient can “open” the file and
execute the code. It might also be useful to include some metadata like the
originating user, computer or date. You can assume some pre-shared knowledge
like a password or user name. But otherwise the transport file should be protected.

You might need to develop a way to securely send and install a certificate as
part of the same file.

Ideally, you will write code, perhaps a module, that has commands to
encapsulate everything into a single file and PowerShell code to unwrap and
execute it.

#>