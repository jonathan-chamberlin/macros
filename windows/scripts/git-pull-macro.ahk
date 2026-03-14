#Requires AutoHotkey v2.0
#SingleInstance Force

~l::{
    static pressCount := 0
    static firstPressTime := 0

    if (pressCount = 0 || A_TickCount - firstPressTime > 1000) {
        pressCount := 1
        firstPressTime := A_TickCount
        KeyWait "l"
        return
    }

    ; Reset if any non-l key was pressed between l-presses
    if (A_PriorKey != "l") {
        pressCount := 1
        firstPressTime := A_TickCount
        KeyWait "l"
        return
    }

    pressCount++

    if (pressCount >= 4 && A_TickCount - firstPressTime <= 1000) {
        pressCount := 0
        Send "{Backspace 4}"
        Sleep 50
        SendText "git pull origin main"
        Sleep 50
        Send "{Enter}"
    }
    KeyWait "l"
}
