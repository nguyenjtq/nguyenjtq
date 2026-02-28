$webhook = "https://discord.com/api/webhooks/YOUR_WEBHOOK_URL"
$file = "C:\hwid.csv"

# Set execution policy and install prerequisites
Set-ExecutionPolicy -Scope Process -ExecutionPolicy RemoteSigned -Force

# Install NuGet provider (required in OOBE — not present by default)
Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force

# Install and run the Autopilot info script
Install-Script -Name Get-WindowsAutopilotInfo -Force
Get-WindowsAutopilotInfo -OutputFile $file

# Upload to Discord
$boundary = [System.Guid]::NewGuid().ToString()
$fileBytes = [System.IO.File]::ReadAllBytes($file)
$fileContent = [System.Text.Encoding]::GetEncoding('iso-8859-1').GetString($fileBytes)

$bodyLines = @(
    "--$boundary",
    'Content-Disposition: form-data; name="file"; filename="hwid.csv"',
    "Content-Type: text/plain",
    "",
    $fileContent,
    "--$boundary--"
)

$body = $bodyLines -join "`r`n"
Invoke-RestMethod -Uri $webhook -Method Post -ContentType "multipart/form-data; boundary=$boundary" -Body $body

Write-Host "Done — check Discord for hwid.csv"