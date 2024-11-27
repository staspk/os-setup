function Write-Green($string) {
    Write-Host $string -ForegroundColor Green
}
function Write-Red($string) {
    Write-Host $string -ForegroundColor Red
}
function Write-DarkRed($string) {
    Write-Host $string -ForegroundColor DarkRed
}

function WriteObj($varName, $obj) {
    Write-Host
    Write-Host "--------------------------------------------------" -ForegroundColor DarkYellow
    Write-Host "`$$varName" -ForegroundColor Yellow;
    Write-Host "`$$varName.getType() == " -ForegroundColor DarkYellow -NoNewline; Write-Host $obj.GetType() -ForegroundColor Yellow -NoNewline; Write-Host " {" -ForegroundColor DarkYellow
    foreach ($_ in $obj | Select-Object) {
        Write-Host "  type:" -ForegroundColor DarkYellow -NoNewline;  Write-Host "$($_.GetType())"  -NoNewline -ForegroundColor Yellow
        Write-Host "  value: " -ForegroundColor DarkYellow -NoNewline;  Write-Host $_ -ForegroundColor Yellow;

    }
    Write-Host "}" -ForegroundColor DarkYellow
    Write-Host "--------------------------------------------------" -ForegroundColor DarkYellow
    Write-Host
}

function WriteObjBackup($varName, $obj) {
    Write-Host
    Write-Host "`$$varName" -ForegroundColor Yellow -NoNewline; Write-Host " {" -ForegroundColor DarkYellow
    foreach ($_ in $obj | Select-Object) {
        Write-Host "  type:" -ForegroundColor DarkYellow -NoNewline;  Write-Host "$($_.GetType())"  -NoNewline -ForegroundColor Yellow
        Write-Host "  value: " -ForegroundColor DarkYellow -NoNewline;  Write-Host $_ -ForegroundColor Yellow;

    }
    Write-Host "}" -ForegroundColor DarkYellow
    Write-Host
}



function SafeCreateDirectory($dirPath) {
    Write-Host "We were in SafeCreateDirectory"
    if (-not (Test-Path $dirPath)) {
        mkdir $dirPath
	}
}

function GetRegistryPropertyValue($path, $propertyName) {     # Returns either property value or $false if not exist  # UNFINISHED!!!
    $exists =  If ((Get-Item $path).property -match $propertyName) {"true"}
}

function WriteErrorExit([string]$errorMsg) {
    Write-Host $errorMsg -ForegroundColor DarkRed
    Write-Host "Exiting Script..." -ForegroundColor DarkRed
    exit
}

function NumberOfFoldersInDir($pathToDir, $_isRecursive) {
    Write-Red "In NumberOfFoldersInDi with isRecursive == $_isRecursive"
    [int] $count = 0

    $isRecursive = (Get-ChildItem -Path $pathToDir -Directory -Recurse).Count
    $nonRecursive = (Get-ChildItem -Path $pathToDir -Directory).Count
    

    WriteObj "isRecursive" $isRecursive
    Write-Host "isRecursive = $isRecursive"
    Write-Host
    WriteObj "nonRecursive" $nonRecursive
    Write-Host "nonRecursive = $nonRecursive"
    Write-Host
    Write-Host
    Write-Red "Leaving NumberOfFoldersInDir with isRecursive == $_isRecursive"

    if($_isRecursive) {
        return (Get-ChildItem -Path $pathToDir -Directory -Recurse).Count  }
    else {
        return (Get-ChildItem -Path $path -Directory).Count
    }

    
}

function DoFoldersInPathExist($pathToFolder, $excludeFolderWithName = $null) {     # Returns either false or # of subfolders. Test-Path before passing as param
    Write-Host "In DoFoldersInPathExist" -ForegroundColor Red
    Write-Host "pathToFolder == $pathToFolder, excludeFolderWithName = $excludeFolderWithName"
    if($excludeFolderWithName) {
        $numberOfFolders = Get-ChildItem $pathToFolder -Recurse -Directory
        
        WriteObj numberOfFolders $numberOfFolders
        WriteObj excludeFolderWithName $excludeFolderWithName
        
        If ($numberOfFolders -eq 0) { return $false } Else { return $numberOfFolders }
    }
    else {
        $numberOfFolders = Get-ChildItem $pathToFolder -Recurse -Directory | Measure-Object | select -Expand Count
        If ($numberOfFolders -eq 0) { return $false } Else { return $numberOfFolders }
    }
}

function FindFileRecursively([string]$pathToFolder, [string]$fileName) {
    return (Get-ChildItem -Path $pathToFolder -Filter $fileName -Recurse -ErrorAction SilentlyContinue -Force)
}

function ReadLineLoop([string]$message, [ScriptBlock]$condition) {
    do {
        $consoleInput = Read-Host "$message (or 'exit'): "
        if($consoleInput -eq "exit") { exit }
    } while ($condition.Invoke())
}


Export-ModuleMember -Function SafeCreateDirectory, GetRegistryPropertyValue, WriteErrorExit, DoFoldersInPathExist, FindFileRecursively, WriteObj, ReadLineLoop, NumberOfFoldersInDir, Write-Green, Write-Red, Write-DarkRed