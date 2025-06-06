#Requires AutoHotkey v2.0

#1::Run("C:\Program Files\PowerShell\7\pwsh.exe")    							; WinKey+1		=> Opens PowerShell
#2::Run("C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe")			; WinKey+2		=> Opens Edge Browser
#Esc::WinClose("A")                                    							; WinKey+Esc	=> Close Currently Open Program


!Esc::Return												; Disabling Windows' "Tab through windows" default shortcut: Alt+Esc
#HotIf WinActive("ahk_exe msedge.exe")						; If Edge Browser active
!Esc::Send("^w")											; 	"Remapping" 'Close Current Tab', on Alt+Esc, send signal to actual shortcut (Ctrl+w) 
#HotIf

#HotIf WinActive("ahk_exe msedge.exe")						; If Edge Browser active
!s::Send("!d")												; 	"Remapping" 'Jump to Navigation Bar', on Alt+s, send signal to actual shortcut (Alt+d) 
#HotIf