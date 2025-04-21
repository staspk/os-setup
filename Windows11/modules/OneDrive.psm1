$USER_HOME = "$env:USERPROFILE"
function MoveOneDriveDirectoryContentsToUserHome {
    if (TestPathSilently "$USER_HOME\OneDrive\" -AND -not(TestPathSilently "$USER_HOME\OneDrive\*" )) {  # OneDrive folder exists and is not empty
        $to_move = @('Desktop', 'Pictures')
        foreach ($folder in $to_move) {
            if (TestPathSilently "$USER_HOME\OneDrive\$folder") {
                PrintCyan "OneDrive: attempting to move $folder from OneDrive directory to: $USER_HOME"
                Move-Item -Path "$USER_HOME\OneDrive\$folder" -Destination "$USER_HOME"
            }
        }
        $path_to_documents = $([Environment]::GetFolderPath("MyDocuments"))
        foreach ($folder in $path_to_documents.Split("\")) {
            if ($folder -ieq "OneDrive") {
                PrintCyan "OneDrive: Environment confirmed MyDocuments primary residence under OneDrive. Attempting to move to: $USER_HOME"
                Move-Item -Path "$USER_HOME\OneDrive\Documents" -Destination "$USER_HOME"
            }
        }
    }
}

function RemoveReferencesToOneDriveInRegistry {
    $path = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders"   # HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders

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
    PrintGreen "Removed Path References to OneDrive in: $path"
}

function CloseAllOpenWindows {
    (New-Object -comObject Shell.Application).Windows() | foreach-object {$_.quit()}

    Get-Process | Where-Object {
        $_.MainWindowTitle -ne "" -and
        $_.processname -ne "powershell"    # For Some reason, this line only works on Admin-Run WindowsPowershell5.1 processes. Normal Powershell windows will close and script won't complete.
    } | Stop-Process
}


function UninstallAndAttemptAnnihilationOfOneDrive($deleteOneDriveAfter = $false) {
    PrintCyan "OneDrive: UninstallAndAttemptAnnihilationOfOneDrive..."
    Start-Sleep -Seconds 1
    PrintCyan "OneDrive: MoveOneDriveDirectoryContentsToUserHome..."
    MoveOneDriveDirectoryContentsToUserHome
    Start-Sleep -Seconds 1
    if(TestPathSilently("$USER_HOME\OneDrive")) {
        PrintCyan "OneDrive: Opening OneDrive directory for manual check..."
        Start-Sleep -Seconds 1
        explorer.exe "$USER_HOME\OneDrive"
    }
    PrintRed "Before Continuing, double-check that all important directories have been moved out from under OneDrive. Don't Copy-Paste! Move(select-drag-drop) folders up one level in the hierarchy to: '$env:userprofile'"
    PrintRed "[Warning: Skipping this step can risk you losing your important dirs (your Desktop, for example!)...]"
    do {
        $userInput = Read-Host "Type 'ok' to proceed, or 'exit'"
        if ($userInput -ieq "exit") { exit }
    } while ($userInput -ne "proceed" -and $userInput -ne "continue" -and $userInput -ne "ok")

    winget uninstall OneDrive
    RemoveReferencesToOneDriveInRegistry
    if (TestPathSilently "$USER_HOME\OneDrive" -and $deleteOneDriveAfter) {
        Remove-Item "$USER_HOME\OneDrive" -Recurse -Force
    }
}

Export-ModuleMember -Function UninstallAndAttemptAnnihilationOfOneDrive, RemoveReferencesToOneDriveInRegistry