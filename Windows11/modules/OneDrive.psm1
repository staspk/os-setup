$USER_HOME = "$env:USERPROFILE"
$ONEDRIVE = "$env:OneDrive"

$TO_MOVE = "Desktop", "Documents", "Pictures"

function MoveDirectory($originalDir, $destDir) {
    Move-Item -Path $originalDir -Destination $destDir
    Write-Host "Moved Directory (originalDir = $originalDir, destDir = $destDir)."
}

function MoveOneDriveFoldersToUserHome {    # Unfinished. Please finish $USER_HOME
    foreach ($dir in $TO_MOVE) {
        MoveDirectory "$ONEDRIVE\$dir" "$USER_HOME\$dir"
    }
}

function RemoveReferencesToOneDriveInRegistry {
    $path = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders"

    Get-Item -Path $path |
    Select-Object -ExpandProperty Property |
    ForEach-Object {
        $value = (Get-ItemPropertyValue -Path $path -Name $_)
        $newValue = ""

        $pathArray = $value.split("\") -ne "OneDrive"
        foreach($dir in $pathArray) {
            $newValue += "$dir\"
        }
        $newValue = $newValue.Substring(0, $newValue.Length - 1)

        Set-ItemProperty -Path $path -Name $_ -Value $newValue
    }
    Write-Host "Removed Path References to OneDrive in: $path"
}

function CloseAllOpenWindows {
    Get-Process | Where-Object {
        $_.MainWindowTitle -ne "" -and
        $_.processname -ne "powershell" -and
        $_.processname -ne "Spotify"
    } | Stop-Process

    (New-Object -comObject Shell.Application).Windows() | foreach-object {$_.quit()}
}

# Must also clean registry:
# Computer\HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders

function UninstallAndAttemptAnnihilationOfOneDrive {
    CloseAllOpenWindows
    # winget uninstall OneDrive
    # MoveOneDriveFoldersToUserHome
    # RemoveReferencesToOneDriveInRegistry
}



Export-ModuleMember -Function UninstallAndAttemptAnnihilationOfOneDrive