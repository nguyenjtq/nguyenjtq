# Env variables reference: https://renenyffenegger.ch/notes/Windows/dirs/Users/username/index
$env:USERPROFILE

# URL of Dell Command Update and destination
$url = "https://dl.dell.com/FOLDER07870027M/1/Dell-Command-Update-Windows-Universal-Application_PWD0M_WIN_4.4.0_A00.EXE"
$dest = "$env:USERPROFILE\downloads\dcu_4.4.0.exe"

# Published hash of DCU file
$publishedHash = "76998e350480edef3aeac3fb225da7a6c3f012f08997e6108251826ea225fa5d"

# Getting file hash by starting webclient: https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/get-filehash?view=powershell-7.2
# Start web client
$wc = [System.Net.WebClient]::new()

# Get file hash of online file
$FileHash = Get-FileHash -InputStream ($wc.OpenRead($url))

# Verify file hash matches online file before downloading
# Downloading files with PowerShell: https://blog.jourdant.me/post/3-ways-to-download-files-with-powershell
if($FileHash.Hash -eq $publishedHash){
    Start-BitsTransfer -Source $url -Destination $dest
}

# Install DCU
Start-Process $dest -ArgumentList "/s" -Verbose -Wait

# Start DCU CLI to apply ALL updates, auto-suspend BitLocker, and disables reboot.
Start-Process "C:\Program Files\Dell\CommandUpdate\dcu-cli.exe" -ArgumentList "/applyUpdates -autoSuspendBitLocker=enable -reboot=disable" -Verbose -Wait