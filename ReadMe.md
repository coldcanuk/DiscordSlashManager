# DiscordSlashManager

DiscordSlashManager is a PowerShell module designed to manage Discord slash commands. This module includes three main cmdlets:

- `new-discordslash.ps1`
- `get-discordslash.ps1`
- `remove-discordslash.ps1`

## new-discordslash.ps1

This cmdlet is used to create new slash commands for your Discord bot.

### Usage

```powershell
.\new-discordslash.ps1 -CommandNames 'command1', 'command2'
```

### Parameters

- `-CommandNames`: An array of command names you want to create.

### Example

```powershell
.\new-discordslash.ps1 -CommandNames 'hello', 'world'
```

## get-discordslash.ps1

This cmdlet fetches all the existing slash commands for your Discord bot and outputs them in JSON format.

### Usage

```powershell
.\get-discordslash.ps1
```

### Example

```powershell
.\get-discordslash.ps1
```

## remove-discordslash.ps1

This cmdlet is used to remove existing slash commands. You can either remove a single command by its ID or multiple commands using JSON input.

### Usage

To remove a single command:

```powershell
.\remove-discordslash.ps1 -CommandID "your_command_id_here"
```

To remove multiple commands:

```powershell
.\remove-discordslash.ps1 -JsonInput (.\get-discordslash.ps1)
```

### Parameters

- `-CommandID`: The ID of the command you want to remove.
- `-JsonInput`: JSON formatted string containing the IDs of the commands you want to remove.

### Examples

```powershell
.\remove-discordslash.ps1 -CommandID "1234567890"
```

```powershell
.\remove-discordslash.ps1 -JsonInput (.\get-discordslash.ps1)
```

*This PowerShell module was developed with the assistance of OpenAI and ChatGPT.*