using module ".\Windows11\modules\Powershell.psm1"
using module ".\Windows11\modules\VsCode.psm1"

$configurer = [PowershellConfigurer]::new().SaveProfileFilesToScriptPackage()
$VsCode = [VsCode]::new().BackupVsCode()

$commitMessage = "Powershell/VsCode Settings Backup"

Push $commitMessage