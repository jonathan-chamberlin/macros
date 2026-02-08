#Requires AutoHotkey v2.0
#SingleInstance Force

$^c::{
    ClipSaved := ClipboardAll()
    A_Clipboard := ""
    Send "^c"
    if !ClipWait(0.2) {
        ; Nothing was selected — copy current line
        Send "{Home}+{End}"
        Sleep 50
        Send "^c"
        ClipWait(0.5)
        Send "{End}"
    }
}
