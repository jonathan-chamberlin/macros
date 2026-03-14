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
    "smart-copy",
    "text-expansion",
    "website-hotkeys",
}

for _, name in ipairs(scripts) do
    local ok, err = pcall(require, name)
    if ok then
        print("✓ Loaded " .. name)
    else
        print("✗ FAILED " .. name .. ": " .. tostring(err))
    end
end

print("=== Hammerspoon config loaded ===")
