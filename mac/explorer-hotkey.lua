-- Option+5 → opens Finder windows for ~/.claude, ~/Downloads, ~/repos

hs.hotkey.bind({"alt"}, "5", function()
    hs.execute("open " .. os.getenv("HOME") .. "/.claude")
    hs.execute("open " .. os.getenv("HOME") .. "/Downloads")
    hs.execute("open " .. os.getenv("HOME") .. "/repos")
end)
