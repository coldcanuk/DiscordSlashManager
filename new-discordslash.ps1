# Parameters
param (
    [string[]]$CommandNames,
    [string[]]$CommandDescriptions,
    [hashtable[]]$CommandOptions,
    [psobject]$InputObject,
    [string]$DiscordAppName,
    [string]$token,
    [string]$client_id,
    [string]$guild_id,
    [switch]$debug
)

$ErrorActionPreference = "Stop"

# Function to show usage
function Show-Usage {
    Write-Host "All parameters including Discord credentials are required to run this script." -ForegroundColor Yellow
    Write-Host "Here's how you can run this cmdlet:" -ForegroundColor Yellow
    Write-Host ""
    Write-Host ".\new-discordslash.ps1 -CommandNames 'post' "
    Write-Host "                   -CommandDescriptions 'Post a message' "
    Write-Host "                   -CommandOptions @{ name='message'; description='Your message'; type=3; required=`$true } "
    Write-Host "                   -DiscordAppName YourAppName "
    Write-Host "                   -token YourToken "
    Write-Host "                   -client_id YourClientID "
    Write-Host "                   -guild_id YourGuildID" 
    Write-Host ""
    Write-Host "Or" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Usage: .\new-discordslash.ps1 -InputObject <YourObject> "
    Write-Host "                             -DiscordAppName YourAppName "
    Write-Host "                             -token YourToken "
    Write-Host "                             -client_id YourClientID "
    Write-Host "                             -guild_id YourGuildID"
    Write-Host ""
    Write-Host "Sample InputObject: @{ name='post'; description='Post a message'; options=@(@{ name='message'; description='Your message'; type=3; required=`$true }) }" -ForegroundColor Cyan
    write-host ""
    exit
}

# Check if mandatory parameters are empty
if (-not $CommandNames -and -not $InputObject -or -not $DiscordAppName -or -not $token -or -not $client_id -or -not $guild_id) {
    Show-Usage
}

# Remove spaces from DiscordAppName
$DiscordAppName = $DiscordAppName -replace '\s',''

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
