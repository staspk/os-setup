$TO_INSTALL =
	"Microsoft.Powershell",
	"Microsoft.VisualStudioCode",
	"Notepad++.Notepad++",
	"Git.Git",
	"VideoLAN.VLC",
	"Python.Python.3.13",
	"OpenJS.NodeJS",
	"Rustlang.Rustup"

$TO_UNINSTALL =
	"Copilot",
	"Power Automate",
	"Cortana",
	"Phone Link",
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

function InstallSoftware {
	winget install $TO_INSTALL
}

function UninstallBloat {
	foreach ($name in $TO_UNINSTALL) {
		winget uninstall $name	
	}
}

Export-ModuleMember -Function UninstallBloat, InstallSoftware