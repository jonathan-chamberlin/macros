local M = {}

-- Raw NSEvent device-dependent modifier flags for distinguishing left/right.
-- event:getFlags() collapses both sides into one bool, so we must inspect the
-- raw CGEventData flags to tell left-alt from right-alt, etc.
M.LEFT_ALT    = 0x00000020
M.RIGHT_ALT   = 0x00000040
M.RIGHT_CMD   = 0x00000010
M.RIGHT_SHIFT = 0x00000004

-- Extract raw CGEvent flags once; callers need the raw value to test side-specific bits
local function rawFlags(event)
    return event:getRawEventData().CGEventData.flags
end

function M.hasLeftAlt(event)
    return (rawFlags(event) & M.LEFT_ALT) ~= 0
end

function M.hasRightAlt(event)
    return (rawFlags(event) & M.RIGHT_ALT) ~= 0
end

function M.hasRightCmd(event)
    return (rawFlags(event) & M.RIGHT_CMD) ~= 0
end

function M.hasRightShift(event)
    return (rawFlags(event) & M.RIGHT_SHIFT) ~= 0
end

return M
