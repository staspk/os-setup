class VsCode {
    static [string] $VSCODE_APP_DATA      = "$env:APPDATA\Code\User"
    static [string] $VSCODE_USER_SETTINGS = "$([VsCode]::VSCODE_APP_DATA)\settings.json"
    static [string] $VSCODE_KEYBINDINGS   = "$([VsCode]::VSCODE_APP_DATA)\keybindings.json"

    [string] $installFilesDir
    [string] getExtensionsListFile() {  return "$($this.installFilesDir)\extensions-list"  }
    [string] getSettingsFile()       {  return "$($this.installFilesDir)\settings.json"    }
    [string] getKeybindingsFile()    {  return "$($this.installFilesDir)\keybindings.json" }

    VsCode() {
        $DEFAULT_INSTALL_FILES_DIRECTORY = "$PsScriptRoot\..\.vscode"

        if (-not(TestPathSilently $DEFAULT_INSTALL_FILES_DIRECTORY)) {  mkdir -Force $DEFAULT_INSTALL_FILES_DIRECTORY  }
        $this.installFilesDir = (Resolve-Path -Path $DEFAULT_INSTALL_FILES_DIRECTORY).Path
    }

    VsCode($installFilesDir) {
        if (-not(TestPathSilently $installFilesDir)) {  mkdir -Force $installFilesDir  }
        $this.installFilesDir = (Resolve-Path -Path $installFilesDir).Path
    }

    static [void] PrintPathsToVsCodeSettingFiles() {
        WriteCyan "VsCode: UserSettings: $([VsCode]::VSCODE_USER_SETTINGS)"
        WriteCyan "VsCode: Keybindings: $([VsCode]::VSCODE_KEYBINDINGS)"
    }

    [void] SetupVsCode() {
        $this.InstallExtensions()
        $this.InstallUserSettings()
    }
    [VsCode] InstallUserSettings() {
        $settings = $this.getSettingsFile()
        $keybindings = $this.getKeybindingsFile()

        if (TestPathSilently $settings) {
            Copy-Item -Path $settings -Destination "$([VsCode]::VSCODE_USER_SETTINGS)"
            WriteGreen "VsCode: Copied Into VsCode App Data Settings from: " $true; WriteDarkGreen $settings
        }
        if (TestPathSilently $keybindings) {
            Copy-Item -Path $keybindings -Destination "$([VsCode]::VSCODE_KEYBINDINGS)"
            WriteGreen "VsCode: Copied Into VsCode App Data Settings from: " $true; WriteDarkGreen $keybindings
        }
        return $this
    }
    [VsCode] InstallExtensions() {
        $extensionsFile = $this.getExtensionsListFile()
        $exists = TestPathSilently $extensionsFile
        if (-not($exists)) {
            WriteRed "extensions-list file not found. Skipping InstallExtensions()" 
            return $this
        }

        foreach($line in [System.IO.File]::ReadLines($extensionsFile)) {
            code --install-extension $line
        }
        return $this
    }

    [void] BackupVsCode() {     # Will overwrite files in .vscode
        $this.SaveExtensionListToScriptFiles()
        $this.SaveVsCodeSettingsToScriptFiles()
    }
    [VsCode] SaveExtensionListToScriptFiles() {     # Will overwrite extensions-list
        $extensionsFile = $this.getExtensionsListFile()

        code --list-extensions > $extensionsFile

        WriteGreen "VsCode: Saved a list of VsCode's current extenions to: " $true; WriteDarkGreen $extensionsFile
        return $this
    }
    [VsCode] SaveVsCodeSettingsToScriptFiles() {   # Will overwrite settings.json/keybindings.json
        $codeUserSettings = [VsCode]::VSCODE_USER_SETTINGS; $codeKeybindings = [VsCode]::VSCODE_KEYBINDINGS
        $toSettings = $this.getSettingsFile(); $toKeybindings = $this.getKeybindingsFile()

        if (TestPathSilently $codeUserSettings) {
            Copy-Item -Path $codeUserSettings -Destination $toSettings -Force
            WriteGreen "Saved " $true; WriteDarkGreen $codeUserSettings $true; WriteGreen " to: " $true; WriteDarkGreen $toSettings
        }
        if (TestPathSilently $codeKeybindings) {
            Copy-Item -Path $codeKeybindings -Destination $toKeybindings -Force
            WriteGreen "Saved " $true; WriteDarkGreen $codeKeybindings $true; WriteGreen " to: " $true; WriteDarkGreen $toKeybindings
        }
        return $this
    }
}