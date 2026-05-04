# Hammerspoon Lua Conventions

Applies to: `mac/*.lua` files driven by `mac/main.lua`.

## Magic key codes — always extract to constants

Bare key-code numbers in Hammerspoon scripts are USB HID layout codes. They look meaningless inline. Extract to named constants in the same file with a comment naming the HID page.

```lua
-- BAD
if keyCode == 33 then ... end          -- 33 is what?

-- GOOD
-- macOS key codes (USB HID page 0x07)
local KEY_LEFT_BRACKET = 33
if keyCode == KEY_LEFT_BRACKET then ... end
```

If the same constant is used in multiple files, lift it into `mac/helpers.lua`. So far each script uses its own subset, so per-file constants are fine. (Reference: commit e5a0f9c added KEY_LEFT_BRACKET, KEY_RIGHT_BRACKET, KEY_Z, KEY_X to comet-tab-switch.lua after they sat as bare numbers.)

## Left/right modifier disambiguation — always use helpers

`event:getFlags()` collapses left and right modifiers into one bool. To tell left-Option from right-Option (etc.), you must read the raw NSEvent device-dependent flag bits via `event:getRawEventData().CGEventData.flags`.

`mac/helpers.lua` is the single source of truth for those bit masks and the helper functions:

```lua
local helpers = require("helpers")
helpers.hasLeftAlt(event)     -- true if left Option is held
helpers.hasRightAlt(event)    -- true if right Option is held
helpers.hasRightCmd(event)
helpers.hasRightShift(event)
```

Never inline `event:getRawEventData().CGEventData.flags` in a feature script — call into helpers. If you need a new side check (e.g. `hasLeftCmd`), add it to `helpers.lua` next to its siblings rather than duplicating the raw-flag access.

## Eventtap lifetime — keep references alive

A Hammerspoon eventtap is garbage-collected as soon as nothing references it, and it stops firing without warning. Each feature module must:

```lua
local M = {}
M.watcher = hs.eventtap.new({hs.eventtap.event.types.keyDown}, function(event)
    -- ...
end)
M.watcher:start()
return M
```

`mac/main.lua` then loads the module via `require()` and stashes the result in `_G._macros[name]` so the module table — and the watcher inside it — survives GC. If your script defines a watcher as a local without returning it, it will work for a few seconds and then silently die.

## Hammerspoon vs Karabiner

If your remap involves the user holding a physical modifier while the synthesized event fires a system shortcut (Mission Control, Spaces, etc.), use Karabiner instead — see `karabiner-rules.md`. macOS merges held physical modifiers back into userspace-synthesized events at delivery, so eventtap can't strip them. Hammerspoon is correct for app-scoped chords (e.g. sending Cmd+Shift+`[` to the focused browser), AX queries (`hs.uielement.focusedElement():attributeValue("AXSelectedText")` in `tab-as-backspace.lua`), and any logic that needs Lua.

## Comments — why, not what

```lua
-- BAD
local KEYSTROKE_DELAY = 0  -- set delay to zero

-- GOOD
-- 0 µs delay: fire immediately; non-zero delays cause visible lag on tab switches
local KEYSTROKE_DELAY = 0
```

Comments earn their keep by explaining tradeoffs, non-obvious side effects, or why the obvious-looking alternative is wrong. Re-stating the code in English is noise.

## Reload behavior

`mac/main.lua` registers two reload triggers:

1. `hs.caffeinate.watcher` — reloads on `systemDidWake` and `screensDidUnlock` because eventtaps die after sleep.
2. `hs.pathwatcher` on `/Users/jonathanchamberlin/repos/macros/mac/` — reloads on any `.lua` save.

When you edit a script you should not need to manually reload. If a change isn't taking effect, check the Hammerspoon console for a load error from `pcall(require, name)`.
