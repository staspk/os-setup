#  "Microsoft.PowerShell_profile.ps1"   ==>   # For Console, but not ISE. Ideal for, like, code completions
#  "profile.ps1"                        ==>   # Console, ISE, Ideal for global use

class PowershellProfile {
    [string] $installFilesDir
    [string] $currentUserDir
    [string] $allUsersDir

    PowershellProfile($installFilesDir, $currentUserDir, $allUsersDir) {
        $this.installFilesDir = $installFilesDir
        $this.currentUserDir = $currentUserDir
        $this.allUsersDir = $allUsersDir
    }

    SetCurUserDir($currentUserDir) {
        $this.currentUserDir = $currentUserDir;
    }                  
    SetAllUsersDir($allUsersDir) {
        if (-not(TestPathSilently $allUsersDir)) {  mkdir -Force $allUsersDir  }
        $this.$allUsersDir = $allUsersDir
    }

    SetupCurrentUser() {
        if(-not(TestPathSilently($this.currentUserDir))) { mkdir -Force ($this.currentUserDir) }
        Write-Host "FROM: " $this.installFilesDir -ForegroundColor Cyan
        Write-Host "TO: " $this.currentUserDir -ForegroundColor Cyan
        Copy-Item -Path "$($this.installFilesDir)\*" -Destination "$($this.currentUserDir)" -Recurse
    }

    SetupAllUsers($allUsersDir)  {
        if(-not(TestPathSilently($allUsersDir))) { mkdir -Force ($this.allUsersDir) }
        Write-Host "FROM: " $this.installFilesDir -ForegroundColor Cyan
        Write-Host "TO: " $allUsersDir -ForegroundColor Cyan
        Copy-Item -Path "$($this.installFilesDir)\*" -Destination $allUsersDir -Recurse
    }
}

class Profile5 : PowershellProfile {    # Profile 5.1                                 
    static $currentUserDir = "$([Environment]::GetFolderPath("MyDocuments"))\WindowsPowerShell"     # default => C:\Users\{userName}\Documents\WindowsPowerShell
    static $allUsersDir = "$env:SystemRoot\System32\WindowsPowerShell\v1.0"                         # default => C:\Windows\System32\WindowsPowerShell\v1.0

    Profile5($installFilesDir) : base($installFilesDir, [Profile5]::currentUserDir, [Profile5]::allUsersDir) {   }
}

class Profile7 : PowershellProfile {    # Profile 7.4+                               
    static $currentUserDir     =  "$([Environment]::GetFolderPath("MyDocuments"))\Powershell"       #  default => C:\Users\{userName}\Documents\PowerShell 
    static $allUsersDir =  "$Env:ProgramFiles\PowerShell\7"                                         #  default => C:\Program Files\PowerShell\7

    Profile7($installFilesDir) : base($installFilesDir, [Profile7]::currentUserDir, [Profile7]::allUsersDir) {   }
}

class PowershellConfigurer {
    $PROFILE = $Global:PROFILE             # auto variable set with constructor param
    
    [Profile5] $profile5 = $null
    [Profile7] $profile7 = $null

    [string] $installFilesDir = $null

    PowershellConfigurer() {
        $DEFAULT = "$PsScriptRoot\..\.powershell"
        if (-not(TestPathSilently($DEFAULT))) {  mkdir -Force $DEFAULT  }
        $this.Init($DEFAULT)
    }
    PowershellConfigurer($pathToDirWithInstallFiles) {
        if (-not(TestPathSilently($pathToDirWithInstallFiles))) {  WriteErrorExit "PowershellConfigurer: Constructor Param not a valid path: $pathToDirWithInstallFiles" }
        $this.Init($pathToDirWithInstallFiles)
    }

    [PowershellConfigurer] Init($pathToDirWithInstallFiles) {
        $this.installFilesDir = (Resolve-Path -Path $pathToDirWithInstallFiles).Path

        if (-not(TestPathSilently "$($this.installFilesDir)\*")) {    # Provided directory is completely empty. Making sub-folders 5 and 7 ...
            mkdir -Force "$($this.installFilesDir)\5"
            mkdir -Force "$($this.installFilesDir)\7"
        }

        $curHostOnTop = TestPathSilently "$($this.installFilesDir)\Microsoft.PowerShell_profile.ps1" $true
        $allHostsOnTop = TestPathSilently "$($this.installFilesDir)\profile.ps1" $true
        $folder5Exists = TestPathSilently "$($this.installFilesDir)\5"
        $folder7Exists = TestPathSilently "$($this.installFilesDir)\7"

        if ($folder5Exists) {  $this.profile5 = [Profile5]::new("$($this.installFilesDir)\5")  }
        if ($folder7Exists) {  $this.profile7 = [Profile7]::new("$($this.installFilesDir)\7")  }

        if (-not($folder5Exists) -and -not($folder7Exists) -AND ($curHostOnTop -or $allHostsOnTop)) {  # sub-folders '5' & '7' don't exist, but valid $profile file exists
            WriteRed "PowershellConfigurer: Microsoft.PowerShell_profile.ps1 or profile.ps1 found, but Ambiguity Exists in folder structure. Choose Behavior: "
            WriteWhite "1" $true; WriteRed ": Use given files to setup only Powershell 5.1"
            WriteWhite "2" $true; WriteRed ": Use given files to setup only Powershell 7.4+"
            WriteWhite "3" $true; WriteRed ": Duplicate and use same files to setup both Powershell 5.1 / 7.4+"
            WriteWhite "exit" $true; WriteRed ": EXIT SCRIPT! " $true; WriteDarkGreen "Remove ambiguity in folder structure by organizing into sub-folders: '.powershell\5' and '.powershell\7"
            
            $userInput = $null
            do {
                $userInput = Read-Host "CHOICE"
            } while ($userInput -ne 1 -AND $userInput -ne 2 -AND $userInput -ne 3 -AND $userInput -ne 'exit')

            if ($userInput -eq "exit") { exit }
            elseif ($userInput -eq 1) {  $this.profile5 = [Profile5]::new($this.installFilesDir) }
            elseif ($userInput -eq 2) {  $this.profile7 = [Profile7]::new($this.installFilesDir) }
            elseif ($userInput -eq 3) {  $this.profile5 = [Profile5]::new($this.installFilesDir); $this.profile7 = [Profile7]::new($this.installFilesDir) }
        }
        return $this
    }


    static [bool] CheckIfPowershell7Exe($pathToExe) {
        Write-Host "CheckIfPowershell7Exe entered with pathtoexe: $pathtoexe" -ForegroundColor Yellow
        $fileName = [System.IO.Path]::GetFileName($pathToExe)
    
        if((Test-Path $pathToExe) -and ($fileName -ieq "pwsh.exe")) {
            Write-Host "Entered CheckIfPowershell7Exists() if clause" -ForegroundColor Green
            return $true
        }
        else {
            Write-Host "Entered CheckIfPowershell7Exists() else clause" -ForegroundColor Red
            return $false
        }
    }
    [bool] IsPowershell7InstalledInStandardLocation() {  return [PowershellConfigurer]::CheckIfPowershell7Exe("$([Profile7]::allUsersDir)\pwsh.exe")  }
    [bool] IsPowershell7ExePath($path) {  return [PowershellConfigurer]::CheckIfPowershell7Exe($path)  }

    [PowershellConfigurer] Install() {
        if ($this.profile5 -eq $null -and $this.profile7 -eq $null) {  WriteErrorExit("PowershellConfigurer: Fatal error In Install function. No install files found.")  }
        
        if ($this.profile5 -ne $null) {  $this.profile5.SetupCurrentUser()  }
        if ($this.profile7 -ne $null) {  $this.profile7.SetupCurrentUser()  }

        return $this
    }

    [PowershellConfigurer] Install_ForAllUsers() {
        WriteGreen "In PowershellConfigurer.Install_ForAllUsers()"
        if ($this.profile5 -eq $null -and $this.profile7 -eq $null) {  WriteErrorExit("PowershellConfigurer: Fatal error In Install_ForAllUsers function. No install files found.")  }

        if ($this.profile5 -ne $null) {
            $this.profile5.SetupAllUsers($([Profile5]::allUsersDir))
        }

        if ($this.profile7 -ne $null) {
            if ($this.IsPowershell7InstalledInStandardLocation()) {
                $this.profile7.SetupAllUsers([Profile7]::allUsersDir)
            }
            else {
                WriteRed("PowershellConfigurer: Powershell 7.4+ Not Installed to Default Directory. Default Path to pwsh.exe: $([Profile7]::allUsersDir)\pwsh.exe")
                [string] $pathToExe = ""
                do {
                    $pathToExe = Read-Host "Please enter location of your Powershell 7 exe (or 'exit'): "
                    if ($pathToExe -eq "exit") { exit }
                } while (-not ($this.IsPowershell7ExePath($pathToExe)) )
    
                $this.profile7.SetupAllUsers($([System.IO.Path]::GetDirectoryName($pathToExe)))
            }
        }
        return $this
    }

    # Chain in if your global auto-var $profile doesn't point to Microsoft's recommended dirs. If you uncommented UninstallAndAttemptAnnihilationOfOneDrive in ./main.ps1, this issue has already been resolved.
    # Open WindowsPowershell/Powershell7, depends which Version(s) you need, then Run: '$profile | select-object *'. Microsoft's recommended Values are Hard-Coded in static variables of Profile5 / Profile7 (Concrete implementations of PowershellProfile)
    #   5.1:   C:\Users\{userName}\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1
    #   7.4+:  C:\Users\{userName}\Documents\Powershell\Microsoft.PowerShell_profile.ps1s
    # During Windows11 (Re)Install, OneDrive defaults to setting $profile under: 'C:\Users\OneDrive\Documents\...', against Microsoft's own warnings: https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_profiles?view=powershell-5.1
    [PowershellConfigurer] SetCurUserDir() {   # example use: 
        $path = ($Global:profile).Split("\");
        $newPath = ""; for ($i = 0; $i -lt $path.Count - 2; $i++) {  $newPath += "$($path[$i])\"  }

        if ($this.profile5 -ne $null) {  $this.profile5.SetCurUserDir("$newPath\WindowsPowerShell")  }
        if ($this.profile7 -ne $null) {  $this.profile7.SetCurUserDir("$newPath\PowerShell")  }
        return $this
    }

    [PowershellConfigurer] SaveProfileFilesToScriptPackage() {
        $profileDir = 

        # Get-ChildItem -Path $toDir -Recurse | ForEach-Object {  
        #     $_.Delete()
        #     WriteRed "Deleted File: $_"
        # }
        # Copy-Item -Path "$profileDir\*" -Destination $toDir -Recurse
        # WriteGreen("PowershellConfigurer: Saved New Powershell 5.1 Profile files to: $toDir")

        return $this
    }
}

