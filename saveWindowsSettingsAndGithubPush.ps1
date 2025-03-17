using module ".\Windows11\modules\VsCode.psm1"

param(
    $commitMessage
)

$VsCode = [VsCode]::new().BackupVsCode()

if($commitMessage -eq $null) {
    $commitMessage = "VsCode Settings Backup"
}


Push $commitMessage