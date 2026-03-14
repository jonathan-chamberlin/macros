#Requires AutoHotkey v2.0
#SingleInstance Force

CometPath := "C:\Users\Jonathan Chamberlin\AppData\Local\Perplexity\Comet\Application\comet.exe"

OpenInComet(url) {
    global CometPath
    if ProcessExist("comet.exe") {
        Run '"' CometPath '" "' url '"'
        WinWait("ahk_exe comet.exe",, 3)
        WinActivate("ahk_exe comet.exe")
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
#6::OpenInComet("https://github.com/jonathan-chamberlin?tab=repositories")
