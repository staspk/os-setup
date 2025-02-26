using module .\classes\FunctionRegistry.psm1
class KozubenkoIO {   
    static [FunctionRegistry] GetFunctionRegistry() {
        return [FunctionRegistry]::new(
            "Kozubenko.IO",
            @(
                "DisplayFolderSizes()              -->  lists folders in current directory with their sizes (not on disk)",
                "ClearFolder(`$folder = '.\')       -->  recursively deletes contents of directory", 
                "LockFolder(`$folder)               -->  remove write access rules for 'Everyone'"
            ));
    }
}

function DisplayFolderSizes {
    $colItems = Get-ChildItem $startFolder | Where-Object {$_.PSIsContainer -eq $true} | Sort-Object
    foreach ($i in $colItems)
    {
        $subFolderItems = Get-ChildItem $i.FullName -recurse -force | Where-Object {$_.PSIsContainer -eq $false} | Measure-Object -property Length -sum | Select-Object Sum
        WriteGreen "$($i.Name)" $false; WriteGray " --> " $false; WriteDarkRed "$("{0:N2}" -f ($subFolderItems.sum / 1MB))MB"
    }
}

function ClearFolder($folder = ".\") {
    if (-not(IsDirectory $folder)) {  WriteDarkRed "Skipping ClearFolder, `$folder is not a directory: $folder";  RETURN;  }
    Get-ChildItem -Path $folder -Recurse | ForEach-Object {
        if ($_.PSIsContainer) {  $_.Delete($true)  }
        else {  $_.Delete()  }
    }
}

function LockFolder($folder) {
    if (-not(IsDirectory $folder)) {  WriteDarkRed "Skipping LockFolder, `$folder is not a directory: $folder";  RETURN;  }

    $acl = Get-Acl -Path $folder

    $denyWriteRule = New-Object System.Security.AccessControl.FileSystemAccessRule(
        "Everyone", 
        "Write", 
        "ContainerInherit, ObjectInherit", 
        "None", 
        "Deny"
    )

    $acl.AddAccessRule($denyWriteRule)
    Set-Acl -Path $folder -AclObject $acl
    Write-Host "Write permissions for '$UserOrGroup' have been locked on folder: $folder"
}