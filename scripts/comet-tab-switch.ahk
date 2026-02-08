#Requires AutoHotkey v2.0

#HotIf WinActive("ahk_exe comet.exe")
+Left::Send "^{PgUp}"
+Right::Send "^{PgDn}"
#HotIf
