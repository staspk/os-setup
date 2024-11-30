# OS-Setup

## Description
- Collection of scripts and files to setup/debloat/customize an OS and necessary software on a clean install.

### Windows 11 Instructions

- Uncomment desired functionality in: .\main.ps1.
	- Change List of bloat/software to uninstall/install in: .\modules\Winget.psm1
	- In Registry functions with enum params, call like so: `FileExplorerDefaultOpenTo ([FileExplorerLaunchTo]::Downloads)`.  
	  For alternate values/behaviors, see: .\modules\Registry.psm1
	- Replace .powershell directory with your own Powershell functions/libraries. If only setting up Powershell5.1, you may place your files under .powershell. Otherwise, preserve folder structure, to account for both Powershell5.1 and Powershell7.4+
	- VsCode Config has been automated. Inversely, chaining VsCode::new().BackupVsCode(), will pull your VsCode settings from the computer and save them to Script package. 
- Run Powershell as Admin. CD into Windows11 folder and run: './main.ps1'. Note: Powershell 5.1 required, the current default pre-installed version on all Windows machines.
- Restart computer.