# Left Off

**Last updated:** 2026-05-04

## Unfinished
- Verify `tab-as-backspace.lua` works in real apps (Notes, browser, terminal, code editors). Highlight text → press Tab → should delete the selection. Plain Tab with no selection should still indent/move focus normally.
- Verify the new grave mappings in a text field: plain ` should backspace; Shift+` should still type ~; Ctrl+` should type a literal `; Option+` should still open Next Actions in Comet.
- (new) Created Karabiner-Elements rule for grave-key backspace mapping in `mac/karabiner-grave-backspace.json`. Live config updated. Needs real-world testing in text editors, Notes, and terminals to confirm all variants work correctly.

## Next Up
- If any app's selection isn't detected via `AXSelectedText`, decide whether to fall back to a clipboard-roundtrip check or just leave that app as a known carve-out.
- (new) Commit the new Karabiner rule and tab-as-backspace Lua script once verification testing is complete.

## Blockers
- None
