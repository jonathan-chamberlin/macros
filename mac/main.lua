-- Allow CLI/AppleScript communication
hs.allowAppleScript(true)

-- Absolute path to the mac scripts directory; Hammerspoon's cwd is not reliable
-- so we anchor to the known repo location rather than using a relative path.
local SCRIPT_DIR = "/Users/jonathanchamberlin/repos/macros/mac/"
package.path = SCRIPT_DIR .. "?.lua;" .. package.path

local scripts = {
    "comet-tab-switch",
    -- "desktop-switch",  -- handled by Karabiner-Elements (see mac/karabiner-desktop-switch.json)
    "commit-push-macro",
    "explorer-hotkey",
    "git-pull-macro",
    "move-browser-tab",
    "new-terminal",
    "text-expansion",
    "website-hotkeys",
}

-- Clear module cache so reloads re-register eventtaps
for _, name in ipairs(scripts) do
    package.loaded[name] = nil
end
package.loaded["helpers"] = nil

-- Hold references to loaded modules so GC doesn't collect eventtaps
_G._macros = {}
for _, name in ipairs(scripts) do
    local ok, result = pcall(require, name)
    if ok then
        _G._macros[name] = result
        print("✓ Loaded " .. name)
    else
        print("✗ FAILED " .. name .. ": " .. tostring(result))
    end
end

-- Reload config when waking from sleep (eventtaps die after sleep/idle)
local caffeinateWatcher = hs.caffeinate.watcher.new(function(event)
    if event == hs.caffeinate.watcher.systemDidWake
    or event == hs.caffeinate.watcher.screensDidUnlock then
        print("System wake/unlock detected — reloading config")
        hs.reload()
    end
end)
caffeinateWatcher:start()

-- Auto-reload config when any .lua file in the mac folder changes.
-- The `files` arg lists changed paths but we always do a full reload, so it is ignored.
local fileWatcher = hs.pathwatcher.new(SCRIPT_DIR, function(_files)
    hs.reload()
end)
fileWatcher:start()

print("=== Hammerspoon config loaded ===")
