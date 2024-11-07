# OS-Setup

## Description
- Collection of scripts and files to setup/debloat/customize an OS and necessary software on a clean install.

### Windows 11 Instructions

- Uncomment desired functionality in: .\main.ps1.
	- Registry functions have a default param. Comments on alternate values/behaviors found in: .\modules\Registry.psm1
	- Change List of bloat/software to uninstall/install in: .\modules\Winget.psm1
- Run Powershell as Admin. Run the script ./main.ps1. Note: Powershell 5.1 required, the current default pre-installed version on all Win11 machines.
- VSCode:
	- Download ‘One Monokai Theme' extension
	- Ctrl+Shift+P -> “Preferences: Open User Settings (JSON)”
	- Copy/Paste contents of vscode-theme-settings.json