#Requires AutoHotkey v2.0
#SingleInstance Force

#HotIf WinActive("ahk_exe comet.exe")
+Left::Send "^{PgUp}"
+Right::Send "^{PgDn}"
#HotIf
