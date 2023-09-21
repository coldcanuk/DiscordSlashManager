@{
    RootModule = 'DiscordSlashManager.psm1'
    ModuleVersion = '1.3.5'
    GUID = '1d176fd1-aea9-47d2-88ce-23ca20b2cf59'
    Author = 'Chuck'
    CompanyName = 'Individual'
    Copyright = 'GNU GPLv3'
    Description = 'Elevate your Discord experience with DiscordSlashManager. Seamlessly create, manage, and remove slash commands directly from PowerShell. Your gateway to smarter Discord interactions. Want to contribute? Join us on GitHub!'
    PowerShellVersion = '5.1'
    FunctionsToExport = @('Get-DiscordSlash', 'New-DiscordSlash', 'Remove-DiscordSlash')
    PrivateData = @{
        PSData = @{
            Tags = @('Discord', 'SlashCommands', 'Social', 'Communication', 'API', 'ChatOps', 'Automation', 'Powershell', 'JSON', 'Messaging')
            LicenseUri = 'https://github.com/coldcanuk/DiscordSlashManager/blob/main/LICENSE'
            ProjectUri = 'https://github.com/coldcanuk/DiscordSlashManager'
            IconUri = 'https://raw.githubusercontent.com/coldcanuk/DiscordSlashManager/main/dsmicon128_128.png'
        }
    }
}
