# Show-Usage-Remove
function Show-Usage-Remove {
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
# Show-Usage-Get
function Show-Usage-Get {
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
# Show-Usage-New
function Show-Usage-New {
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
# get-discordslash
function Get-DiscordSlash {
    param (
        [string]$token,
        [string]$client_id,
        [string]$guild_id,
        [string]$appname
    )
    $ErrorActionPreference = "Stop"

    if (-not $token -or -not $client_id -or -not $guild_id -or -not $appname) {
        Show-Usage-Get
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
}

# new-discordslash
function New-DiscordSlash {
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

        # Check if mandatory parameters are empty
        if (-not $CommandNames -and -not $InputObject -or -not $DiscordAppName -or -not $token -or -not $client_id -or -not $guild_id) {
            Show-Usage-New
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
    }

# remove-discordslash
function Remove-DiscordSlash {
    param (
        [string]$CommandID,
        [string]$JsonInput,
        [string]$token,
        [string]$client_id,
        [string]$guild_id,
        [string]$appname
    )

    $ErrorActionPreference = "Stop"

    if (-not $CommandID -and -not $JsonInput -or -not $token -or -not $client_id -or -not $guild_id -or -not $appname) {
        Show-Usage-Remove
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
}
Export-ModuleMember -Function Get-DiscordSlash, New-DiscordSlash, Remove-DiscordSlash