#  "Microsoft.PowerShell_profile.ps1"   ==>   # For Console, but not ISE. Ideal for, like, code completions
#  "profile.ps1"                        ==>   # Console, ISE, Ideal for global use

class Profile5 {    # Profile 5.1                                 
    static $currentUserDir =    "$([Environment]::GetFolderPath("MyDocuments"))\WindowsPowerShell"      # default => C:\Users\{userName}\Documents\WindowsPowerShell, unless Documents folder moved by OneDrive
    static $allUsersDir    =    "$Env:ProgramFiles\WindowsPowershell"                                   # default => C:\Program Files\WindowsPowerShell
}
class Profile7 {    # Profile 7.4+                               
    static $currentUserDir =    "$([Environment]::GetFolderPath("MyDocuments"))\Powershell"             #  default => C:\Users\{userName}\Documents\PowerShell, unless Documents folder moved by OneDrive
    static $allUsersDir    =    "$Env:ProgramFiles\PowerShell\7"                                        #  default => C:\Program Files\PowerShell\7
}
class PowershellConfigurer {
    $PROFILE = $Global:PROFILE
    
    [Profile5] $profile5 = $null
    [Profile7] $profile7 = $null

    [string] $installFilesDir = $null

    PowershellConfigurer() {
        if (-not(TestPathSilently("$PsScriptRoot\..\.powershell"))) { mkdir -Force $PsScriptRoot\..\.powershell }

        $this.installFilesDir = (Resolve-Path -Path "$PsScriptRoot\..\.powershell").Path    # Changes Path from relative to absolute syntax. Will fail to resolve, if path doesn't exist

        if (-not(TestPathSilently "$($this.installFilesDir)\WindowsPowerShell")) {  mkdir -Force "$($this.installFilesDir)\WindowsPowerShell"  }
        if (-not(TestPathSilently "$($this.installFilesDir)\Powershell"))        {  mkdir -Force "$($this.installFilesDir)\Powershell"         }

        $modulesFolderOnTop = TestPathSilently "$($this.installFilesDir)\Modules" $true
        $curHostOnTop = TestPathSilently "$($this.installFilesDir)\Microsoft.PowerShell_profile.ps1" $true
        $allHostsOnTop = TestPathSilently "$($this.installFilesDir)\profile.ps1" $true

        if ($modulesFolderOnTop -or $curHostOnTop -or $allHostsOnTop) {
            WriteRed "PowershellConfigurer: Use correct folder structure before trying again:"
            [PowershellConfigurer]::PrintCorrectFolderStruture()
            exit
        }
    }

    static [void] PrintCorrectFolderStruture() {
        Write-Host
        WriteGreen "Example of Correct Folder Structure:"
        WriteDarkGreen ".powershell\"
        WriteDarkGreen  " ├── WindowsPowerShell\    " $true; WriteDarkRed "--> for 5.1"
        WriteDarkGreen  " ├───├── Modules\"
        WriteDarkGreen  " ├───├── Microsoft.PowerShell_profile.ps1"
        WriteDarkGreen  " ├───├── profile.ps1"
        
        WriteDarkGreen  " ├── Powershell\           " $true; WriteDarkRed "--> for 7+ (core)"
        WriteDarkGreen  " ├───├── Modules\"
        WriteDarkGreen  " ├───├── Microsoft.PowerShell_profile.ps1"
        WriteDarkGreen  " ├───├── profile.ps1"

        WriteDarkGreen  " ├── WindowsPowerShell_AllUsers\    " $true; WriteDarkRed "--> Create, if your AllUsers profile differs from CurrentUser"
        WriteDarkGreen  " ├───├── ***"
        WriteDarkGreen  " ├── Powershell_AllUsers\           " $true; WriteDarkRed "--> Otherwise, Install_forAllUsers() will use the folders/files above"
        WriteDarkGreen  " ├───├── ***"
        Write-Host
    }

    [void] SaveCurrentUserProfilesToScriptPackage() {
        $profile5Exists = TestPathSilently "$([Profile5]::currentUserDir)\*"
        $profile7Exists = TestPathSilently "$([profile7]::currentUserDir)\*"

        if ($profile5Exists) {
            Copy-Item -Path "$([Profile5]::currentUserDir)\*" -Destination "$($this.installFilesDir)\WindowsPowerShell" -Recurse -Force
            WriteGreen "PowershellConfigurer: Copied files from $([Profile5]::currentUserDir) to: .powershell\WindowsPowerShell"
        }
        if ($profile7Exists) {
            Copy-Item -Path "$([Profile7]::currentUserDir)\*" -Destination "$($this.installFilesDir)\Powershell" -Recurse -Force
            WriteGreen "PowershellConfigurer: Copied files from $([Profile7]::currentUserDir) to: .powershell\Powershell"
        }
    }

    [void] SaveProfileFilesToScriptPackage() {   # Only pulls CurrentUser profiles. Someday will implement AllUsers functionality, if I actually need it
        $this.SaveCurrentUserProfilesToScriptPackage()
      # $this.SaveAllUsersProfilesToScriptPackage
    }

    [PowershellConfigurer] Install_forCurrentUser() {   # Will overwrite files
        $folder5HasFiles = TestPathSilently "$($this.installFilesDir)\WindowsPowerShell\*"
        $folder7HasFiles = TestPathSilently "$($this.installFilesDir)\Powershell\*"

        if (-not($folder5HasFiles) -and -not($folder7HasFiles)) {  WriteRed "PowershellConfigurer:InstallCurrentUser() cannot complete. Directories with install files empty."; [PowershellConfigurer]::PrintCorrectFolderStruture(); exit  }
        
        if ($folder5HasFiles) {
            if(-not(TestPathSilently([Profile5]::currentUserDir))) {  mkdir -Force ([Profile5]::currentUserDir)  }
            Copy-Item -Path "$($this.installFilesDir)\WindowsPowerShell\*" -Destination "$([Profile5]::currentUserDir)\WindowsPowerShell" -Recurse -Force
            WriteGreen "PowershellConfigurer: Copied files from .powershell\WindowsPowershell to: $([Profile5]::currentUserDir)"
        }
        if ($folder7HasFiles) {
            if(-not(TestPathSilently([Profile7]::currentUserDir))) {  mkdir -Force ([Profile7]::currentUserDir)  }
            Copy-Item -Path "$($this.installFilesDir)\Powershell\*" -Destination "$([Profile7]::currentUserDir)\Powershell" -Recurse -Force
            WriteGreen "PowershellConfigurer: Copied files from .powershell\Powershell to: $([Profile7]::currentUserDir)"
        }
        return $this
    }

    [PowershellConfigurer] Install_forAllUsers() {   # Will use same files as CurrentUser profile.
        $folder5AllUsersHasFiles = TestPathSilently "$($this.installFilesDir)\WindowsPowerShell_AllUsers\*"
        $folder7AllUsersHasFiles = TestPathSilently "$($this.installFilesDir)\Powershell_AllUsers\*"

        if(-not(TestPathSilently([Profile5]::allUsersDir))) {  mkdir -Force ([Profile5]::allUsersDir)  }
        if ($folder5AllUsersHasFiles) {  Copy-Item -Path "$($this.installFilesDir)\WindowsPowerShell_AllUsers\*" -Destination "$([Profile5]::allUsersDir)" -Recurse -Force; WriteGreen "PowershellConfigurer: Copied files from .powershell\WindowsPowerShell_AllUsers to: $([Profile5]::allUsersDir)"  }
        else {                           Copy-Item -Path "$($this.installFilesDir)\WindowsPowerShell\*"          -Destination "$([Profile5]::allUsersDir)" -Recurse -Force; WriteGreen "PowershellConfigurer: Copied files from .powershell\WindowsPowerShell to: $([Profile5]::allUsersDir)"  }
        
        if ($this.IsPowershell7InstalledInStandardLocation()) {
            if ($folder7AllUsersHasFiles) {  Copy-Item -Path "$($this.installFilesDir)\Powershell_AllUsers\*" -Destination "$([Profile7]::allUsersDir)" -Recurse -Force; WriteGreen "PowershellConfigurer: Copied files from .powershell\PowerShell_AllUsers to: $([Profile7]::allUsersDir)"  }
            else {                           Copy-Item -Path "$($this.installFilesDir)\Powershell\*"          -Destination "$([Profile7]::allUsersDir)" -Recurse -Force; WriteGreen "PowershellConfigurer: Copied files from .powershell\Powershell to: $([Profile7]::allUsersDir)"  }
            return $this
        }

        WriteRed "PowershellConfigurer: Powershell 7+ Not Installed to Default Directory. Default Path to pwsh.exe: $([Profile7]::allUsersDir)\pwsh.exe"
        [string] $pathToExe = ""
        do {
            $pathToExe = Read-Host "Please enter location of your Powershell 7 exe (or 'exit'): "
            if ($pathToExe -eq "exit") {  exit  }
        } while (-not ($this.IsPowershell7ExePath($pathToExe)) )

        $containingDir = [System.IO.Path]::GetDirectoryName($pathToExe)
        if ($folder7AllUsersHasFiles) {  Copy-Item -Path "$($this.installFilesDir)\Powershell_AllUsers\*" -Destination "$containingDir" -Recurse -Force; WriteGreen "PowershellConfigurer: Copied files from .powershell\PowerShell_AllUsers to: $containingDir"  }
        else {                           Copy-Item -Path "$($this.installFilesDir)\Powershell\*"          -Destination "$containingDir" -Recurse -Force; WriteGreen "PowershellConfigurer: Copied files from .powershell\Powershell to: $containingDir"  }

        return $this
    }

    [bool] IsPowershell7InstalledInStandardLocation() {  return TestPathSilently("$([Profile7]::allUsersDir)\pwsh.exe")  }
    [bool] IsPowershell7ExePath($pathToExe) {
        $fileName = [System.IO.Path]::GetFileName($pathToExe)
        return (TestPathSilently $pathToExe -and ($fileName -ieq "pwsh.exe"))
    }
}

