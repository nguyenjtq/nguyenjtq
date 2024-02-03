## Courtesy of Patrick Betts
#Install PS7zip Module
Install-Module -Name PS7zip -Force

#Determine who's logged in
$loggedInUser = $($env:USERNAME)

Write-Host "Currently logged in as $loggedInUser"
#Choose directory to zip
$userFolder = @(Get-ChildItem C:\Users | Out-GridView -Title "Select a directory" -PassThru).Name
Write-Host "Beginning Archive Job on C:\Users\$userFolder"
#Save location of zip
$saveZipLocation = "C:\Users\$loggedInUser\Desktop\$(Get-Date -Format yyyy-MM-dd)_$userFolder.7z"
#Zip chosen directory
Compress-7Zip -FullName "C:\Users\$userFolder" -OutputFile $saveZipLocation -ArchiveType 7Z