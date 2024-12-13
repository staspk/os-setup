# OS-Setup

## Description
- Collection of scripts and files to setup/debloat/customize an OS and necessary software on a clean install.

### Windows 11 Instructions

- Uncomment desired functionality in: .\main.ps1.
	- Change List of bloat/software to uninstall/install in: .\modules\Winget.psm1
	- In Registry functions with enum params, call like so:
	  `FileExplorerDefaultOpenTo ([FileExplorerLaunchTo]::Downloads)`.  
	  For alternate values/behaviors, see: .\modules\Registry.psm1
- PowershellConfigurer. 
	- Place Powershell Profile files under: '.powershell'. If only setting up one Version of Powershell or duplicating files across Versions, files under .powershell folder will suffice. Otherwise, preserve separate folder structure with '.powershell\5' and '.powershell\7'.
	- By default, PowershellConfigurer will follow $profile values that follow [Microsoft Recommendations](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_profiles?view=powershell-5.1). However, on modern Microsoft Windows 10/11 Home Versions, OneDrive will default to [going against Microsoft's own Guidelines](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_profiles?view=powershell-7.4), setting the global automatic variable $profile to: 'C:\Users\{username}\OneDrive\Documents\WindowsPowershell\...', as opposed to the classic 'C:\Users\{username}\Documents\...'. If you uncommented UninstallAndAttemptAnnihilationOfOneDrive in main.ps1, your $profile will already be set to the recommended specs, and you can ignore this section. Otherwise, chain in SetCurUserDir() to use your $profile paths instead, like so: '[PowershellConfigurer]::new().SetCurUserDir().Install()'
	- '[PowershellConfigurer]::new().SaveProfileFilesToScriptPackage()' => Export Powershell Profiles and save to ScriptPackage
- VsCode
	- VsCode Configuration has been automated. Inversely, 'VsCode::new().BackupVsCode()', will pull your VsCode settings from the computer and save them to this ScriptPackage. 
- Run Powershell as Admin. CD into Windows11 folder and run: './main.ps1'. Note: Powershell 5.1+ required, the standard default pre-installed version on modern Windows machines.
- Restart computer.