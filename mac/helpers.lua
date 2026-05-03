local M = {}

-- Raw NSEvent device-dependent modifier flags for distinguishing left/right
M.LEFT_ALT    = 0x00000020
M.RIGHT_ALT   = 0x00000040
M.RIGHT_CMD   = 0x00000010
M.RIGHT_SHIFT = 0x00000004

function M.hasLeftAlt(event)
    local rawFlags = event:getRawEventData().CGEventData.flags
    return (rawFlags & M.LEFT_ALT) ~= 0
end

function M.hasRightAlt(event)
    local rawFlags = event:getRawEventData().CGEventData.flags
    return (rawFlags & M.RIGHT_ALT) ~= 0
end

function M.hasRightCmd(event)
    local rawFlags = event:getRawEventData().CGEventData.flags
    return (rawFlags & M.RIGHT_CMD) ~= 0
end

function M.hasRightShift(event)
    local rawFlags = event:getRawEventData().CGEventData.flags
    return (rawFlags & M.RIGHT_SHIFT) ~= 0
end

return M
