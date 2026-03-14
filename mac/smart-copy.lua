-- Cmd+C override: if nothing is selected, copy the entire current line instead

hs.hotkey.bind({"cmd"}, "c", function()
    -- Save old clipboard
    local oldClip = hs.pasteboard.getContents()

    -- Clear clipboard and try normal copy
    hs.pasteboard.setContents("")
    hs.eventtap.keyStroke({"cmd"}, "c", 0)

    hs.timer.doAfter(0.2, function()
        local newClip = hs.pasteboard.getContents()
        if not newClip or newClip == "" then
            -- Nothing was selected — select current line and copy
            hs.eventtap.keyStroke({"cmd"}, "left", 0)        -- Home
            hs.eventtap.keyStroke({"cmd", "shift"}, "right", 0) -- Shift+End
            hs.timer.doAfter(0.05, function()
                hs.eventtap.keyStroke({"cmd"}, "c", 0)
                hs.timer.doAfter(0.05, function()
                    hs.eventtap.keyStroke({"cmd"}, "right", 0) -- Move to end
                end)
            end)
        end
    end)
end)
