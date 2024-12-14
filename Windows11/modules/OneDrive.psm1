$USER_HOME = "$env:USERPROFILE"

function MoveOneDriveFoldersToUserHome {
    if (TestPathSilently "$USER_HOME\OneDrive\" -AND -not(TestPathSilently "$USER_HOME\OneDrive\*" )) {  # OneDrive folder exists and is not empty
        try {
            Move-Item -Path "$USER_HOME\OneDrive\*" -Destination "$USER_HOME" -Recurse
        }
        catch {
            WriteRed "Attempted to move contents of OneDrive folder to $USER_HOME, but entered catch:"
            WriteRed "$_.Exception.Message"
        }
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
    WriteRed("Removed Path References to OneDrive in: $path")
}

function CloseAllOpenWindows {
    (New-Object -comObject Shell.Application).Windows() | foreach-object {$_.quit()}

    Get-Process | Where-Object {
        $_.MainWindowTitle -ne "" -and
        $_.processname -ne "powershell"    # For Some reason, this line only works on Admin-Run WindowsPowershell5.1 processes. Normal Powershell windows will close and script won't complete.
    } | Stop-Process
}

function UninstallAndAttemptAnnihilationOfOneDrive {
    WriteRed("OneDrive Uninstallation")
    MoveOneDriveFoldersToUserHome
    WriteRed("Before Continuing, MOVE (select-drag-drop) all items under OneDrive, up one level in the hierarchy to: '$env:userprofile'  [You could lose your desktop, if you skip this step...]" )
    do {
        $userInput = Read-Host "Type 'ok' to proceed, or 'exit'"
        if ($userInput -ieq "exit") { exit }
    } while ($userInput -ne "proceed" -and $userInput -ne "continue" -and $userInput -ne "ok")

    winget uninstall OneDrive
    RemoveReferencesToOneDriveInRegistry
}


Export-ModuleMember -Function UninstallAndAttemptAnnihilationOfOneDrive, RemoveReferencesToOneDriveInRegistry