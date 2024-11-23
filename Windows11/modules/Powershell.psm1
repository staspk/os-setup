class ProfilePaths {
    static $CUR_USER_CUR_HOST = $Profile.CurrentUserCurrentHost     # In Console, but not ISE. Ideal for code completions 
    static $CUR_USER_ALL_HOSTS = $Profile.CurrentUserAllHosts       # Console, ISE, Ideal for global use
    static $ALL_USERS_CUR_HOST = $Profile.AllUsersCurrentHost 
    static $ALL_USERS_ALL_HOSTS = $Profile.AllUsersAllHosts   
    # static $TEST = [System.Environment]::GetFolderPath('Desktop') + "\FOLDER\folder2\Microsoft.PowerShell_profile.ps1"

    $PSHOME
}

function IterateStaticPropertiesOfClass($class) {
    foreach($prop in ( $class | Get-Member -MemberType Property -Static).Name ) {
        Write-Host "$prop == " -NoNewline
        $class::$prop
    }
}


function SetupMyPowershellProfile($directory) {
    $curUserDir = [System.IO.Path]::GetDirectoryName([ProfilePaths]::CUR_USER_ALL_HOSTS)

    mkdir -Force $curUserDir

    Copy-Item "$directory\*" -Destination $curUserDir
}



Export-ModuleMember -Function SetupMyPowershellProfile