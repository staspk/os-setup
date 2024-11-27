function SafeCreateDirectory($dirPath) {
    if (-not (Test-Path $dirPath)) {
        mkdir $dirPath
	}
}


function DoesDirExist {

    return $false
}

Export-ModuleMember -Function SafeCreateDirectory, DoesDirExist