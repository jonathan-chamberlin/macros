# Macros

AutoHotkey macros for Windows productivity. All scripts are launched via `main.ahk`, which runs automatically on Windows startup.

## Notion Hotkeys

Opens Notion pages in Comet browser. If a Comet instance is already open on the current desktop, the page opens as a new tab there. Otherwise, it launches Comet first then opens the page.

| Hotkey | Page |
|--------|------|
| `Win+1` | Next Actions |
| `Win+2` | Calendar |
| `Win+3` | In Tray |
| `Win+4` | Second Brain |

## File Explorer

Opens a File Explorer window with two tabs: Downloads and Repositories for Git.

| Hotkey | Action |
|--------|--------|
| `Win+5` | Downloads + Repos for Git |

## Commit and Push

Types `commit and push` and presses Enter when triggered.

| Trigger | Action |
|---------|--------|
| `p` x3 (within 1s) | Types `commit and push` + Enter |

## Git Pull

Types `git pull origin main` and presses Enter when triggered.

| Trigger | Action |
|---------|--------|
| `l` x3 (within 1s) | Types `git pull origin main` + Enter |

## Setup

1. Install [AutoHotkey v2](https://www.autohotkey.com/)
2. Double-click `main.ahk` to run (starts all scripts)

