# Macros — Keyboard Productivity Scripts

Cross-platform keyboard productivity. The active stack on Jonathan's daily-driver Mac is **Hammerspoon (Lua) + Karabiner-Elements (JSON)**. The `windows/` folder still holds the older AutoHotkey v2 scripts but is not the primary surface — most new work lives in `mac/`.

## Architecture (macOS — primary)

- `mac/main.lua` is the Hammerspoon entry point. It clears the Lua module cache, then `require()`s every script listed in its `scripts` table so each registers its own `hs.eventtap` watcher. Modules are stashed in `_G._macros` so GC doesn't collect the eventtaps.
- `mac/helpers.lua` exposes the side-aware modifier checks (`hasLeftAlt`, `hasRightAlt`, `hasRightCmd`, `hasRightShift`). `event:getFlags()` collapses both sides — call into helpers when left/right matters.
- `mac/karabiner-*.json` files are checked-in **templates**. The live rules are injected into `~/.config/karabiner/karabiner.json`; this repo is the source of truth for the rule shape.
- A `caffeinate.watcher` reloads on wake/unlock because eventtaps die after sleep. A `pathwatcher` reloads on any `.lua` change in `mac/`.

## Hammerspoon vs Karabiner — pick correctly

Use **Karabiner** (HID-layer rule) when the user must **hold a physical modifier** while the synthesized event fires a system shortcut (Mission Control, Spaces, etc.). macOS merges held physical modifiers back into userspace-synthesized events at delivery, so a Hammerspoon `keyStroke` with the user still holding Option produces Ctrl+Option+Left, not Ctrl+Left. See `mac/karabiner-desktop-switch.json` and the global CLAUDE.md Gotcha for the binding rationale.

Use **Hammerspoon** for app-scoped chords, AX queries (e.g. `tab-as-backspace.lua` checks `AXSelectedText`), watching system events, and anything that needs Lua logic. App-scoped means the synthesized event is not fighting a system shortcut bound to the held modifier (e.g. sending Cmd+Shift+`[` to the focused browser is fine).

## Karabiner JSON conventions

- **Rule order matters within a file**: more-specific manipulators must come **before** general ones. Karabiner walks rules top-to-bottom and stops at the first match. Example: `mac/karabiner-grave-backspace.json` puts `Ctrl+` → literal `` ` `` *above* the bare `` ` `` → Backspace rule. Inverting the order silently breaks the escape hatch.
- Use the canonical key_code names: `grave_accent_and_tilde`, `delete_or_backspace`, `return_or_enter`, `left_arrow` etc. Don't invent shortcuts — Karabiner silently no-ops on unknown keys.
- For "hold modifier the whole time" UX, model as `from.modifiers.mandatory: ["left_option"]` (or `left_control`) and `to: [{key_code: ..., modifiers: [...]}]`. `mandatory` consumes the modifier before delivery, which is what makes the system-shortcut path work.
- Each `karabiner-*.json` file is a single self-contained ruleset with `title` + `rules`. One feature per file.

## Hammerspoon Lua conventions

- Magic key codes are USB HID layout codes, not characters. Always extract to named `KEY_FOO` constants with a comment naming the HID page (see `mac/comet-tab-switch.lua`). Bare numbers like `30`, `33`, `48` are unreadable.
- For left/right-modifier disambiguation, use `helpers.hasLeftAlt(event)` etc. — never inline `event:getRawEventData().CGEventData.flags`. The helper is the single source of truth for the raw-flag bit masks.
- Hold a reference to every eventtap (`local M = {}; M.watcher = hs.eventtap.new(...)`; `return M`). `main.lua` keeps the table alive in `_G._macros`. An eventtap that goes out of scope stops firing without warning.
- Comments explain **why**, not **what**. "0 µs delay: non-zero delays cause visible lag" is good. "set keyCode to 6" is noise — let the constant name do that work.

## Testing

No test framework. Verify manually:

1. Save the `.lua` (pathwatcher auto-reloads) or run "Reload Config" from the Hammerspoon menu after editing `karabiner-*.json` and re-injecting into `~/.config/karabiner/karabiner.json`.
2. Press the hotkey. Watch the Hammerspoon console (`hs.console`) for `print` output and load errors.
3. For Karabiner, the Karabiner-EventViewer app shows whether `from` matched and what `to` fired. If a rule looks right but doesn't fire, check rule order first.

## Architecture (Windows — legacy)

`windows/main.ahk` launches independent AHK v2 scripts from `windows/scripts/`. v2 syntax: `#Requires AutoHotkey v2.0`, `:=` for assignment, `{}` blocks for multi-line hotkeys, `Send`/`SendInput`. Not the focus of new work; only touch when explicitly asked.

## What NOT to Read

All scripts are short (<100 lines). No need to read large files — there aren't any.
