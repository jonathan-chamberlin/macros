# Karabiner-Elements Rule Conventions

Applies to: `mac/karabiner-*.json` files in this repo.

## When Karabiner is the right tool

Pick Karabiner over Hammerspoon when:

1. **The user must hold a physical modifier while the synthesized event runs.** macOS merges held physical modifiers back into userspace-synthesized events at delivery. So `hs.eventtap.keyStroke({"ctrl"}, "left")` while the user holds Option becomes Ctrl+Option+Left at delivery — Mission Control's space-switch shortcut never matches. Karabiner intercepts at the HID layer below that merge, so `mandatory: ["left_option"]` consumes the Option flag and only Ctrl+Left reaches the system. (Reference: commit 254141c desktop-switch, commit fa9083d caps-to-enter, commit d4f8f56 ctrl+wasd arrows.)
2. **You need to swallow a key globally, including the OS-toggle path** (e.g. caps_lock → return without ever toggling caps state). Hammerspoon eventtaps fire after the OS already saw the key.
3. **The remap must work in apps that block accessibility/eventtaps** (some sandboxed apps, login window, secure fields).

Hammerspoon is correct for: app-scoped chords, AX queries, watching system events (sleep/wake/network), anything that needs Lua logic, anything where the synthesized event is not fighting a system shortcut bound to the held physical modifier.

## Rule ordering — most specific FIRST

Karabiner evaluates manipulators in array order and stops at the first match. **More-specific rules MUST come before more-general rules in the same file.** Inverting the order silently no-ops the specific rule — there is no warning.

Example from `mac/karabiner-grave-backspace.json`:

```jsonc
{
  "rules": [
    {
      // SPECIFIC: must come first
      "description": "Left Control + ` → literal ` (escape hatch)",
      "manipulators": [{
        "type": "basic",
        "from": {
          "key_code": "grave_accent_and_tilde",
          "modifiers": {"mandatory": ["left_control"]}
        },
        "to": [{"key_code": "grave_accent_and_tilde"}]
      }]
    },
    {
      // GENERAL: catches everything else
      "description": "` → Backspace (plain)",
      "manipulators": [{
        "type": "basic",
        "from": {"key_code": "grave_accent_and_tilde"},
        "to": [{"key_code": "delete_or_backspace"}]
      }]
    }
  ]
}
```

Whenever you add a new manipulator that is a more-specific case of an existing manipulator (extra modifier, extra `optional`/`mandatory` constraint, narrower `conditions`), insert it ABOVE the existing one and add a `// must come before <general rule> so it matches first` note in the description.

## Canonical key_code names

Karabiner silently no-ops on unknown key codes. Use the canonical names:

- `grave_accent_and_tilde` (NOT `backtick`, NOT `grave`)
- `delete_or_backspace` (NOT `backspace`, NOT `delete`)
- `return_or_enter` (NOT `enter`, NOT `return`)
- `left_arrow`, `right_arrow`, `up_arrow`, `down_arrow`
- `left_control`, `left_option`, `left_shift`, `left_command` (and right_* equivalents)
- `caps_lock`, `tab`, `escape`

When in doubt, run Karabiner-EventViewer and read the `key_code` field off a real key press — copy that string verbatim.

## File shape

One feature per file. Each file is:

```jsonc
{
  "title": "Human-readable feature name",
  "rules": [
    {
      "description": "What this manipulator does (and why if non-obvious)",
      "manipulators": [
        {
          "type": "basic",
          "from": {
            "key_code": "...",
            "modifiers": {"mandatory": [...]}
          },
          "to": [{"key_code": "...", "modifiers": [...]}]
        }
      ]
    }
  ]
}
```

These files in this repo are **templates**. The live rules are injected into `~/.config/karabiner/karabiner.json` under `profiles[].complex_modifications.rules`. After editing a template file, re-inject into the live config and reload Karabiner-Elements (it auto-reloads on save of its own JSON, but manual injection still needs verification).

## Verification

1. Open Karabiner-EventViewer.
2. Press the source chord — confirm the `from` side matches what you wrote.
3. Watch the synthesized event in the same EventViewer — confirm the `to` side fires.
4. If the rule "looks right" but doesn't fire: check rule order, then check key_code spelling, then check `mandatory` vs `optional` modifier handling.
