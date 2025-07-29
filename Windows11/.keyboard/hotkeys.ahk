#Requires AutoHotkey v2.0


F1:: Run("C:\Program Files\PowerShell\7\pwsh.exe")							   ; F1				=> Opens PowerShell
F2:: Run("C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe")  	   ; F2 			=> Opens Edge Browser
F3:: Run("C:\Users\stasp\AppData\Local\Programs\Microsoft VS Code\code.exe")   ; F3             => Opens VS Code
F4:: Run("calc.exe")  														   ; F4 			=> Opens Calculator

#Esc:: WinClose("A")                                    					   ; WinKey+Esc		=> Close Active Window
#HotIf WinExist("A")														   ; Esc			=> Close Active Window, except: VsCode, Vim-Terminal, Edge-Browser
	Esc:: { 
		if WinActive("ahk_exe WindowsTerminal.exe") and ProcessExist("vim.exe")
			Send("{Esc}")
		else if WinActive("ahk_exe Code.exe")
			Send("{Esc}")
		else if WinActive("ahk_exe msedge.exe")
			Send("{Esc}")
		else if WinActive("ahk_exe vlc.exe")
			Send("{Esc}")
		else
			WinClose("A")
	}
#HotIf


#HotIf WinActive("ahk_exe code.exe")                        ; When VsCode Open:
	!Esc::Send("^w")										;      Alt+Esc  =>  Close Current Tab       ["remapped", by sending signal to actual shortcut: Ctrl+w ]
#HotIf
#HotIf WinActive("ahk_exe msedge.exe")						; When MsEdge Open:
	!Esc::Send("^w")										;      Alt+Esc  =>  Close Current Tab       ["remapped", by sending signal to actual shortcut: Ctrl+w ]
	!s::Send("!d")											;      Alt+s    =>  Jump to Navigation Bar  ["remapped", by sending signal to actual shortcut: Alt+d  ]
	!t::Send("^t")											;      Alt+t    =>  New Tab                 ["remapped", by sending signal to actual shortcut: Ctrl+t ]
	!f::Send("^f")                                          ;      Alt+f    =>  Find                    ["remapped", by sending signal to actual shortcut: Ctrl+f ]
#HotIf



!Esc::Return												; DISABLES DEFAULT: Alt+Esc 	["Tab Through Windows"]
~LWin::Send "{Blind}{vkE8}"									; DISABLES DEFAULT: WindowsKey  ["Open Start Menu"], but not WinKey+Combos




^+i:: {  ; Ctrl+Shift+I
    hwnd := WinActive("A")
    title := WinGetTitle(hwnd)
    class := WinGetClass(hwnd)
    exe := WinGetProcessName(hwnd)

    MsgBox "Active Window Info:`n`n" 
        . "Title: " title "`n"
        . "Class: " class "`n"
        . "EXE: " exe
}

