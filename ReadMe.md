# DiscordSlashManager

DiscordSlashManager is a PowerShell module designed to manage Discord slash commands. This module includes three main cmdlets:

- `new-discordslash.ps1`
- `get-discordslash.ps1`
- `remove-discordslash.ps1`

## new-discordslash.ps1

This cmdlet is used to create new slash commands for your Discord bot.

### Usage Instructions for `new-discordslash.ps1`

**All parameters including Discord credentials are required to run this script.**

#### How to Run the Cmdlet:

Run the following command in your PowerShell terminal:

```powershell
.\new-discordslash.ps1 -CommandNames 'post' \
                       -CommandDescriptions 'Post a message' \
                       -CommandOptions @{ name='message'; description='Your message'; type=3; required=$true } \
                       -DiscordAppName YourAppName \
                       -token YourToken \
                       -client_id YourClientID \
                       -guild_id YourGuildID
```
Or

Run the following command if you have an input object:
```powershell
.\new-discordslash.ps1 -InputObject <YourObject> \
                       -DiscordAppName YourAppName \
                       -token YourToken \
                       -client_id YourClientID \
                       -guild_id YourGuildID
```
Sample InputObject:
Here's a sample input object you can use:
```powershell
@{ name='post'; description='Post a message'; options=@(@{ name='message'; description='Your message'; type=3; required=$true }) }
```

## get-discordslash.ps1

This cmdlet fetches all the existing slash commands for your Discord bot and outputs them in JSON format.

### Usage Instructions for `get-discordslash.ps1`

**All parameters including Discord credentials are required to run this script.**

#### How to Run the Cmdlet:

Run the following command in your PowerShell terminal:

```powershell
.\get-discordslash.ps1 -token 'YourToken' \
                       -client_id 'YourClientID' \
                       -guild_id 'YourGuildID' \
                       -appname 'YourAppName'
```

## remove-discordslash.ps1

This cmdlet is used to remove existing slash commands. You can either remove a single command by its ID or multiple commands using JSON input.

### Usage Instructions for `remove-discordslash.ps1`

**All parameters including Discord credentials are required to run this script.**

#### How to Run the Cmdlet:

Run the following command in your PowerShell terminal to remove a specific command:

```powershell
.\remove-discordslash.ps1 -CommandID 'your_command_id_here' \
                          -token YourToken \
                          -client_id YourClientID \
                          -guild_id YourGuildID \
                          -appname YourAppName
```


*These PowerShell scripts were developed with the assistance of OpenAI and ChatGPT.*