class VsCode {
    static [string] $VSCODE_USER_SETTINGS_DIR = "$env:APPDATA\Code\User"
    static [string] $VSCODE_USER_SETTINGS = "$([VsCode]::VSCODE_USER_SETTINGS_DIR)\settings.json"
    static [string] $VSCODE_KEYBINDINGS = "$([VsCode]::VSCODE_USER_SETTINGS_DIR)\keybindings.json"

    [string] $installFilesDir

    VsCode() {
        $DEFAULT = "$PsScriptRoot\..\.vscode"
        $this.installFilesDir = (Resolve-Path -Path $DEFAULT).Path
    }

    VsCode($installFilesDir) {
        $this.installFilesDir = (Resolve-Path -Path $installFilesDir).Path
    }

    [VsCode] SetupVsCode() {
        $this.InstallExtensions()
        $this.InstallUserSettings()
        return $this
    }

    [VsCode] InstallUserSettings() {
        WriteCyan("VsCode: Installing user settings from: $($this.installFilesDir)")
        Copy-Item -Path "$($this.installFilesDir)\settings.json" -Destination "$([VsCode]::VSCODE_USER_SETTINGS)"
        Copy-Item -Path "$($this.installFilesDir)\keybindings.json" -Destination "$([VsCode]::VSCODE_KEYBINDINGS)"
        return $this
    }

    [VsCode] InstallExtensions() {
        $exists = TestPathSilently("$($this.installFilesDir)\extensions-list")
        if ($exists -eq $null) {
            WriteRed "extensions-list file not found. Skipping InstallExtensions()" 
            return $this
        }

        foreach($line in [System.IO.File]::ReadLines("$($this.installFilesDir)\extensions-list")) {
            code --install-extension $line
        }

        return $this
    }

    [VsCode] BackupVsCode() {
        $this.SaveExtensionListToScriptFiles()
        $this.SaveLocalVsCodeSettingsToScriptFiles()

        return $this
    }

    [VsCode] SaveExtensionListToScriptFiles() {
        $SAVE_TO = "$($this.installFilesDir)\extensions-list"

        WriteCyan("VsCode: Saving current extensions VsCode has on this machine to directory: $($this.installFilesDir)\extensions-list")

        IfNotExistCreateFile($SAVE_TO)
    
        code --list-extensions > $SAVE_TO
        return $this
    }

    [VsCode] SaveLocalVsCodeSettingsToScriptFiles() {
        WriteCyan("VsCode: Saving settings.json/keybindings.json from VsCode AppData to file: $($this.installFilesDir)")
        Write-Host($this.installFilesDir)
        mkdir -Force ($this.installFilesDir)
        Copy-Item -Path [VsCode]::VSCODE_USER_SETTINGS -Destination $this.installFilesDir
        Copy-Item -Path [VsCode]::VSCODE_KEYBINDINGS -Destination $this.installFilesDir
        return $this
    }

    static [void] PrintPathsToVsCodeSettingFiles() {
        WriteCyan "UserSettings: $([VsCode]::VSCODE_USER_SETTINGS)"
        WriteCyan "Keybindings: $([VsCode]::VSCODE_KEYBINDINGS)"
    }
}
