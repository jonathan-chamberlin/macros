-- Cmd+Option+R → toggle screen+system-audio recording for Google Meet.
-- First press starts ffmpeg; second press SIGINTs it so the .mov finalizes cleanly.
-- All routing/teardown lives in meet-record-toggle.sh; this module is just the binding.

local SCRIPT = "/Users/jonathanchamberlin/repos/macros/mac/meet-record-toggle.sh"

hs.hotkey.bind({"cmd", "alt"}, "r", function()
    -- Visual confirmation the binding fired (debug aid; safe to remove later).
    hs.alert.show("Meet record toggle", 0.6)
    print("[meet-record] hotkey fired at " .. os.date("%H:%M:%S"))
    -- /bin/bash -c so we always go through a shell — more robust than direct exec
    -- and gives us a clean place to capture stderr if we ever need to.
    hs.task.new("/bin/bash", function(exitCode, stdOut, stdErr)
        if exitCode ~= 0 then
            print("[meet-record] script exit=" .. tostring(exitCode) .. " stderr=" .. tostring(stdErr))
        end
    end, {"-c", SCRIPT}):start()
end)
