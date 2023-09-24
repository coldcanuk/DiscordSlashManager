Sure! Here's the provided markdown content updated with the splatted code:

---

# DiscordSlashManager

DiscordSlashManager is a PowerShell module designed to manage Discord slash commands. This module includes three main cmdlets:

- `New-DiscordSlash`
- `Get-DiscordSlash`
- `Remove-DiscordSlash`

## Installing the Module

To install the module, run the following command in your PowerShell terminal:

```powershell
Install-Module -Name DiscordSlashManager
```

## Importing the Module

To import the module, run the following command in your PowerShell terminal:

```powershell
Import-Module DiscordSlashManager
```

## New-DiscordSlash.ps1

This cmdlet is used to create new slash commands for your Discord bot.

### Usage Instructions for `New-DiscordSlash`

**All parameters including Discord credentials are required to run this script.**

#### How to Run the Cmdlet:

Run the following command in your PowerShell terminal:

```powershell
$params = @{
    CommandNames        = 'post'
    CommandDescriptions = 'Post a message'
    CommandOptions      = @{
        name        = 'message'
        description = 'Your message'
        type        = 3
        required    = $true
    }
    DiscordAppName      = 'YourAppName'
    Token               = 'YourToken'
    client_id           = 'YourClientID'
    guild_id            = 'YourGuildID'
}

New-DiscordSlash @params
```

Or

Run the following command if you have an input object:

```powershell
$params = @{
    InputObject      = <YourObject>
    DiscordAppName   = 'YourAppName'
    Token            = 'YourToken'
    client_id        = 'YourClientID'
    guild_id         = 'YourGuildID'
}

New-DiscordSlash @params
```

Sample InputObject:
Here's a sample input object you can use:

```powershell
@{ name='post'; description='Post a message'; options=@(@{ name='message'; description='Your message'; type=3; required=$true }) }
```

## get-discordslash

This cmdlet fetches all the existing slash commands for your Discord bot and outputs them in JSON format.

### Usage Instructions for `get-discordslash.`

**All parameters including Discord credentials are required to run this script.**

#### How to Run the Cmdlet:

Run the following command in your PowerShell terminal:

```powershell
$paramsGet = @{
    token    = 'YourToken'
    client_id = 'YourClientID'
    guild_id = 'YourGuildID'
    appname = 'YourAppName'
}

get-discordslash @paramsGet
```

## remove-discordslash

This cmdlet is used to remove existing slash commands. You can either remove a single command by its ID or multiple commands using JSON input.

### Usage Instructions for `remove-discordslash`

**All parameters including Discord credentials are required to run this script.**

#### How to Run the Cmdlet:

Run the following command in your PowerShell terminal to remove a specific command:

```powershell
$paramsRemove = @{
    CommandID = 'your_command_id_here'
    token    = 'YourToken'
    client_id = 'YourClientID'
    guild_id = 'YourGuildID'
    appname = 'YourAppName'
}

remove-discordslash @paramsRemove
```

---

*These PowerShell scripts were developed with the assistance of OpenAI and ChatGPT.*
