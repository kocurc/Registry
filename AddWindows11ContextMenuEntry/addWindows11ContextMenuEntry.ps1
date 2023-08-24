<#
    .SYNOPSIS
    Add Windows 11 context menu entry that exists under the Show more options

    .PARAMETER contextMenuEntryName
    Name of the context menu entry

    .PARAMETER executableFilePath
    Either full path to the executable or executable name (for $env:PATH environment variable executables)
#>

param (
    [Parameter(Mandatory=$true)]
    [string]$contextMenuEntryName,

    [Parameter(Mandatory=$true)]
    [string]$executableFilePath
)

$contextMenuRegistryPath = "Registry::HKEY_CLASSES_ROOT\Directory\Background\shell"
$contextMenuEntryPath = "$contextMenuRegistryPath\$contextMenuEntryName"
$command = "command"

if (Test-Path $contextMenuEntryPath)
{
    throw "Context menu with the name: $contextMenuEntryName already exists."
}

New-Item -Path $contextMenuRegistryPath -Name $contextMenuEntryName | Out-Null
New-Item -Path $contextMenuEntryPath -Name $command | Out-Null
Set-Item -Path "$contextMenuEntryPath\$command" -Value $executableFilePath
New-ItemProperty -Path $contextMenuEntryPath -Name "Icon" -Value $executableFilePath | Out-Null
Write-Host "Context menu entry was added"
