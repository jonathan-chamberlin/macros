-- Press 'p' 4 times within 1 second → deletes the p's, types "commit and push", sends Ctrl+Enter

local pressCount = 0
local firstPressTime = 0
local lastKey = ""

local M = {}
M.watcher = hs.eventtap.new({hs.eventtap.event.types.keyDown}, function(event)
    local char = event:getCharacters()
    local flags = event:getFlags()

    -- Ignore if any modifier is held
    if flags.cmd or flags.alt or flags.ctrl then
        pressCount = 0
        return false
    end

    if char ~= "p" then
        if char and char ~= "" then lastKey = char end
        pressCount = 0
        return false
    end

    local now = hs.timer.absoluteTime() / 1e6 -- ms

    if pressCount == 0 or (now - firstPressTime) > 1000 then
        pressCount = 1
        firstPressTime = now
        lastKey = "p"
        return false
    end

    if lastKey ~= "p" then
        pressCount = 1
        firstPressTime = now
        lastKey = "p"
        return false
    end

    pressCount = pressCount + 1
    lastKey = "p"

    if pressCount >= 4 and (now - firstPressTime) <= 1000 then
        pressCount = 0
        hs.timer.doAfter(0.05, function()
            for _ = 1, 4 do
                hs.eventtap.keyStroke({}, "delete", 0)
            end
            hs.timer.doAfter(0.05, function()
                hs.eventtap.keyStrokes("commit and push")
                hs.timer.doAfter(0.05, function()
                    hs.eventtap.keyStroke({"ctrl"}, "return", 0)
                end)
            end)
        end)
        return true -- suppress the 4th p
    end

    return false
end)
M.watcher:start()
return M
