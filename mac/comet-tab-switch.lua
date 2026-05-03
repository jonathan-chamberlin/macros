-- Right Option + [ = previous tab (Cmd+Shift+[)
-- Right Option + ] = next tab (Cmd+Shift+])
-- Left Option  + Z = previous tab (Cmd+Shift+[)
-- Left Option  + X = next tab (Cmd+Shift+])

local helpers = require("helpers")

-- macOS key codes (USB HID page 0x07); these are hardware layout codes, not characters
local KEY_LEFT_BRACKET  = 33
local KEY_RIGHT_BRACKET = 30
local KEY_Z             = 6
local KEY_X             = 7

-- 0 µs delay: fire immediately; non-zero delays cause visible lag on tab switches
local KEYSTROKE_DELAY = 0

local M = {}
M.watcher = hs.eventtap.new({hs.eventtap.event.types.keyDown}, function(event)
    local keyCode = event:getKeyCode()
    local flags = event:getFlags()

    if flags.alt and not flags.cmd and not flags.shift and not flags.ctrl then
        if helpers.hasRightAlt(event) then
            if keyCode == KEY_LEFT_BRACKET then
                hs.eventtap.keyStroke({"cmd", "shift"}, "[", KEYSTROKE_DELAY)
                return true
            elseif keyCode == KEY_RIGHT_BRACKET then
                hs.eventtap.keyStroke({"cmd", "shift"}, "]", KEYSTROKE_DELAY)
                return true
            end
        elseif helpers.hasLeftAlt(event) then
            if keyCode == KEY_Z then
                hs.eventtap.keyStroke({"cmd", "shift"}, "[", KEYSTROKE_DELAY)
                return true
            elseif keyCode == KEY_X then
                hs.eventtap.keyStroke({"cmd", "shift"}, "]", KEYSTROKE_DELAY)
                return true
            end
        end
    end
    return false
end)
M.watcher:start()
return M
