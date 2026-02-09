#Requires AutoHotkey v2.0
#SingleInstance Force

#HotIf WinActive("ahk_exe comet.exe")
RShift & Left::Send "^{PgUp}"
RShift & Right::Send "^{PgDn}"
#HotIf
