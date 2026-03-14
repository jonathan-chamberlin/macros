-- Press 'l' 4 times within 1 second → deletes the l's, types "git pull origin main", sends Enter

local pressCount = 0
local firstPressTime = 0
local lastKey = ""

local watcher = hs.eventtap.new({hs.eventtap.event.types.keyDown}, function(event)
    local char = event:getCharacters()
    local flags = event:getFlags()

    if flags.cmd or flags.alt or flags.ctrl then
        pressCount = 0
        return false
    end

    if char ~= "l" then
        if char and char ~= "" then lastKey = char end
        pressCount = 0
        return false
    end

    local now = hs.timer.absoluteTime() / 1e6

    if pressCount == 0 or (now - firstPressTime) > 1000 then
        pressCount = 1
        firstPressTime = now
        lastKey = "l"
        return false
    end

    if lastKey ~= "l" then
        pressCount = 1
        firstPressTime = now
        lastKey = "l"
        return false
    end

    pressCount = pressCount + 1
    lastKey = "l"

    if pressCount >= 4 and (now - firstPressTime) <= 1000 then
        pressCount = 0
        hs.timer.doAfter(0.05, function()
            for _ = 1, 4 do
                hs.eventtap.keyStroke({}, "delete", 0)
            end
            hs.timer.doAfter(0.05, function()
                hs.eventtap.keyStrokes("git pull origin main")
                hs.timer.doAfter(0.05, function()
                    hs.eventtap.keyStroke({}, "return", 0)
                end)
            end)
        end)
        return true
    end

    return false
end)
watcher:start()
