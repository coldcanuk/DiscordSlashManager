@{
    RootModule = 'DiscordSlashManager.psm1'
    ModuleVersion = '1.3.3'
    GUID = '1d176fd1-aea9-47d2-88ce-23ca20b2cf59'
    Author = 'Chuck'
    CompanyName = 'Individual'
    Copyright = 'GNU GPLv3'
    Description = 'Discord Slash Command Manager, allows the end-user to get their current slash commands, register a new one or remove. You can find the repo on GitHub at https://github.com/coldcanuk/DiscordSlashManager'
    PowerShellVersion = '5.1'
    Tags = 'Discord', 'SlashCommands', 'Social', 'Communication', 'API', 'ChatOps', 'Automation', 'Powershell', 'JSON', 'Messaging'
    FunctionsToExport = @('Get-DiscordSlash', 'New-DiscordSlash', 'Remove-DiscordSlash')
    LicenseUri = 'https://github.com/coldcanuk/DiscordSlashManager/blob/main/LICENSE'
    ProjectUri = 'https://github.com/coldcanuk/DiscordSlashManager'
}