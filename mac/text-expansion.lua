-- Text expansion:
--   "jc" + space/enter → "Jonathan Chamberlin"
--   "eee" → "jcham17x@gmail.com" (immediate)
--   ";;date" → current date MM/dd/yy (immediate)

local buffer = ""

local expansions = {
    { trigger = "eee",    replacement = "jcham17x@gmail.com", immediate = true },
    { trigger = ";;date", replacement = function() return os.date("%m/%d/%y") end, immediate = true },
}

local endingExpansions = {
    { trigger = "jc", replacement = "Jonathan Chamberlin" },
}

local function deleteAndType(triggerLen, replacement)
    for _ = 1, triggerLen do
        hs.eventtap.keyStroke({}, "delete", 0)
    end
    local text = type(replacement) == "function" and replacement() or replacement
    hs.eventtap.keyStrokes(text)
end

local M = {}
M.watcher = hs.eventtap.new({hs.eventtap.event.types.keyDown}, function(event)
    local char = event:getCharacters()
    local flags = event:getFlags()

    if flags.cmd or flags.alt or flags.ctrl then
        buffer = ""
        return false
    end

    local keyCode = event:getKeyCode()

    -- Check for ending characters (space, return, tab)
    if keyCode == 49 or keyCode == 36 or keyCode == 48 then -- space, return, tab
        for _, exp in ipairs(endingExpansions) do
            if buffer == exp.trigger then
                -- Delete trigger + suppress the ending char, then type replacement + ending char
                hs.timer.doAfter(0, function()
                    deleteAndType(#exp.trigger, exp.replacement)
                end)
                buffer = ""
                return false
            end
        end
        buffer = ""
        return false
    end

    if not char or char == "" then
        return false
    end

    buffer = buffer .. char

    -- Check immediate expansions
    for _, exp in ipairs(expansions) do
        if buffer:sub(-#exp.trigger) == exp.trigger then
            hs.timer.doAfter(0.05, function()
                deleteAndType(#exp.trigger, exp.replacement)
            end)
            buffer = ""
            return true -- suppress the last char
        end
    end

    -- Keep buffer manageable
    if #buffer > 20 then
        buffer = buffer:sub(-20)
    end

    return false
end)
M.watcher:start()
return M
