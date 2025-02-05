using module ".\Windows11\modules\Powershell.psm1"
using module ".\Windows11\modules\VsCode.psm1"

param(
    $commitMessage
)

$configurer = [PowershellConfigurer]::new().SaveProfileFilesToScriptPackage()
$VsCode = [VsCode]::new().BackupVsCode()

if($commitMessage -eq $null) {
    $commitMessage = "Powershell/VsCode Settings Backup"
}


Push $commitMessage