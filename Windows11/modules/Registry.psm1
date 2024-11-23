function NewRegistryKey($path, $name) {
	if (-not (Test-Path $path)) {
		New-Item -Path $path -Name $name
	}
	else { Write-Host "New Registry Function used, but registry key already exists. Path: $path. Name: $name" }
}

function RegistryPropertyEditOrAdd($path, $name, $value, $propertyType = "DWORD") {
	$exists =  If ((Get-Item $path).property -match $propName) {"true"}

	if($exists) {
		Set-ItemProperty -Path $path -Name $name -Value $value  }
	else {
		New-ItemProperty -Path $path -Name $name -PropertyType $propertyType -Value $value  | Out-Null  }
}


enum FileExplorerLaunchTo {  ThisPC = 1; QuickAccess = 2; Downloads = 3  }
function FileExplorerDefaultOpenTo([FileExplorerLaunchTo]$launchTo = [FileExplorerLaunchTo]::Downloads) { 
	[int]$enumAsInt = [Enum]::Parse([FileExplorerLaunchTo], $launchTo)

	RegistryPropertyEditOrAdd $EXPLORER_ADVANCED "LaunchTo" $enumAsInt

	Write-Host "FILE EXPLORER: will now default-open to: $launchTo"
}

function ShowRecentInQuickAccess( [ValidateRange(0, 1)] $bool = 0 ) { 
	$path = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer"
	$propName = "ShowRecent"

	RegistryPropertyEditOrAdd $path $propName $bool

	if ($bool -eq 0) {	Write-Host "FILE EXPLORER: Will stop automatically populating Quick Access with Recently Used Directories/Files" -ForegroundColor Green	 }
	elseif ($bool -eq 1) {	Write-Host "FILE EXPLORER: Quick Access will now be automatically populated with Recently Used Files [preset win11 behavior]" -ForegroundColor Green  }
}

function VisibleFileExtensions( [ValidateRange(0, 1)] $bool = 0) {
	$path = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
	$propName = "HideFileExt"

	RegistryPropertyEditOrAdd $path $propName $bool

	Write-Host "FILE EXPLORER: File's format/extension (in)visibility boolean status updated to: $bool" -ForegroundColor Green
}

function VisibleHiddenFiles( [ValidateRange(0, 1)] $bool = 1) {
	$path = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
	$propName = "Hidden"

	RegistryPropertyEditOrAdd $path $propName $bool

	Write-Host "FILE EXPLORER: Hidden files & folders boolean status set to: $bool." -ForegroundColor Green
}


function TaskBarAlignment([ValidateRange(0, 1)] $alignment = 0) {
	$path = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
	$propName = "TaskbarAl"

	RegistryPropertyEditOrAdd $path $propName $alignment

	if ($alignment -eq 0) {  Write-Host "TASKBAR: Alignment set to left." -ForegroundColor Green  }
	elseif ($alignment -eq 1) {  Write-Host "TASKBAR: Alignment set to center." -ForegroundColor Green  }
	
}

function TaskBarRemoveTaskView {
	$path = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
	$propName = "ShowTaskViewButton"

	ChangeRegistryValue $path $propName 0

	Write-Host "TASKBAR: Task View Removed"
}

function DisableWidgets {
	$path = "HKLM:\SOFTWARE\Policies\Microsoft"
	$key = "DSH";  $propName = "AllowNewsAndInterests"

	NewRegistryKey $path $key
	RegistryPropertyEditOrAdd "$path\$key" $propName 0
	
	Write-Host "Disabled Widgets. Please restart Computer to finalize changes." -ForegroundColor Green
}


Export-ModuleMember -Function FileExplorerDefaultOpenTo, ShowRecentInQuickAccess, VisibleFileExtensions, VisibleHiddenFiles, TaskBarAlignment, TaskBarRemoveTaskView, DisableWidgets

