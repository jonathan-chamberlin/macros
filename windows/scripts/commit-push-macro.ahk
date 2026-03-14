#Requires AutoHotkey v2.0
#SingleInstance Force

~p::{
    static pressCount := 0
    static firstPressTime := 0

    if (pressCount = 0 || A_TickCount - firstPressTime > 1000) {
        pressCount := 1
        firstPressTime := A_TickCount
        KeyWait "p"
        return
    }

    ; Reset if any non-p key was pressed between p-presses
    if (A_PriorKey != "p") {
        pressCount := 1
        firstPressTime := A_TickCount
        KeyWait "p"
        return
    }

    pressCount++

    if (pressCount >= 4 && A_TickCount - firstPressTime <= 1000) {
        pressCount := 0
        Send "{Backspace 4}"
        Sleep 50
        SendText "commit and push"
        Sleep 50
        Send "^{Enter}"
    }
    KeyWait "p"
}
