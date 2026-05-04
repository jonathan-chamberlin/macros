-- If text is highlighted, plain Tab acts as Backspace.
-- Shift+Tab, Cmd+Tab, Ctrl+Tab, Alt+Tab pass through unchanged so they
-- still trigger their normal system behavior (indent dedent, app switch, etc.).

local TAB_KEY = 48

-- Query the focused UI element for its current selection via AX.
-- Faster and less destructive than the clipboard-roundtrip trick used by
-- smart-copy.lua, but apps that don't expose AXSelectedText (e.g. some
-- Electron / canvas-based editors) will report no selection — in which
-- case we fall through and Tab behaves normally. That's the safe default.
local function hasSelectedText()
    local elem = hs.uielement.focusedElement()
    if not elem then return false end
    local ok, sel = pcall(function() return elem:attributeValue("AXSelectedText") end)
    return ok and type(sel) == "string" and sel ~= ""
end

local M = {}
M.watcher = hs.eventtap.new({hs.eventtap.event.types.keyDown}, function(event)
    if event:getKeyCode() ~= TAB_KEY then return false end

    local flags = event:getFlags()
    if flags.cmd or flags.alt or flags.ctrl or flags.shift then
        return false
    end

    if hasSelectedText() then
        hs.eventtap.keyStroke({}, "delete", 0)
        return true
    end
    return false
end)
M.watcher:start()
return M
