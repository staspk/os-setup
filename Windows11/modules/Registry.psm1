# Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion		"Registry::" may work to save it all?
$EXPLORER_ADVANCED = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
$POLICIES_MICROSOFT = "HKLM:\SOFTWARE\Policies\Microsoft"
$TOUCHED_KEYS = $EXPLORER_ADVANCED, $POLICIES_MICROSOFT

$BACKUP_FOLDER = ".\registry-backup"
$BACKUP_FILE = "$BACKUP_FOLDER\registry-backup.reg"

function BackupRegistry {
	mkdir -Force $BACKUP_FOLDER
	foreach($key in $TOUCHED_KEYS) {
		$key = $key.Replace(":","")
		reg export $key $BACKUP_FOLDER\$key 
	}
	Write-Host "Backup of Registry has been exported to $BACKUP_FILE"
}

function RestoreRegistry($from = $BACKUP_FILE) {	#Unfinished. Wanna use functionality, finish it
	reg import $from
	Write-Host "Registry has been updated from backup file: $from"
}

function NewRegistryKey($path, $name) {
	New-Item -Path $path -Name $name
}

function NewDword($path, $name, $value) {
	New-ItemProperty -Path $path -Name $name -PropertyType "DWORD" -Value $value  | out-null
}

function ChangeRegistryValue($path, $name, $value) {
	Set-ItemProperty -Path $path -Name $name -Value $value
}


function FileExplorerDefaultOpenTo($default = 3) {	# 1=ThisPC, 2=QuickAccess, 3=Downloads
	NewDword $EXPLORER_ADVANCED "LaunchTo" $default
	Write-Host "FILE EXPLORER: will now default-open to Downloads"
}

function VisibleFileExtensions($hideFileExt = 0) {	#hideFileExt=1 for opposite effect
	ChangeRegistryValue $EXPLORER_ADVANCED "HideFileExt" $hideFileExt
	Write-Host "FILE EXPLORER: File's format/extension will now be visible in file names."
}

function VisibleHiddenFiles($hidden = 1) {	#hidden=2 for opposite effect
	ChangeRegistryValue $EXPLORER_ADVANCED "Hidden" $hidden
	Write-Host "FILE EXPLORER: Hidden files & folders will now be visible."
}



function TaskBarAlignment($alignment = 0) {
	ChangeRegistryValue $EXPLORER_ADVANCED "TaskbarAl" $alignment
	Write-Host "TASKBAR: Alignment set to left."
}

function TaskBarRemoveTaskView {
	ChangeRegistryValue $EXPLORER_ADVANCED "ShowTaskViewButton" 0
}


function DisableWidgets {
	$KEY = "Dsh"
	NewRegistryKey $POLICIES_MICROSOFT $KEY
	NewDword "$POLICIES_MICROSOFT\$KEY" "AllowNewsAndInterests" 0 
	Write-Host "Disabled Widgets. Please restart Computer to finalize changes."
}



Export-ModuleMember -Function BackupRegistry, RestoreRegistry, VisibleFileExtensions, VisibleHiddenFiles, FileExplorerDefaultOpenTo, TaskBarAlignment, TaskBarRemoveTaskView, DisableWidgets

