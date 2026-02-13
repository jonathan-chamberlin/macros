# Macros — AutoHotkey v2 Keyboard Productivity Scripts

## Architecture
`main.ahk` is the entry point — it launches 7 independent scripts from `scripts/`. Each script handles one feature (hotkeys, text expansion, git macros, etc.) and runs as its own process.

## AHK v2 Patterns (NOT v1)
- `#Requires AutoHotkey v2.0` at the top of every file
- `#SingleInstance Force` to prevent duplicate instances
- `:=` for variable assignment (not `=`)
- `{}` blocks for multi-line hotkeys
- `.method()` syntax for object calls
- `Send` / `SendInput` for keystrokes
- `WinActivate`, `WinExist`, `GroupAdd` for window management
- Hotstrings: `::trigger::replacement` for text expansion

## Testing
No test framework — AHK scripts are tested manually:
1. Run the `.ahk` file
2. Press the hotkey or type the trigger
3. Verify the action occurs

## What NOT to Read
No large files in this repo. All scripts are short (<100 lines).
