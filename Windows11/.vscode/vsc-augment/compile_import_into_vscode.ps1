<#
.SYNOPSIS
Compiles, builds and installs vsc-augment extension into VsCode.

.NOTES
- Requires: node npx vsce.
- Note: Yes, future Stan, this script works. Past Stan меня не подвёл, it seems...  
#>
if (-not (Get-Command npx -ErrorAction SilentlyContinue) -or -not (Get-Command vsce -ErrorAction SilentlyContinue)) {
    Write-Host "npx or vsce missing. cannot compile and build the .vsix" -ForegroundColor Red; exit 1
}


"y" | npx vsce package --allow-missing-repository *> $null

$packageJson = $(Get-Content -Path $("$PWD/package.json") -Raw) | ConvertFrom-Json

$name = $packageJson.name
$version = $($packageJson.version)

$vsc_augment_vsix = "$name-$version.vsix"
if (-not($vsc_augment_vsix)) {  Write-Host "vsc-augment vsix file not found. `$vsc_augment_vsix: $vsc_augment_vsix" -ForegroundColor Red; exit 1;  }

Copy-Item $vsc_augment_vsix ..\
$output = code --install-extension $vsc_augment_vsix

Write-Host $output -ForegroundColor Green