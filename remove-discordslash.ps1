# remove-discordslash.ps1

param (
    [string]$CommandID,
    [string]$JsonInput
)

$ErrorActionPreference = "Stop"

# Check if both parameters are empty
if (-not $CommandID -and -not $JsonInput) {
    Write-Host "Usage:"
    Write-Host ".\remove-discordslash.ps1 -JsonInput (.\get-discordslash.ps1)"
    Write-Host "or"
    Write-Host ".\remove-discordslash.ps1 -CommandID 'your_command_id_here'"
    exit
}
# Read the config.csv file to get Discord credentials
$config = @()
$config = Get-Content .\config.csv | ConvertFrom-Csv

# Extract the credentials
$token = ($config | Where-Object {$_.varName -match "DISCORD_TOKEN"}).varValue
$client_id = ($config | Where-Object {$_.varName -match "DISCORD_CLIENT_ID"}).varValue
$guild_id = ($config | Where-Object {$_.varName -match "DISCORD_GUILD_ID"}).varValue
$appname = ($config | Where-Object {$_.varName -match "DISCORD_APP_NAME"}).varValue
[string]$ua = $appname + "/1.0"

# Prepare the headers
$headers = @{
    "Authorization" = ("Bot " + $token)
    "Accept" = "*/*"
    "User-Agent" = $ua
}

# Delete a single command if CommandID is provided
if ($CommandID) {
    $uri = "https://discord.com/api/v10/applications/$client_id/guilds/$guild_id/commands/$CommandID"
    try {
        Invoke-RestMethod -Method Delete -Headers $headers -Uri $uri
        Write-Host "Successfully deleted command with ID $CommandID."
    } catch {
        Write-Host $_.Exception.Message
    }
}

# Bulk delete commands if JsonInput is provided
if ($JsonInput) {
    $commandsToDelete = $JsonInput | ConvertFrom-Json
    foreach ($command in $commandsToDelete) {
        $uri = "https://discord.com/api/v10/applications/$client_id/guilds/$guild_id/commands/$($command.CommandID)"
        try {
            Invoke-RestMethod -Method Delete -Headers $headers -Uri $uri
            Write-Host "Successfully deleted command with ID $($command.CommandID)."
        } catch {
            Write-Host $_.Exception.Message
        }
    }
}

# Clean up
Remove-Variable -Name config
