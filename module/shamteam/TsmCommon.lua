
local chooseMapFromDiff = function(diff)
    local pool = TsmModuleData.getMapcodesByDiff(diff)
    -- TODO: priority for less completed maps?
    return pool[math.random(#pool)]
end

local pnDisp = function(pn)
    -- TODO: check if the player has the same name as another existing player in the room.
    return pn and (pn:find('#') and pn:sub(1,-6) or pn) or "N/A"
end

local expDisp = function(n, addColor)
    if addColor == nil then addColor = true end
    local sign, color = "", "<J>"
    if n > 0 then
        sign = "+"
        color = "<VP>"
    elseif n < 0 then
        sign = "-"
        color = "<R>"
    end
    if not addColor then color = "" end
    return color..sign..math.abs(n*100).."%"
end

local sendChatMessageStaff = function(msg, ...)
    msg = "[Staff] " .. string.format(msg, ...)
    for name, p in pairs(players) do
        if DEVS[name] or MODULE_MANAGERS[name] or TsmModuleData.isStaff(name) then
            p:chatMsg(msg)
        end
    end
end

local expToLevel = function(x)
    return math.floor (
        (EXP_ADVANCE_HALF + math.sqrt(EXP_ADVANCE_HALF * EXP_ADVANCE_HALF - 4 * EXP_ADVANCE_HALF * (-x)))
            / (2 * EXP_ADVANCE_HALF)
    )
end

local levelToExp = function(l)
    return EXP_ADVANCE_HALF * l * l - EXP_ADVANCE_HALF * l
end
