$USER_HOME = "$env:USERPROFILE"

function MoveOneDriveFoldersToUserHome {    # Unfinished. Please finish $USER_HOME
    $dirList = "$USER_HOME\OneDrive" | Get-ChildItem -Directory
    foreach ($dir in $dirList) {
        Move-Item -Path "$USER_HOME\OneDrive\$dir" -Destination "$USER_HOME\$dir"
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
        $_.ProcessName | Out-File "C:\Users\stasp\Desktop\OS-Setup\Windows11\output.txt" -Append
        $_.MainWindowTitle -ne "" -and
        $_.processname -ne "powershell" -and    # For Some reason, this line only works on Admin-Run Powershell processes. Normal Powershell windows still close
        $_.processname -ne "Spotify"
    } | Stop-Process

    (New-Object -comObject Shell.Application).Windows() | foreach-object {$_.quit()}
}


function UninstallAndAttemptAnnihilationOfOneDrive {
    CloseAllOpenWindows
    MoveOneDriveFoldersToUserHome
    winget uninstall OneDrive
    RemoveReferencesToOneDriveInRegistry
}



Export-ModuleMember -Function UninstallAndAttemptAnnihilationOfOneDrive, RemoveReferencesToOneDriveInRegistry