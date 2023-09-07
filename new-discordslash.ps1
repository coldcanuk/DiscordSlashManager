# Command Names parameter
param (
    [string[]]$CommandNames
)

$ErrorActionPreference = "Stop"

# Check if CommandNames parameter is empty
if (-not $CommandNames) {
    Write-Host ".\new-discordslash.ps1 -CommandNames 'post', 'fun'"
    exit
}

$config = @()
$config = Get-Content .\config.csv | ConvertFrom-Csv

$token = ($config | Where-Object {$_.varName -match "DISCORD_TOKEN"}).varValue
$client_id = ($config | Where-Object {$_.varName -match "DISCORD_CLIENT_ID"}).varValue
$guild_id = ($config | Where-Object {$_.varName -match "DISCORD_GUILD_ID"}).varValue

<#
$headers = @{
    "Authorization" = "Bot $token"
}
/#>
$headers = @{
    "Authorization" = ("Bot " + $token)
    "Accept" = "*/*"
    "User-Agent" = "PostEngineers/1.0"
}


# Register each command
foreach ($command in $CommandNames) {
    $json = @{
        name        = $command
        description = "My $command command"
        type = 1
    } | ConvertTo-Json -Compress

    $uri = "https://discord.com/api/v10/applications/$client_id/guilds/$guild_id/commands"

    Write-Host "URI: $uri"
    Write-Host "JSON: $json"
    Write-Host "HEADERS: " $headers

    try {
        $response = Invoke-RestMethod -Method Post -Headers $headers -Uri $uri -Body $json -ContentType 'application/json; charset=utf-8'
        Write-Host $response
    } catch {
        Write-Host $_.Exception.Response.StatusCode.Value__
        Write-Host $_.Exception.Message
        Write-Host $_.Exception.Response.Headers["X-RateLimit-Limit"]
        Write-Host $_.Exception.Response.Headers["X-RateLimit-Remaining"]
        Write-Host $_.Exception.Response.Headers["X-RateLimit-Reset"]
        Write-Host $_.Exception
    }
}
remove-variable -name config
