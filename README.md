# Office365Migration

WARNING:- I am not liable for any data loss or corruption using these scripts. I have performed some limited testing so far and keen to keep evolving the scripts

Pre-Recs:-

If you will want to perform all this from one machine you will need to have the Exchange management PowerShell and the Azure Online PowerShell  

Guides on this can be found below

https://technet.microsoft.com/en-us/library/bb232090(v=exchg.160).aspx
https://onlinehelp.coveo.com/en/ces/7.0/administrator/installing_the_windows_azure_ad_module_for_windows_powershell.htm

Usage:-

You will need to populate the migconfig.xml with your variables such as domain and delivery domain. To get the license types you have run the following command Get-MsolAccountSku

For the last few deployments I have done we have used the users primary email also as the UPN to help with single sign on and ease of use. You could modify the variable if you so desired and wanted to use the email address if it doesn’t match your UPN

