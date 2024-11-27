#  "Microsoft.PowerShell_profile.ps1"   ==>   # For Console, but not ISE. Ideal for, like, code completions
#  "profile.ps1"                        ==>   # Console, ISE, Ideal for global use

using module ".\Kozubenko.Utils.psm1"
# Import-Module ".\Kozubenko.Utils.psm1" -Force

$CURRENT_HOST = "Microsoft.PowerShell_profile.ps1"
$ALL_HOSTS = "profile.ps1"



class PowershellProfile {
    [string] $curUserDirectory
    [string] $allUsersDirectory

    [string] $installFromFilesFolder
    SetInstallFromFilesFolder([string] $installFromFilesFolder) { $this.installFromFilesFolder = $installFromFilesFolder }  # Sanitize param before passing in here

    PowershellProfile($curUserDirectory, $allUsersDirectory) {
        $this.curUserDirectory = $curUserDirectory
        $this.allUsersDirectory = $allUsersDirectory
    }
}

class Profile5 : PowershellProfile {    # Profile 5.1                                 #  $curUserDirectory default: C:\Users\{userName}\Documents\WindowsPowerShell
    static $allUsersDirectory = "$env:SystemRoot\System32\WindowsPowerShell\v1.0"     #  C:\Windows\System32\WindowsPowerShell\v1.0

    Profile5([string]$curUserDirectory) : base($curUserDirectory, [Profile5]::allUsersDirectory) {
        
    }
}

class Profile7 : PowershellProfile {    # Profile 7.4                                 #  $curUserDirectory default:  C:\Users\{userName}\Documents\PowerShell  
    static $allUsersDirectory = "$Env:ProgramFiles\PowerShell\7"                      #  $allUsersDirectory default  C:\Program Files\PowerShell\7

    Profile7($curUserDirectory) : base($curUserDirectory, [Profile7]::allUsersDirectory) {
        
    }
}

class PowershellConfigurer {
    $PROFILE = $Global:PROFILE             # auto variable set with constructor param
    $CURRENT_USER_DIRECTORY = $env:USERPROFILE
    
    [bool[]] $whichInstallFilesExist = @($false, $false, $false, $false)  #CurrentUserCurrentHost_5, CurrentUserAllHosts_5, CurrentUserCurrentHost_7, CurrentUserAllHosts_7

    [Profile5] $profile5 = $null
    [Profile7] $profile7 = $null

    PowershellConfigurer($pathToInstallationFilesFolder) {  
        if (-not (Test-Path $pathToInstallationFilesFolder)) {
            WriteErrorExit("Install Files Directory missing. Please Provide a '.powershell' folder in the directory running main.ps1 before retrying.")  }
        if (-not (Test-Path $pathToInstallationFilesFolder\*)) {
            WriteErrorExit("Empty folder provided to PowershellConfigurer (pathToInstallationFilesFolder = '$pathToInstallationFilesFolder').")  }



        
        $returnValue = NumberOfFoldersInDir $pathToInstallationFilesFolder $true #-eq 7
        Write-Host
        WriteObj "returnValue" $returnValue
        Write-Host "returnValue = $returnValue"
        Write-Host
        Write-DarkRed "--------------------------------------------------------------------------------------------------"
        Write-DarkRed "--------------------------------------------------------------------------------------------------"
        Write-DarkRed "--------------------------------------------------------------------------------------------------"
        $returnValue = NumberOfFoldersInDir $pathToInstallationFilesFolder $false #-eq 7
        Write-Host
        WriteObj "returnValue" $returnValue
        Write-Host "returnValue = $returnValue"
        Write-Host

        # Write-Host "condition = $condition"

        # WriteObj condition $condition

        # -and (Test-Path "$pathToInstallationFilesFolder\modules")
        # if() {    # If a modules folder sits on top, we ignore going deeper, we will ask if user wants to apply this to v5.1 or v7.4
        #     Write-Green "We Reached"
            
        # }
        # Write-Host "Back in PowershellConfigurer" -ForegroundColor Red

        # WriteObj "whichInstallFilesExist" $this.whichInstallFilesExist

        # Write-Host "doThey = $doThey"   
        # ForeachObjectPrint($this.whichInstallFilesExist)
        # Write-Host ($doThey | Select-Object *)

        
        # if(-not (Test-Path $pathToInstallationFilesFolder\5) -and (-not (Test-Path $pathToInstallationFilesFolder\7) )) {

        # }
        
        # if(Test-Path "$pathToInstallationFilesFolder\*") {
        #     Write-Host "Files found in Powershell5 Folder" -ForegroundColor Cyan
        #     $this.profile5 = [Profile5]::new("$v5InstallFolder\WindowsPowerShell")
        #     Write-Host "`$this.profile5 == $($this.profile5.curUserDirectory)"
        # }

        # if(Test-Path "$v7FromInstallFolder\*") {
        #     Write-Host "Files found in Powershell7 Folder"
        #     if($this.IsPowershell7InstalledInStandardLocation()) {
        #         $this.profile7 = [Profile7]::new("$curUserProfile\Powershell")
        #     }
        #     else {
        #         Write-Host "Presence of files in '$v7FromInstallFolder' implies Powershell7 Configuration; `n   but Powershell7 exe not found in standard location: {standard_path: 'C:\Program Files\PowerShell\7\pwsh.exe'}"  -ForegroundColor Red
        #         [string] $pathToExe = ""
                # do {
                #     $pathToExe = Read-Host "Please enter location of your Powershell 7 exe (or 'exit'): "
                #     if($pathToExe -eq "exit") { exit }
                # } while (-not ($this.IsPowershell7ExePath($pathToExe)) )

        #         $this.profile7.allUsersDirectory = $pathToExe
        #     }
        # }
    }

    static [bool] CheckIfPowershell7Exe($pathToExe) {
        Write-Host "CheckIfPowershell7Exe entered" -ForegroundColor Yellow
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
    [bool] IsPowershell7InstalledInStandardLocation() {  return [PowershellConfigurer]::CheckIfPowershell7Exe("C:\Program Files\PowerShell\7\pwsh.exe")  }
    [bool] IsPowershell7ExePath($path) {  return [PowershellConfigurer]::CheckIfPowershell7Exe($path)  }

    # [PowershellConfigurer] SetInstallFromFilesFolder($_psVersion, $path) { try { [ValidateSet(5, 5.1, "5", "5.1", 7, 7.4, "7", "7.4")]$version = $_psVersion }
    #     catch {
    #         WriteErrorExit "SetInstallFromFilesFolder IllegalArgumentException psVersion == $_psVersion. LegalArguments{5, 5.1, '5', '5.1', 7, 7.4, '7', '7.4'}"
    #     }

    #     if (-not (Test-Path $path)) {  WriteErrorExit "path passed into SetInstallFromFilesFolder is not a valid path. path == '$path'"  } 

    #     $ver5_possibleValues = 5, 5.1, "5", "5.1"
    #     if (_psVersion -eq $ver5_possibleValues) {
    #         $this.profile5.SetInstallFromFilesFolder($path)  }
    #     else {
    #         $this.profile7.SetInstallFromFilesFolder($path)  }

    #     return $this
    # }

    # [PowershellProfile].curUserDirectory -> set with [automatic_variable]$profile { default == 'C:\Users\{userName}\Documents\{PowershellVersion}'}. If you want a custom location, chain this method in, like so: ([PowershellConfigurer]::new($profile)).ChangeUserDirectory("C:\Users\{userName}\Documents")
    [PowershellConfigurer] ChangeUserDirectory($newPath) {
        Write-Host "In ChangeUserDirectory. newPath == $newPath"
        $before5 = $this.profile5.curUserDirectory
        $before7 = $this.profile7.curUserDirectory
        $after5 = $null
        $after7 = $null

        if($this.profile5) {
            $after5 = "$newPath\WindowsPowershell"
            $this.profile5.curUserDirectory = $after5

            Write-Host "`$this.profile5.curUserDirectory: BEFORE:  $before5"
            Write-Host "`$this.profile5.curUserDirectory: AFTER:   $after5"
        }

        if($this.profile7) {
            $after7 = "$newPath\Powershell"
            $this.profile7.curUserDirectory = $after7

            Write-Host "`$this.profile7.curUserDirectory: BEFORE:  $before7"
            Write-Host "`$this.profile7.curUserDirectory: AFTER:   $after7"
        }
        
        return $this
    }

    Install() {     # Installs, by default to: 
        Write-Host "Install_ForUser Reached"

        if ($this.profile5) {
            $this.profile5.setupProfileForCurUserDir()
        }
        if ($this.profile7) {
            $this.profile7.setupProfileForCurUserDir()
        }
    }

    Install_ForAllUsers() {     
        Write-Host "Install_ForAllUsers Reached"

        $this.Install()
        
        if($this.profile5) {
            $this.profile5.set
        }
        
    }

    Install_ForAllUsers_IgnoreCurrentUser() {
        Write-Host "Install_ForAllUsers Install_ForAllUsers_IgnoreCurrentUser"
    }
}