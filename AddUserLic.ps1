$UserFile = "C:\Temp\UserList.csv"
$UserList = import-csv $UserFile
$LogFile = "C:\Temp\365Mig.log"
$TempLogFile = "C:\Temp\Temp365Mig.log"
$CurStatus = 0
$DesStatus = 1

if(!(Test-Path .\migconfig.xml))
{
    Write-Host "migconfig.xml Config file doesn't exist in root location." ; exit
}
$xml = [XML](Get-Content .\migconfig.xml)

$UsageLocation = $xml.variables.UsageLocation
$lictype = $xml.variables.lictype


$UserCredential = $Host.ui.PromptForCredential("Need credentials", "Please enter an Office 365 Admin user name and password.", "", "NetBiosUserName")
Connect-MsolService -Credential $UserCredential


function Get-TimeStamp {
    
    return "[{0:MM/dd/yy} {0:HH:mm:ss}]" -f (Get-Date)
    
}

Write-Output "$(Get-TimeStamp) <<Starting Migration of the following users to state>> $($DesStatus) " | Out-File $LogFile -Append

$output = $UserList | ForEach-Object {


if ($_.'MigStatus' -eq $CurStatus) {



$_.MigStatus = $DesStatus


echo $_.'UserPrincipalName' | Out-File $LogFile -Append
Set-MsolUser -UserPrincipalName $_.'UserPrincipalName' -UsageLocation $UsageLocation 2> $TempLogFile
Get-Content $TempLogFile | Out-File $LogFile -Append
Set-MsolUserLicense -UserPrincipalName $_.'UserPrincipalName' -AddLicenses $lictype 2> $TempLogFile
Get-Content $TempLogFile | Out-File $LogFile -Append

}

if ($_.'MigStatus' -ne $CurStatus) {
$_ 
}

}

$Output | export-csv $UserFile 

Write-Output "$(Get-TimeStamp) <<Completin licence add for the following status has compeleted>> $($DesStatus) " | Out-File $LogFile -Append 
