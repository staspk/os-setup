# OS-Setup
## Collection of scripts & files to setup/debloat/customize an OS on a clean install.

### Windows 11:Home Instructions

- Uncomment desired functionality in: .\main.ps1.
	- Change List of bloat/software to uninstall/install in: .\modules\Winget.psm1
	- In Registry functions with enum params, call like so:
	  `FileExplorerDefaultOpenTo ([FileExplorerLaunchTo]::Downloads)`.  
	  For alternate values/behaviors, see: .\modules\Registry.psm1
- PowershellConfigurer. 
	- `[PowershellConfigurer]::new().SaveProfileFilesToScriptPackage()` => Save Pwsh-Profiles to ScriptPackage.
	- PowershellProfile Derived Classes have hard-coded $profile paths set to [Microsoft Standard Spec](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_profiles?view=powershell-5.1). However, in current versions of Win10/11 Home, OneDrive will default to setting the global automatic variable $profile [to what Microsoft Specifically Advises to Avoid](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_profiles?view=powershell-7.4): `C:\Users\{username}\OneDrive\Documents\...`, as opposed to the older, correct, classic path at: `C:\Users\{username}\Documents\...`.
	If you uncommented UninstallAndAttemptAnnihilationOfOneDrive in main.ps1, your $profile will already be set to the recommended specs, and you can ignore this section.
	If you hadn't, chain in SetCurUserDir(), like so: `[PowershellConfigurer]::new().SetCurUserDir().Install()` => Uses your global $profile instead of hard-coded values.
	
- VsCode
	- VsCode Configuration has been automated. Inversely, 'VsCode::new().BackupVsCode()', will pull your VsCode settings from the computer and save them to this ScriptPackage. 
- Run Powershell as Admin. CD into Windows11 folder and run: './main.ps1'. Note: Powershell 5.1+ required, the standard default pre-installed version on modern Windows machines.
- Restart computer.