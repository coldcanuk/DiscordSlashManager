# get-discordslash.ps1

# No parameters needed for this script
$ErrorActionPreference = "Stop"

# Read the config.csv file to get Discord credentials
$config = @()
$config = Get-Content .\config.csv | ConvertFrom-Csv

# Extract the credentials
$token = ($config | Where-Object {$_.varName -match "DISCORD_TOKEN"}).varValue
$client_id = ($config | Where-Object {$_.varName -match "DISCORD_CLIENT_ID"}).varValue
$guild_id = ($config | Where-Object {$_.varName -match "DISCORD_GUILD_ID"}).varValue
$appname = ($config | where-object {$_.varname -match "DISCORD_APP_NAME"}).varValue
[string]$ua = $appname + "/1.0"
# Prepare the headers"
$headers = @{
    "Authorization" = ("Bot " + $token)
    "Accept" = "*/*"
    "User-Agent" = $ua
}

# Prepare the URI
$uri = "https://discord.com/api/v10/applications/$client_id/guilds/$guild_id/commands"

# Initialize an array to hold the command data
$commandData = @()

# Fetch the list of commands
try {
    $response = Invoke-RestMethod -Method Get -Headers $headers -Uri $uri
    $response | ForEach-Object {
        $commandInfo = @{
            "CommandID" = $_.id
            "CommandName" = $_.name
            "Options" = $_.options
        }
        $commandData += $commandInfo
    }
    $commandData | ConvertTo-Json
} catch {
    Write-Host $_.Exception.Message
}

# Clean up
Remove-Variable -Name config
