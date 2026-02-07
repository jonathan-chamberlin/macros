#Requires AutoHotkey v2.0

; Notion Hotkeys for Comet Browser
; Win+1 = Next Actions
; Win+2 = Calendar
; Win+3 = In Tray
; Win+4 = Second Brain

CometPath := "C:\Users\Jonathan Chamberlin\AppData\Local\Perplexity\Comet\Application\comet.exe"

OpenInComet(url) {
    global CometPath
    if ProcessExist("comet.exe") {
        Run '"' CometPath '" "' url '"'
    } else {
        Run '"' CometPath '"'
        Sleep 3000
        Run '"' CometPath '" "' url '"'
    }
}

#1::OpenInComet("https://www.notion.so/jchamberlin/Next-Actions-14eafe0dcf0380318975d9ef2d2a6368?pvs=32")
#2::OpenInComet("https://calendar.notion.so/")
#3::OpenInComet("https://www.notion.so/jchamberlin/In-Tray-148afe0dcf0380579f65fa17c5be51da")
#4::OpenInComet("https://www.notion.so/jchamberlin/Second-Brain-3-6e70047fb94245eb87d3761cf3cd2855")

; File Explorer
; Win+5 = Downloads + Repos for Git (two tabs in one window)
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
