# # Requires -RunAsAdministrator
# Requires -Version 5.1


using module ".\modules\Powershell.psm1"
using module ".\modules\Registry.psm1"

Import-Module $PSScriptRoot\modules\Kozubenko.Utils.psm1 -Force
Import-Module $PSScriptRoot\modules\Powershell.psm1 -Force

Import-Module $PSScriptRoot\modules\Registry.psm1 -Force
Import-Module $PSScriptRoot\modules\WinGet.psm1 -Force
Import-Module $PSScriptRoot\modules\OneDrive.psm1 -Force
Import-Module $PSScriptRoot\modules\VsCode.psm1 -Force




# Import-Module $PSScriptRoot\modules\Utilities.Hello.psm1 -Force

$host.ui.RawUI.WindowTitle = "Windows 11 Automatic Configuration  -  23H2"



# FileExplorerDefaultOpenTo ([FileExplorerLaunchTo]::Downloads)
# ShowRecentInQuickAccess $false
# VisibleFileExtensions "$true"
# VisibleHiddenFiles $true 

# TaskBarAlignment 0
# TaskBarRemoveTaskView
# DisableWidgets

# UninstallBloat
# InstallSoftware
# UninstallAndAttemptAnnihilationOfOneDrive     # Use at your own risk. ~10%% chance of failure ... Stan: Double-Check on NEXT WINDOWS (RE)INSTALL, RESEARCH EDGE CASES ! ! !

# WriteErrorExit "Im in main"

$PS_Config = [PowershellConfigurer]::new(".\.powershell")

# $PS_Config | Get-Member *



# ConfigureMyVsCode













