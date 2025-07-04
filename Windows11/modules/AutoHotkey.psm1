using module .\Kozubenko.Utils.psm1

$STARTUP_DIR = "$HOME\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup"        # ahk scripts moved here, so they're always on
$AHK_SCRIPTS = @(
    $(ResolvePath "$($MyInvocation.MyCommand.Path)\..\..\.keyboard\hotkeys.ahk"),               # $MyInvocation.MyCommand.Path == abspath(AutoHotkey.psm1), when pwsh starting point is ./main.ps1
    $(ResolvePath "$($MyInvocation.MyCommand.Path)\..\..\.keyboard\hotstrings.ahk")
)

function InstallAutoHotkeyV2() {
    if(-not(Test-Path "C:\Program Files\AutoHotkey")) {
        PrintRed "AutoHotkey not found. Installing..."
        curl -o "$HOME\Downloads\AutoHotkey-v2.exe" https://www.autohotkey.com/download/ahk-v2.exe

        if(-not(RunningAsAdmin)) {
            PrintRed "Script running w/o admin rights, expect an install elevation prompt..."
            Start-Sleep 2
        } 

        Start-Process -Wait -FilePath "$HOME\Downloads\AutoHotkey-v2.exe" -ArgumentList "/silent", "/Elevate" -PassThru
        
        if(-not(Test-Path "C:\Program Files\AutoHotkey")) {
            PrintRed "Was unable to install AutoHotkeyV2. Aborting InstallAutoHotkeyV2()..."
            RETURN;
        }
    }

    foreach($file in $AHK_SCRIPTS) {
        $copied = 0;
        try {
            Copy-Item $file $backupDest -ErrorAction Stop
            $copied++;
        }
        catch {  PrintRed "_TryCopyFilesToDestination(): Failure! Reason: $($_.Exception.Message)";  }
    }

    PrintGreen "InstallAutoHotkeyV2 Complete. $copied/$($toBackup.Count) .ahk files copied into:" $false; PrintDarkGreen $STARTUP_DIR
}

function BackupAutoHotkey() {
    $backupDest = ParentDir $AHK_SCRIPTS[0]
    $toBackup = @(
        "$STARTUP_DIR\hotkeys.ahk"
        "$STARTUP_DIR\hotstrings.ahk"
    )

    $copied = 0;
    foreach($file in $toBackup) {
        try {
            Copy-Item $file $backupDest -ErrorAction Stop
            $copied++;
        }
        catch {  PrintRed "BackupAutoHotkey(): Failure! Reason: $($_.Exception.Message)";  }
    }

    $mainColor = "Green"; $offColor = "DarkGreen";
    if($copied -eq $toBackup.Count) {
        Write-Host "BackupAutoHotkey(" -ForegroundColor $mainColor -NoNewline
        Write-Host "$copied/$($toBackup.Count)" -ForegroundColor $offColor -NoNewline
        Write-Host "): Success! `$backupDest: " -ForegroundColor $mainColor -NoNewline;
        Write-Host $backupDest -ForegroundColor $offColor;
    }
}