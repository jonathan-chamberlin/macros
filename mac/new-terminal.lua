-- Cmd+Option+T → opens a NEW Terminal window (never reuses an existing one)

hs.hotkey.bind({"cmd", "alt"}, "t", function()
    hs.osascript.applescript([[
        tell application "Terminal"
            do script ""
            activate
        end tell
    ]])
end)
