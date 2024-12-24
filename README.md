[![OS-Setup:Collection of scripts/files to setup/debloat/configure a clean OS Install.](./assets/Os_Setup.png)](https://github.com/staspk/OS-Setup)
## Windows 11 Instructions
### Uncomment desired functionality in: .\main.ps1.
- All possible behaviors/values of Enums, are defined right above/alongside Function Definitions that use the Enum in question. Use like so: `TaskBarAlignment ([Alignment]::Left)`
- Change List of bloat/software to uninstall/install at top of file: `.\modules\Winget.psm1`

### PowershellConfigurer
- `.powershell\` is where you should place your profile files and custom libraries, if doing manually.
	- `[PowershellConfigurer]::PrintCorrectFolderStruture()` --> Use this static method see how .powershell should be structured.
	- `[PowershellConfigurer]::new().SaveProfileFilesToScriptPackage()` --> Only pulls $profile.CurrentUser files for Powershell5 and Powershell7+ (Core). Will implement pulling AllUsers if I ever need the functionality.
	- `[PowershellConfigurer]::new().Install_forCurrentUser().Install_forCurrentUser()`

### VsCode
- VsCode Configuration has been automated.
	- `VsCode::new().InstallUserSettings().InstallExtensions()`, Short Version: `VsCode::new().SetupVsCode()`
	- `VsCode::new().BackupVsCode()`, save the VsCode settings on your computer to ScriptPackage. 

### Final Notes
- Run Powershell as Admin. CD into Windows11 folder and run: './main.ps1'. Note: Powershell 5.1+ required, the standard default pre-installed version on modern Windows machines.
- Highly Recommended to Close All Extraneous Programs, especially FileExplorer and Terminals open at any paths.
- Restart computer to finalize changes.