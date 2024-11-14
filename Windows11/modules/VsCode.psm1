$VSCODE_USER_SETTINGS = "$env:APPDATA\Code\User\settings.json"
$VSCODE_KEYBINDINGS = "$env:APPDATA\Code\User\keybindings.json"

$MY_USER_SETTINGS = "..\vscode\vscode-settings.json"
$MY_KEYBINDINGS = "..\vscode\vscode-keybindings.json"

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

Export-ModuleMember -Function ConfigureMyVsCode
