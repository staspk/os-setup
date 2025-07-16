## Ubuntu Instructions
### .bashrc
- `sudo apt update && sudo apt install -y git`
- `git clone https://github.com/staspk/os-setup.git $HOME/os-setup`
- `cp -r $HOME/os-setup/ubuntu/home/. ~`
- `(cat "$HOME/os-setup/ubuntu/.bashrc"; printf "\n\n\n"; cat ~/.bashrc) > "$HOME/.bashrc.new" && mv "$HOME/.bashrc.new" ~/.bashrc`
- Restart terminal. Finally: `setup_ubuntu`


## Windows 11 Instructions
### Uncomment desired functionality in: .\main.ps1.
- Note: pwsh function calls with parentheses work "correctly" with only 1 param. Do not try: `FuncCall("p1", "p2")`
- Uncomment desired functionality in Windows11\main.psm1.
- Change List of bloat/software to uninstall/install at top of file: `.\modules\Winget.psm1`
- Powershell Terminal: `.\Windows11\main.ps1`

### Powershell & OneDrive Warning!
- PowershellConfigurer (Powershell.psm1) module deprecated as of 2025:Q2.
- Beware: the OneDrive default installation will likely do exactly what the [Microsoft Documentation](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_profiles?view=powershell-7.5) explicitly advises against, messing with where the "automatic variable" $profile ends up pointing to in the process. My module accomodated both states in the past. Do not bother. Instead, do:
- In the future, uncomment `UninstallAndAttemptAnnihilationOfOneDrive`, run `./main.ps1`. Follow instructions. Works 90% of the time, every time.
- Clone your [github.com/staspk/PowerShell.git](https://github.com/staspk/PowerShell.git) repo directly into: "C:\Users\stasp\Documents"

### Final Notes
- Highly Recommended to close all running Programs, especially FileExplorer and Terminals open at any paths.
- Either call `RestartExplorer()`, or restart computer, to finalize changes.
- Powershell 5.1+ required, the standard default pre-installed version on modern Windows machines.