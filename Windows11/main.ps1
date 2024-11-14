# #Requires -RunAsAdministrator
#Requires -Version 5.1
Import-Module $PSScriptRoot\modules\Registry.psm1 -Force
Import-Module $PSScriptRoot\modules\WinGet.psm1 -Force
Import-Module $PSScriptRoot\modules\OneDrive.psm1 -Force
Import-Module $PSScriptRoot\modules\VsCode.psm1 -Force

$host.ui.RawUI.WindowTitle = "Windows 11 Automatic Configuration    -    23H2, Build Version: 10.0.22631"
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

# Use at your own peril. Guesswork was used in assuming directory structures after OneDrive uninstall. FIX ON NEXT WINDOWS (RE)INSTALL ! ! !
# UninstallAndDestroyOneDrive   

# ConfigureMyVsCode

SetupMyPowershellProfile





