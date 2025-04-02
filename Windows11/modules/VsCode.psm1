class VsCode {
    static [string] $VSCODE_APP_DATA      = "$env:APPDATA\Code\User"
    static [string] $VSCODE_USER_SETTINGS = "$([VsCode]::VSCODE_APP_DATA)\settings.json"
    static [string] $VSCODE_KEYBINDINGS   = "$([VsCode]::VSCODE_APP_DATA)\keybindings.json"

    [string] $installFilesDir
    [string] Extensions_List_File() {  return "$($this.installFilesDir)\extensions-list"  }
    [string] Settings_Json()        {  return "$($this.installFilesDir)\settings.json"    }
    [string] Keybindings_Json()     {  return "$($this.installFilesDir)\keybindings.json" }

<#
    VsCode()                  =>  $installFilesDir == VsCode.psm1\..\.vscode
    VsCode($installFilesDir)  =>  $installFilesDir == $(whatever you pass in)
#>
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
        Write-Host "VsCode: UserSettings: $([VsCode]::VSCODE_USER_SETTINGS)" -ForegroundColor Cyan
        Write-Host "VsCode: Keybindings: $([VsCode]::VSCODE_KEYBINDINGS)" -ForegroundColor Cyan
    }

    [void] SetupVsCode() {
        $this.InstallExtensions()
        $this.InstallUserSettings()
    }
    [VsCode] InstallUserSettings() {
        $settings = $this.Settings_Json()
        $keybindings = $this.Keybindings_Json()

        if (TestPathSilently $settings) {
            Copy-Item -Path $settings -Destination "$([VsCode]::VSCODE_USER_SETTINGS)"
            Write-Host "VsCode: Copied Into VsCode App Data Settings from: " -ForegroundColor Green -NoNewline; Write-Host $settings -ForegroundColor DarkGreen
        }
        if (TestPathSilently $keybindings) {
            Copy-Item -Path $keybindings -Destination "$([VsCode]::VSCODE_KEYBINDINGS)"
            Write-Host "VsCode: Copied Into VsCode App Data Settings from: " -ForegroundColor Green -NoNewline; Write-Host $keybindings -ForegroundColor DarkGreen
        }
        return $this
    }
    [VsCode] InstallExtensions() {
        $extensionsFile = $this.Extensions_List_File()
        $exists = TestPathSilently $extensionsFile
        if (-not($exists)) {
            Write-Host "extensions-list file not found. Skipping InstallExtensions()" -ForegroundColor Red
            return $this
        }

        foreach($line in [System.IO.File]::ReadLines($extensionsFile)) {
            code --install-extension $line
        }
        return $this
    }

    [void] BackupVsCode() {                                                                 # Will overwrite files in Windows11\.vscode
        $this.SaveExtensionListToScriptFiles()
        $this.SaveVsCodeSettingsToScriptFiles()
    }
    [VsCode] SaveExtensionListToScriptFiles() {                                             # Will overwrite extensions-list
        $extensionsFile = $this.Extensions_List_File()

        code --list-extensions > $extensionsFile

        Write-Host "VsCode: Saved a list of VsCode's current extenions to: " -ForegroundColor Green -NoNewline; Write-Host $extensionsFile -ForegroundColor DarkGreen
        return $this
    }
    [VsCode] SaveVsCodeSettingsToScriptFiles() {                                            # Will overwrite settings.json/keybindings.json
        $codeUserSettings = [VsCode]::VSCODE_USER_SETTINGS; $codeKeybindings = [VsCode]::VSCODE_KEYBINDINGS
        $toSettings = $this.Settings_Json(); $toKeybindings = $this.Keybindings_Json()

        if (TestPathSilently $codeUserSettings) {
            Copy-Item -Path $codeUserSettings -Destination $toSettings -Force
            Write-Host "Saved " -ForegroundColor Green -NoNewline; Write-Host $codeUserSettings -ForegroundColor DarkGreen -NoNewline; Write-Host " to: " -ForegroundColor Green -NoNewline; Write-Host $toSettings -ForegroundColor DarkGreen
        }
        if (TestPathSilently $codeKeybindings) {
            Copy-Item -Path $codeKeybindings -Destination $toKeybindings -Force
            Write-Host "Saved " -ForegroundColor Green -NoNewline; Write-Host $codeKeybindings -ForegroundColor DarkGreen -NoNewline; Write-Host " to: " -ForegroundColor DarkGreen -NoNewline; Write-Host $toKeybindings -ForegroundColor DarkGreen
        }
        return $this
    }
}