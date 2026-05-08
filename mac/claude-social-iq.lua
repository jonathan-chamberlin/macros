-- Ctrl+Option+S → opens a NEW Terminal window in ~/repos/social-iq and starts claude

hs.hotkey.bind({"ctrl", "alt"}, "s", function()
    hs.osascript.applescript([[
        tell application "Terminal"
            do script "cd ~/repos/social-iq && claude"
            activate
        end tell
    ]])
end)
