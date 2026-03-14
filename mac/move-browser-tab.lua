-- Right Cmd + [ = move tab left (Ctrl+Shift+PgUp)
-- Right Cmd + ] = move tab right (Ctrl+Shift+PgDn)
-- Note: moving tabs requires a browser extension on most Mac browsers

local helpers = require("helpers")

local watcher = hs.eventtap.new({hs.eventtap.event.types.keyDown}, function(event)
    local keyCode = event:getKeyCode()
    local flags = event:getFlags()

    if flags.cmd and not flags.alt and not flags.shift and not flags.ctrl then
        if helpers.hasRightCmd(event) then
            if keyCode == 33 then -- [
                hs.eventtap.keyStroke({"ctrl", "shift"}, "pageup", 0)
                return true
            elseif keyCode == 30 then -- ]
                hs.eventtap.keyStroke({"ctrl", "shift"}, "pagedown", 0)
                return true
            end
        end
    end
    return false
end)
watcher:start()
