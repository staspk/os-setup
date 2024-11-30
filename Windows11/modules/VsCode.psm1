$TO_INSTALL =
	"Microsoft.Powershell",
	"Microsoft.VisualStudioCode",
	"Notepad++.Notepad++",
	"Git.Git",
	"VideoLAN.VLC",
	"Python.Python.3.13",
	"Rustlang.Rustup"

function SetVsCodeUserSettingsFromFile($newSettings = $MY_USER_SETTINGS) {
    Write-Host "VsCode settings ($VSCODE_USER_SETTINGS) updated from file: ($newSettings)"
}

function SetVsCodeKeybindingsFromFile($newKeybindings = $MY_KEYBINDINGS) {
    Write-Host "VsCode keybindings ($VSCODE_KEYBINDINGS) updated from file: ($newKeybindings)"
}

function ConfigureMyVsCode {
    SetVsCodeUserSettingsFromFile
    SetVsCodeKeybindingsFromFile
}

class VsCode {
    static [string] $VSCODE_USER_SETTINGS_DIR = "$env:APPDATA\Code\User"
    static [string] $VSCODE_USER_SETTINGS = "$([VsCode]::VSCODE_USER_SETTINGS_DIR)\settings.json"
    static [string] $VSCODE_KEYBINDINGS = "$([VsCode]::VSCODE_USER_SETTINGS_DIR)\keybindings.json"

    [string] $installFilesDir

    VsCode($installFilesDir) {
        $this.installFilesDir = $installFilesDir
    }

    [VsCode] SetupVsCode() {
        $this.InstallExtensions()
        $this.InstallUserSettings()
        return $this
    }

    [VsCode] InstallUserSettings() {
        Write-Host("VsCode: Installing user settings from: $($this.installFilesDir)")
        Write-Host("$($this.installFilesDir)\settings.json")
        Write-Host("$($this.installFilesDir)\keybindings.json")
        WriteYellow([VsCode]::VSCODE_USER_SETTINGS)
        WriteYellow([VsCode]::VSCODE_KEYBINDINGS)
        Copy-Item -Path "$($this.installFilesDir)\settings.json" -Destination "$([VsCode]::VSCODE_USER_SETTINGS)"
        Copy-Item -Path "$($this.installFilesDir)\keybindings.json" -Destination "$([VsCode]::VSCODE_KEYBINDINGS)"
        return $this
    }

    [VsCode] InstallExtensions() {
        $exists = TestPathSilently("$($this.installFilesDir)\extensions-list")
        if ($exists -eq $null) {
            WriteRed("extensions-list file not found. Skipping InstallExtensions()")
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

        IfNotExistCreateFile($SAVE_TO)
    
        code --list-extensions > $SAVE_TO
        return $this
    }

    [VsCode] SaveLocalVsCodeSettingsToScriptFiles() {
        Write-Host($this.installFilesDir)
        mkdir -Force ($this.installFilesDir)
        Copy-Item -Path [VsCode]::VSCODE_USER_SETTINGS -Destination $this.installFilesDir
        Copy-Item -Path [VsCode]::VSCODE_KEYBINDINGS -Destination $this.installFilesDir
        return $this
    }

    static [void] PrintPathsToVsCodeSettingFiles() {
        Write-Host "UserSettings: $([VsCode]::VSCODE_USER_SETTINGS)"
        Write-Host "Keybindings: $([VsCode]::VSCODE_KEYBINDINGS)"
    }
}
