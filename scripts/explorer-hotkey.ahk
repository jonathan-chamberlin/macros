#Requires AutoHotkey v2.0

#5::{
    existingWindows := WinGetList("ahk_class CabinetWClass")
    Run 'explorer.exe "C:\Users\Jonathan Chamberlin\Downloads"'
    loop {
        Sleep 200
        currentWindows := WinGetList("ahk_class CabinetWClass")
        if currentWindows.Length > existingWindows.Length
            break
        if A_Index > 15
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
    Sleep 300
    Send "^t"
    Sleep 800
    Send "!d"
    Sleep 500
    Send "^a"
    Sleep 100
    SendText "C:\Repositories for Git"
    Sleep 200
    Send "{Enter}"
}
