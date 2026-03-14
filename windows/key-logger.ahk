#Requires AutoHotkey v2.0
#SingleInstance Force

LogFile := A_ScriptDir "\key-log.txt"

Log(msg) {
    global LogFile
    FileAppend FormatTime(, "HH:mm:ss") " " msg "`n", LogFile
}

; Log individual keys (no suppression - ~ means pass-through)
~RShift::Log("RShift DOWN | active exe: " WinGetProcessName("A"))
~RShift Up::Log("RShift UP")
~Left::Log("Left arrow | active exe: " WinGetProcessName("A"))
~Right::Log("Right arrow | active exe: " WinGetProcessName("A"))

; Log when Ctrl+Tab variants are received (to confirm what comet-tab-switch sends)
~^Tab::Log("Ctrl+Tab received | active exe: " WinGetProcessName("A"))
~^+Tab::Log("Ctrl+Shift+Tab received | active exe: " WinGetProcessName("A"))
