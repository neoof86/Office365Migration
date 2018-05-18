# Office 365 Migration Scripts

# WARNING:- I am not liable for any data loss or corruption using these scripts. I have performed some limited testing so far and keen to keep evolving the scripts. I would also suggest backing up your userlist.csv during each run but I may build this in if it’s a large amount of users

## Pre-Recs:-

If you will want to perform all this from one machine you will need to have the Exchange management PowerShell and the Azure Online PowerShell
Guides on this can be found below
https://technet.microsoft.com/en-us/library/bb232090(v=exchg.160).aspxhttps://onlinehelp.coveo.com/en/ces/7.0/administrator/installing_the_windows_azure_ad_module_for_windows_powershell.htm

## Usage:-

You will need to populate the migconfig.xml with your variables such as domain and delivery domain. To get the license types you have run the following command Get-MsolAccountSku
For the last few deployments I have done we have used the users primary email also as the UPN to help with single sign on and ease of use. You could modify the variable if you so desired and wanted to use the email address if it doesn’t match your UPN
You will need to use the scripts in the following order

Getuser.ps1
Create a MigStatus column in userlist.csv and set this to 0 for the users you want to start to migrate
AddUserLic.ps1

**-- I would wait a while here whilst the Office portal sorts itself out.... to quick and the next step may fail

MigUsers.ps1
CheckMig.ps1
CompleteMigration.ps1
CheckMig.ps1

## To Do / Bugs :-

*Sometimes you get an extra line of users if the migration stalls. It doesn’t seem to affect anything but just increase the user CSV but I will work on this
*I also want to get better errors logging in here and document all the values
*Create a script that updates emails and UPN's
*The error of 'You can't use the domain  because it's not an accepted domain for your organization.' may be down to a UPN issue or the fact that the license add failed or it created a mailbox despite having one on prem. I had to remove the license and reset the value to 0 for this user to start the process again




