-- Allow CLI/AppleScript communication
hs.allowAppleScript(true)

-- Add the mac scripts directory to Lua's search path
local scriptDir = "/Users/jonathanchamberlin/repos/macros/mac/"
package.path = scriptDir .. "?.lua;" .. package.path

local scripts = {
    "comet-tab-switch",
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

-- Auto-reload config when any .lua file in the mac folder changes
local watcher = hs.pathwatcher.new(scriptDir, function(files)
    hs.reload()
end)
watcher:start()

print("=== Hammerspoon config loaded ===")
