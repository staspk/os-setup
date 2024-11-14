$TO_INSTALL =
	"Microsoft.VisualStudioCode",
	"Notepad++.Notepad++",
	"Git.Git",
	"VideoLAN.VLC"

$TO_UNINSTALL =
	"Copilot",
	"Cortana",
	"Feedback Hub",
	"Game Bar",
	"Get Help",
	"Mail and Calendar",
	"Microsoft Clipchamp",
	"Microsoft Family",
	"Microsoft Journal",
	"Microsoft OneNote - en-us",
	"Microsoft People",
	"Microsoft Sticky Notes",
	"Microsoft Teams",
	"Microsoft Tips",
	"Microsoft To Do",
	"Movies & TV",
	"MSN Weather",
	"News",
	"Outlook for Windows",
	"Quick Assist",
	"Quick Assist",
	"Solitaire & Casual Games",
	"Widgets Platform Runtime",
	"Windows Maps",
	"Xbox",
	"Xbox Game Bar Plugin",
	"Xbox Game Speech Window",
	"Xbox Identity Provider",
	"Xbox TCUI"

function InstallAll {
	winget install $TO_INSTALL
	Write-Host "Installed = $TO_INSTALL"
}

function UninstallBloat {
	foreach ($name in $TO_UNINSTALL) {
		winget uninstall $name	
		Write-Host "Uninstalled = $name"
	}
	
}

Export-ModuleMember -Function UninstallBloat, InstallSoftware