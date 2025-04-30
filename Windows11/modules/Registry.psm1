function NewRegistryKey($path, $keyName) {
	if (-not(Test-Path "$path\$keyName")) {
		New-Item -Path $path -Name $name | Out-Null
		# PrintGreen "Registry: Key [$keyName] Created at: $path\$keyName"
	}
	else {
		# PrintRed "Registry: NewRegistryKey skipped since Key [$keyName] already exists at: $path\$keyName"
	}
}

function RegistryPropertyEditOrAdd($path, $propertyName, [int]$value, $propertyType = "DWORD") {
	$exists =  If ((Get-Item $path).property -match $propertyName) {"true"}

	if($exists) {
		Set-ItemProperty -Path $path -Name $propertyName -Value $value  }
	else {
		New-ItemProperty -Path $path -Name $propertyName -PropertyType $propertyType -Value $value | Out-Null  }
}

enum FileExplorerLaunchTo {  ThisPC = 1; QuickAccess = 2; Downloads = 3  }
function FileExplorerDefaultOpenTo( [FileExplorerLaunchTo] $launchTo = "Downloads") { 
	$path = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"

	RegistryPropertyEditOrAdd $path "LaunchTo" $launchTo.value__
	PrintCyan("FILE EXPLORER: will now default-open to: $launchTo")
}

function ShowRecentInQuickAccess([bool]$bool = $false ) { 
	$path = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer"
	$propName = "ShowRecent"

	RegistryPropertyEditOrAdd $path $propName $bool

	if ($bool) { PrintCyan("FILE EXPLORER: Quick Access will now be automatically populated with Recently Used Files [preset win11 behavior]") }
	else {
		PrintCyan("FILE EXPLORER: Will stop automatically populating Quick Access with Recently Used Directories/Files")
	}
}

function VisibleFileExtensions([bool] $bool = $true) {
	$path = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
	$propName = "HideFileExt"

	$propVal = If ($bool) { 0 } Else { 1 }

	RegistryPropertyEditOrAdd $path $propName $propVal

	PrintCyan("FILE EXPLORER: File's format/extension visibility boolean status updated to $bool")
}

function VisibleHiddenFiles([bool]$bool = $true) {
	$path = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
	$propName = "Hidden"
	
	$propVal = If ($bool) { 0 } Else { 1 }

	RegistryPropertyEditOrAdd $path $propName $propVal

	PrintCyan("FILE EXPLORER: Hidden files & folders boolean status set to: $bool")
}


enum Alignment { Left = 0; Center = 1 }
function TaskBarAlignment([Alignment]$alignment = [Alignment]::Left) {
	$path = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
	$propName = "TaskbarAl"

	RegistryPropertyEditOrAdd $path $propName $alignment.value__

	PrintCyan("TASKBAR: Alignment set to: $alignment")
}

function TaskBarRemoveTaskView {
	$path = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
	$propName = "ShowTaskViewButton"

	RegistryPropertyEditOrAdd $path $propName 0

	PrintCyan("TASKBAR: Task View Removed")
}

function DisableRecommendedAdsInStartMenu() {
	$path = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\TaskbarDeveloperSettings"
	$propName = "HideRecommendedSection"
	$value = 1

	RegistryPropertyEditOrAdd $path $propName 1
}

function DisableAdsInSearchBar {
	$path = "HKCU:\Software\Policies\Microsoft\Windows"
	$keyName = "Explorer"
	$propName = "DisableSearchBoxSuggestions"

	NewRegistryKey $path $keyName
	RegistryPropertyEditOrAdd "$path\$keyName" $propName 1

	PrintCyan("TASKBAR: Ads disabled in Search Bar")
}

function DisableWidgets($enable = $false) {
	$path = "HKLM:\SOFTWARE\Policies\Microsoft"
	$key = "DSH";  $propName = "AllowNewsAndInterests"

	NewRegistryKey $path $key
	RegistryPropertyEditOrAdd "$path\$key" $propName 0

	if ($enable) {  Remove-Item  "$path\$key" }
	else {
		PrintGreen "Disabled Widgets. Please RESTART Computer to finalize."
	}
}

function SetVerticalScrollSpeed([int]$scrollSpeed = 3) {
	$path = "HKCU:\Control Panel\Desktop"
	$propName = "WheelScrollLines"

	Set-ItemProperty -Path $path -Name $propName -Value $scrollSpeed
	PrintCyan "Registry: Vertical Scroll Speed set to $scrollSpeed. Changes will take effect after Computer Restart"
}

function RestoreClassicContextMenu([bool]$reverse = $false) {
	$guid = "{86CA1AA0-34AA-4E8B-A509-50C905BAE2A2}" 
	if(-not($reverse)) {
		New-Item -Path "HKCU:\Software\Classes\CLSID\" 		-Name $guid 					| Out-Null
		New-Item -Path "HKCU:\Software\Classes\CLSID\$guid" -Name InprocServer32 -Value "" 	| Out-Null
	}
	else {
		Remove-Item -Path "HKCU:\Software\Classes\CLSID\$guid" -Recurse -Force -ErrorAction SilentlyContinue
	}
}

function RestartExplorer {
	Stop-Process -Name explorer -Force -ErrorAction SilentlyContinue
	Start-Process explorer
}


Export-ModuleMember -Function FileExplorerDefaultOpenTo, ShowRecentInQuickAccess, VisibleFileExtensions, VisibleHiddenFiles,
TaskBarAlignment, TaskBarRemoveTaskView, DisableRecommendedAdsInStartMenu, DisableAdsInSearchBar, DisableWidgets,
SetVerticalScrollSpeed, RestoreClassicContextMenu,
RestartExplorer

