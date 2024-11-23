# # Requires -RunAsAdministrator
#Requires -Version 5.1
Clear-Host

# using module .\modules\Registry.psm1


Import-Module $PSScriptRoot\modules\Registry.psm1 -Force
Import-Module $PSScriptRoot\modules\WinGet.psm1 -Force
Import-Module $PSScriptRoot\modules\OneDrive.psm1 -Force
Import-Module $PSScriptRoot\modules\VsCode.psm1 -Force
Import-Module $PSScriptRoot\modules\Powershell.psm1 -Force

$host.ui.RawUI.WindowTitle = "Windows 11 Automatic Configuration  -  23H2"
# Clear-Host


FileExplorerDefaultOpenTo # ([FileExplorerLaunchTo]::Downloads)

# ShowRecentInQuickAccess
# VisibleFileExtensions 
# VisibleHiddenFiles    

# TaskBarAlignment
# TaskBarRemoveTaskView
# DisableWidgets

# UninstallBloat
# InstallSoftware

# Use at your own peril. Assumptions on directory structures of $ONEDRIVE/$USERHOME must be double-checked on NEXT WINDOWS (RE)INSTALL ! ! !
# Check MoveOneDriveFoldersToUserHome function before proceeding
# todo: remove OneDrive environment var? Remove from Explorer sidebar?
# UninstallAndAttemptAnnihilationOfOneDrive

# ConfigureMyVsCode

# SetupMyPowershellProfile $PSScriptRoot\pwsh-settings







