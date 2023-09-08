# Parameters
param (
    [string[]]$CommandNames,
    [string[]]$CommandDescriptions,
    [hashtable[]]$CommandOptions,
    [psobject]$InputObject,
    [string]$DiscordAppName,
    [switch]$debug
)

$ErrorActionPreference = "Stop"

# Function to show usage
function Show-Usage {
    Write-Host "Your DiscordAppName will be used as part of the user agent string. Please avoid characters that would impact User-Agent"
    Write-Host "Usage: .\new-discordslash.ps1 -CommandNames 'post' -CommandDescriptions 'Post a message' -CommandOptions @{ name='message'; description='Your message'; type=3; required=`$true } -DiscordAppName YourAppName"
    Write-Host "Or"
    Write-Host "Usage: .\new-discordslash.ps1 -InputObject <YourObject> -DiscordAppName YourAppName"
    exit
}

# Check if mandatory parameters are empty
if (-not $CommandNames -and -not $InputObject -or -not $DiscordAppName) {
    Show-Usage
}

# Remove spaces from DiscordAppName
$DiscordAppName = $DiscordAppName -replace '\s',''

# Read the config.csv file to get Discord credentials
$config = Get-Content .\config.csv | ConvertFrom-Csv
$token = ($config | Where-Object {$_.varName -eq "DISCORD_TOKEN"}).varValue
$client_id = ($config | Where-Object {$_.varName -eq "DISCORD_CLIENT_ID"}).varValue
$guild_id = ($config | Where-Object {$_.varName -eq "DISCORD_GUILD_ID"}).varValue

# Prepare the headers
$headers = @{
    "Authorization" = ("Bot " + $token)
    "Accept" = "*/*"
    "User-Agent" = ($DiscordAppName + "/1.0")
}

# Function to register command
function Register-Command ($name, $description, $options) {
    $commandObj = @{
        name = $name
        description = $description
        type = 1
        options = @($options)
    }

    $json = $commandObj | ConvertTo-Json
    $uri = "https://discord.com/api/v10/applications/$client_id/guilds/$guild_id/commands"

    if ($debug) {
        Write-Host "URI: $uri"
        Write-Host "JSON: $json"
        Write-Host "HEADERS: $headers"
    }

    try {
        Invoke-RestMethod -Method Post -Headers $headers -Uri $uri -Body $json -ContentType 'application/json'
    } catch {
        if ($debug) {
            Write-Host $_.Exception.Response.StatusCode.Value__
            Write-Host $_.Exception.Message
            Write-Host $_.Exception.Response.Headers["X-RateLimit-Limit"]
            Write-Host $_.Exception.Response.Headers["X-RateLimit-Remaining"]
            Write-Host $_.Exception.Response.Headers["X-RateLimit-Reset"]
        } else {
            Write-Host $_.Exception.Message
        }
    }
}

# Register each command
if ($InputObject) {
    Register-Command $InputObject.name $InputObject.description $InputObject.options
} else {
    for ($i=0; $i -lt $CommandNames.Length; $i++) {
        $name = $CommandNames[$i]
        $description = $CommandDescriptions[$i]
        $options = $CommandOptions[$i]
        Register-Command $name $description $options
    }
}

# Clean up
Remove-Variable -Name config