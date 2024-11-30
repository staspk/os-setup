# Requires -RunAsAdministrator
#Requires -Version 5.1

using module ".\modules\Powershell.psm1"
using module ".\modules\Registry.psm1"
using module ".\modules\VsCode.psm1"

Import-Module $PSScriptRoot\modules\Kozubenko.Utils.psm1 -Force
Import-Module $PSScriptRoot\modules\Powershell.psm1 -Force

Import-Module $PSScriptRoot\modules\Registry.psm1 -Force
Import-Module $PSScriptRoot\modules\WinGet.psm1 -Force
Import-Module $PSScriptRoot\modules\OneDrive.psm1 -Force

$host.ui.RawUI.WindowTitle = "Windows 11 Automatic Configuration  -  23H2"
Clear-Host


# FileExplorerDefaultOpenTo ([FileExplorerLaunchTo]::Downloads)
# ShowRecentInQuickAccess $false
# VisibleFileExtensions "$true"
# VisibleHiddenFiles $true 

# TaskBarAlignment 0
# TaskBarRemoveTaskView
# DisableWidgets

# UninstallBloat
# InstallSoftware
# UninstallAndAttemptAnnihilationOfOneDrive


# $PsConfigurer = [PowershellConfigurer]::new("$PsScriptRoot\.powershell")#.InstallOnlyPowershell5()

# $VsCode = [VsCode]::new("$PsScriptRoot\.vscode").InstallUserSettings()


function GitConfig ($email, $names) {
    git config --global user.email $email
    git config --global user.name $name
}
# GitConfig("staspk@gmail.com", "Stanislav Kozubenko")



Remove-Item $env:LOCALAPPDATA\Microsoft\WindowsApps\python.exe      # Remove MicrosoftStore PythonLauncher that shows as version 0.0.0.0


