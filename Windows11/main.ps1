#Requires -RunAsAdministrator
#Requires -Version 5.1
Import-Module $PSScriptRoot\modules\Registry.psm1 -Force
Import-Module $PSScriptRoot\modules\WinGet.psm1 -Force
Import-Module $PSScriptRoot\modules\OneDrive.psm1 -Force
Import-Module $PSScriptRoot\modules\VsCode.psm1 -Force

$host.ui.RawUI.WindowTitle = "Windows 11 Automatic Configuration  -  23H2"
Clear-Host



# BackupRegistry
# RestoreRegistry   #Finish this function if you want the functionality, future Stan. I'm done with this this for now.


# FileExplorerDefaultOpenTo
# VisibleFileExtensions
# VisibleHiddenFiles

# TaskBarAlignment
# TaskBarRemoveTaskView
# DisableWidgets

# UninstallBloat
# InstallSoftware

# Use at your own peril. Assumptions on directory structures of $ONEDRIVE/$USERHOME must be double-chcked on NEXT WINDOWS (RE)INSTALL ! ! !
# Check MoveOneDriveFoldersToUserHome function before proceeding
# todo: remove OneDrive environment var? Remove from Explorer sidebar?
# UninstallAndAttemptAnnihilationOfOneDrive

# ConfigureMyVsCode

# SetupMyPowershellProfile





