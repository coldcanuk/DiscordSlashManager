# remove-discordslash.ps1

param (
    [string]$CommandID,
    [string]$JsonInput,
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
    Write-Host ".\remove-discordslash.ps1 -CommandID 'your_command_id_here' "
    Write-Host "                          -token YourToken "
    Write-Host "                          -client_id YourClientID "
    Write-Host "                          -guild_id YourGuildID "
    Write-Host "                          -appname YourAppName"
    Write-Host ""
    Write-Host "Or (This will remove all commands)" -ForegroundColor Red
    Write-Host ""
    Write-Host ".\remove-discordslash.ps1 -JsonInput (.\get-discordslash.ps1 -token YourToken -client_id YourClientID -guild_id YourGuildID -appname YourAppName) "
    Write-Host "                          -token YourToken "
    Write-Host "                          -client_id YourClientID "
    Write-Host "                          -guild_id YourGuildID "
    Write-Host "                          -appname YourAppName" 
    write-host ""
    exit
}

if (-not $CommandID -and -not $JsonInput -or -not $token -or -not $client_id -or -not $guild_id -or -not $appname) {
    Show-Usage
}

[string]$ua = $appname + "/1.0"

$headers = @{
    "Authorization" = ("Bot " + $token)
    "Accept" = "*/*"
    "User-Agent" = $ua
}

if ($CommandID) {
    $uri = "https://discord.com/api/v10/applications/$client_id/guilds/$guild_id/commands/$CommandID"
    try {
        Invoke-RestMethod -Method Delete -Headers $headers -Uri $uri
        Write-Host "Successfully deleted command with ID $CommandID."
    } catch {
        Write-Host $_.Exception.Message
    }
}

[int64]$intCount = 0
if ($JsonInput) {
    $commandsToDelete = $JsonInput | ConvertFrom-Json
    foreach ($command in $commandsToDelete) {
        if ($intCount -eq 2) {
            Write-Host "Sleeping for 2 seconds to avoid a TooManyRequest error from the endpoint"
            Start-Sleep -Seconds 2
            [int64]$intCount = 0
        }
        $uri = "https://discord.com/api/v10/applications/$client_id/guilds/$guild_id/commands/$($command.CommandID)"
        try {
            Invoke-RestMethod -Method Delete -Headers $headers -Uri $uri
            Write-Host "Successfully deleted command with ID $($command.CommandID)."
        } catch {
            Write-Host $_.Exception.Message
        }
        $intCount++
    }
}
