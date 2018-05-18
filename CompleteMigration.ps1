$UserFile = "C:\Temp\UserList.csv"
$UserList = import-csv $UserFile
$LogFile = "C:\Temp\365Mig.log"
$TempLogFile = "C:\Temp\Temp365Mig.log"
$StatusLog = "C:\Temp\Status.log"
$CurStatus = 4
$DesStatus = 5

if(!(Test-Path .\migconfig.xml))
{
    Write-Host "migconfig.xml Config file doesn't exist in root location." ; exit
}
$xml = [XML](Get-Content .\migconfig.xml)

$webmailurl = $xml.variables.webmailurl
$TargetDeliveryDomain = $xml.variables.TargetDeliveryDomain

Set-ExecutionPolicy Unrestricted -Force
Write-Host Please enter your Office 365
#$UserCredential = Get-Credential
If ($UserCredential -eq '') {$UserCredential = $Host.ui.PromptForCredential("Need credentials", "Please enter an Office 365 Admin user name and password.", "", "NetBiosUserName")}

Write-Host Please enter your AD Admin Credentials 
#$onprem = Get-Credential
If ($onprem -eq '') {$onprem = $Host.ui.PromptForCredential("Need credentials", "Please enter an Exchange Admin user name and password. User format DOMAIN\Username", "", "NetBiosUserName")}

#Connect-MsolService -Credential $UserCredential

$SESSION = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://ps.outlook.com/powershell -Credential $UserCredential -Authentication Basic -AllowRedirection
Import-PSSession $SESSION
Connect-MsolService -Credential $UserCredential



function Get-TimeStamp {
    
    return "[{0:MM/dd/yy} {0:HH:mm:ss}]" -f (Get-Date)
    
}

Write-Output "$(Get-TimeStamp) <<Completing Migration of the following users to state>> $($DesStatus) " | Out-File $LogFile -Append

$output = $UserList | ForEach-Object {


if ($_.'MigStatus' -eq $CurStatus) {




echo $_.'UserPrincipalName' | Out-File $LogFile -Append
Get-MoveRequest $_.'UserPrincipalName' | Resume-MoveRequest 2> $TempLogFile
Get-Content $TempLogFile | Out-File $LogFile -Append
$_.MigStatus = $DesStatus



}

if ($_.'MigStatus' -ne $CurStatus) {
$_ 
}

}

$Output | export-csv $UserFile 

Write-Host (Get-Content $StatusLog)

Write-Output "$(Get-TimeStamp) <<Completion Run for the following status has compeleted>> $($DesStatus) " | Out-File $LogFile -Append 