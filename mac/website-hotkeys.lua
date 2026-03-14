-- Option+1/2/3/4/6 → open URLs in Comet browser

local function openInComet(url)
    local appRunning = hs.application.find("Comet")
    if appRunning then
        hs.execute('open -a "Comet" "' .. url .. '"')
    else
        hs.application.open("Comet")
        hs.timer.doAfter(3, function()
            hs.execute('open -a "Comet" "' .. url .. '"')
        end)
    end
end

local hotkeys = {
    { key = "1", url = "https://www.notion.so/jchamberlin/Next-Actions-14eafe0dcf0380318975d9ef2d2a6368?pvs=32" },
    { key = "2", url = "https://calendar.notion.so/" },
    { key = "3", url = "https://www.notion.so/jchamberlin/In-Tray-148afe0dcf0380579f65fa17c5be51da" },
    { key = "4", url = "https://www.notion.so/jchamberlin/Second-Brain-3-6e70047fb94245eb87d3761cf3cd2855" },
    { key = "6", url = "https://github.com/jonathan-chamberlin?tab=repositories" },
}

for _, hk in ipairs(hotkeys) do
    hs.hotkey.bind({"alt"}, hk.key, function()
        openInComet(hk.url)
    end)
end
