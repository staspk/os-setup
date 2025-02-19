using module ".\Kozubenko.Utils.psm1"

function GitConfig ($email, $name) {
    git config --global user.email $email
    git config --global user.name $name
}

function Push ($commitMsg = "No Commit Message") {
    git add .
    git commit -a -m $commitMsg
    git push
}

function Github ($path = $PWD.Path) {
    $configFile = "$path\.git\config"
    if(TestPathSilently $configFile) {  $url = git config --file $configFile --get remote.origin.url; Start-Process $url;  Return;  }

    $possibleAltConfigLocation = "$path\..\.git\config"
    if(TestPathSilently $possibleAltConfigLocation) {  $url = git config --file $possibleAltConfigLocation --get remote.origin.url; Start-Process $url;  Return;  }

    $possibleAltConfigLocation2 = "$path\..\..\.git\config"
    if(TestPathSilently $possibleAltConfigLocation2) {  $url = git config --file $possibleAltConfigLocation2 --get remote.origin.url; Start-Process $url;  Return;  }

    WriteRed "No .git config file found under `$path: $path";
}

function GitHistory {
    git log --oneline
}