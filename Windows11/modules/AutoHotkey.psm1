$HOTKEYS = "$PWD\.keyboard\hotkeys.ahk"

function RunningAsAdmin {  
    $user = [Security.Principal.WindowsIdentity]::GetCurrent()
    (New-Object Security.Principal.WindowsPrincipal $user).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)  
}

function InstallCustomWindowsHotkeys() {
    if(-not(Test-Path $HOTKEYS)) {
        PrintDarkRed "Hotkeys.ahk not found under: .\Windows11\.keyboard. Quitting InstallCustomWindowsHotkeys..."
        RETURN;
    }

    if(-not(Test-Path "C:\Program Files\AutoHotkey")) {
        PrintRed "AutoHotkey not found. Installing..."
        curl -o "$HOME\Downloads\AutoHotkey-v2.exe" https://www.autohotkey.com/download/ahk-v2.exe

        if(-not(RunningAsAdmin)) {
            PrintRed "Script running w/o admin rights, expect an install elevation prompt..."
            Start-Sleep .75
        } 

        Start-Process -Wait -FilePath "$HOME\Downloads\AutoHotkey-v2.exe" -ArgumentList "/silent", "/Elevate" -PassThru
        
        if(-not(Test-Path "C:\Program Files\AutoHotkey")) {
            PrintRed "Unable to install AutoHotkeyV2. Please install manually. Will still place .ahk file in Startup folder..."
            RETURN;
        }
    }

    Copy-Item -Path $HOTKEYS -Destination "C:\Users\stasp\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup"

    PrintGreen "InstallCustomWindowsHotkeys Complete"
}
