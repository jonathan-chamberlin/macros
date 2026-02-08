#Requires AutoHotkey v2.0
#SingleInstance Force

#5::{
    existingWindows := WinGetList("ahk_class CabinetWClass")
    Run 'explorer.exe "C:\Users\Jonathan Chamberlin\.claude"'
    loop {
        Sleep 50
        currentWindows := WinGetList("ahk_class CabinetWClass")
        if currentWindows.Length > existingWindows.Length
            break
        if A_Index > 60
            return
    }
    newWin := 0
    for hwnd in currentWindows {
        found := false
        for oldHwnd in existingWindows {
            if hwnd = oldHwnd {
                found := true
                break
            }
        }
        if !found {
            newWin := hwnd
            break
        }
    }
    if !newWin
        return
    WinActivate(newWin)
    Sleep 100
    Send "^t"
    Sleep 250
    Send "!d"
    Sleep 100
    SendText "C:\Users\Jonathan Chamberlin\Downloads"
    Send "{Enter}"
    Sleep 250
    Send "^t"
    Sleep 250
    Send "!d"
    Sleep 100
    SendText "C:\Repositories for Git"
    Send "{Enter}"
}
