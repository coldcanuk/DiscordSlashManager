# new-discordslash.ps1

## Description

This PowerShell script allows you to easily register new slash commands for your Discord bot. Eventually it will be part of a module that also includes `get-discordslash.ps1` and `remove-discordslash.ps1`.

## Requirements

- PowerShell 5.1 or higher
- A Discord bot token, client ID, and guild ID
- A CSV file named `config.csv` containing your Discord bot's credentials

## Usage

Run the script from your PowerShell terminal:

```
.\new-discordslash.ps1 -CommandNames 'command1'
```

For multiple slash commands at once:

```
.\new-discordslash.ps1 -CommandNames 'command1', 'command2'
```

For debug output:

```
.\new-discordslash.ps1 -CommandNames 'command1', 'command2' -debug
```

## Credits

This script was developed with the assistance of OpenAI's API and OpenAI's ChatGPT.