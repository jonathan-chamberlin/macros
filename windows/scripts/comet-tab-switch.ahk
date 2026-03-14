#Requires AutoHotkey v2.0
#SingleInstance Force

>+Left::Send "^+{Tab}"   ; Right Shift + Left Arrow = previous tab
>+Right::Send "^{Tab}"   ; Right Shift + Right Arrow = next tab
