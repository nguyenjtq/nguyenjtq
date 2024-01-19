# Run 'Set-ExecutionPolicy Bypass' in order to run this script directly from PowerShell.

## Gets current logged in user
$loggedInUser = $($env:USERNAME)
Write-Output "Logged in as $loggedInUser"

## Shows list of folders under C:\Users to choose from
$userFolder = @(Get-ChildItem C:\Users | Out-GridView -Title 'Choose a file' -PassThru).Name

## Zip save file name and destination
$zipSaveLocation = "C:\Users\$loggedInUser\Desktop\$(Get-Date -Format yyyy-MM-dd)_$userFolder.zip"

## Compress the selected user folder and outputs it to destination
Compress-Archive -Path "C:\Users\$userFolder" -DestinationPath $zipSaveLocation