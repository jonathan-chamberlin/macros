-- Right Option + [ = previous tab (Cmd+Shift+[)
-- Right Option + ] = next tab (Cmd+Shift+])

local helpers = require("helpers")

local watcher = hs.eventtap.new({hs.eventtap.event.types.keyDown}, function(event)
    local keyCode = event:getKeyCode()
    local flags = event:getFlags()

    if flags.alt and not flags.cmd and not flags.shift and not flags.ctrl then
        if helpers.hasRightAlt(event) then
            if keyCode == 33 then -- [
                hs.eventtap.keyStroke({"cmd", "shift"}, "[", 0)
                return true
            elseif keyCode == 30 then -- ]
                hs.eventtap.keyStroke({"cmd", "shift"}, "]", 0)
                return true
            end
        end
    end
    return false
end)
watcher:start()
