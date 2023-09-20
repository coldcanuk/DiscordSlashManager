# get-discordslash.ps1

param (
    [string]$token,
    [string]$client_id,
    [string]$guild_id,
    [string]$appname
)

$ErrorActionPreference = "Stop"

function Show-Usage {
    Write-Host "All parameters including Discord credentials are required to run this script." -ForegroundColor Yellow
    Write-Host "Here's how you can run this cmdlet:" -ForegroundColor Yellow
    Write-Host ""
    Write-Host ".\get-discordslash.ps1 -token 'YourToken' "
    Write-Host "                       -client_id 'YourClientID' "
    Write-Host "                       -guild_id 'YourGuildID' "
    Write-Host "                       -appname 'YourAppName'" -ForegroundColor Green
    write-host ""
    exit
}

if (-not $token -or -not $client_id -or -not $guild_id -or -not $appname) {
    Show-Usage
}

[string]$ua = $appname + "/1.0"

$headers = @{
    "Authorization" = ("Bot " + $token)
    "Accept" = "*/*"
    "User-Agent" = $ua
}

$uri = "https://discord.com/api/v10/applications/$client_id/guilds/$guild_id/commands"

$commandData = @()

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
