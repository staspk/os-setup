# # Requires -RunAsAdministrator
#Requires -Version 5.1

using module ".\modules\Registry.psm1"  # Necessary to import enums/classes
Import-Module $PSScriptRoot\modules\Registry.psm1 -Force
Import-Module $PSScriptRoot\modules\WinGet.psm1 -Force
Import-Module $PSScriptRoot\modules\OneDrive.psm1 -Force
Import-Module $PSScriptRoot\modules\VsCode.psm1 -Force
Import-Module $PSScriptRoot\modules\Powershell.psm1 -Force

$host.ui.RawUI.WindowTitle = "Windows 11 Automatic Configuration  -  23H2"
Clear-Host


FileExplorerDefaultOpenTo ([FileExplorerLaunchTo]::Downloads)
# ShowRecentInQuickAccess $false
# VisibleFileExtensions "$true"
# VisibleHiddenFiles $true 

# TaskBarAlignment 0
# TaskBarRemoveTaskView
# DisableWidgets

# UninstallBloat
# InstallSoftware

# ! ! !  Check MoveOneDriveFoldersToUserHome function on NEXT WINDOWS (RE)INSTALL, as assumptions on directory structures of $ONEDRIVE/$USERHOME are unknown after OneDrive uninstall ! ! !
# UninstallAndAttemptAnnihilationOfOneDrive

# ConfigureMyVsCode

# SetupMyPowershellProfile $PSScriptRoot\pwsh-settings









