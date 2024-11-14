$USER_HOME = "$env:USERPROFILE"
$ONEDRIVE = "$env:OneDrive"

$TO_MOVE = "Desktop", "Documents"

function MoveDirectory($originalDir, $destDir) {
    Move-Item -Path $originalDir -Destination $destDir
    Write-Host "Moved Directory (originalDir = $originalDir, destDir = $destDir)."
}

function CloseAllOpenWindows {
    $openWindows = Get-Process | Where-Object {$_.MainWindowTitle -ne ""}
    foreach ($window in $openWindows) {
        if ($windows.MainWindowTitle -ne "Spotify") {
            $window.quit()
        }
    }
}

function UninstallAndDestroyOneDrive {
    CloseAllOpenWindows
    winget uninstall OneDrive
    foreach ($dir in $TO_MOVE) {
        MoveDirectory "$ONEDRIVE\$dir" "$USER_HOME\$dir"
    }
}

Export-ModuleMember -Function UninstallAndDestroyOneDrive