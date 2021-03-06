TsmRotation = {}

local LOBBY_MAPCODE = 7740307
local custom_map
local custom_mode

local is_awaiting_lobby
local awaiting_mapcode
local awaiting_diff
local awaiting_mode
local expect_sham1
local expect_sham2

local chosen_mode
local preferred_diff_range
local chosen_mods
local custom_sham1
local custom_sham2

local choose_map = function(mode, diff)
    local mapcodes = TsmModuleData.getMapcodesByDiff(mode, diff)
    return mapcodes[math.random(#mapcodes)]
end

TsmRotation.overrideMap = function(mapcode)
    custom_map = mapcode
end

TsmRotation.overrideMode = function(mode)
    custom_mode = mode
end

TsmRotation.overrideExpectedShaman = function(sham1, sham2)
    custom_sham1 = sham1
    custom_sham2 = sham2
end

TsmRotation.setMode = function(mode)
    chosen_mode = mode
end

TsmRotation.setDiffRange = function(lower, upper)
    if not upper then
        upper = lower
    end
    preferred_diff_range = {lower, upper}
end

TsmRotation.setMods = function(mods)
    chosen_mods = mods
end

TsmRotation.doLobby = function()
    local first, second
    for name, p in pairs(players) do
        if not p:isExcluded() then
            if not first or p.score > first.score then
                second = first
                first = p
            elseif not second or p.score > second.score then
                second = p
            end
        end
    end

    if not first then
        tfm.exec.setGameTime(5)
        --[[
            it often happens where a newly created room does not have any players at
            this point. in such a case, reload the lobby ASAP after all the players
            have initialised. I'm not exactly sure but 10ms minimum *should* be plenty
            enough time for all players in the room to finish triggerring their
            eventNewPlayer.. :fingers_crossed:
        ]]--
        TimedTask.add(module_started and 5000 or 10, TsmRotation.doLobby)
    else
        expect_sham1, expect_sham2 = first.name, second and second.name
        -- apply overrides
        if custom_sham1 and players[custom_sham1] and not players[custom_sham1]:isExcluded() then
            expect_sham1 = custom_sham1
        end
        if custom_sham2 and players[custom_sham2] and not players[custom_sham2]:isExcluded() then
            expect_sham2 = custom_sham2
        end

        -- set highest score for the two expected shams so autoshaman hopefully picks them up the next round
        local ss = first.score + 10
        players[expect_sham1]:setScore(ss)
        if expect_sham2 then players[expect_sham2]:setScore(ss) end
        
        -- reset overrides
        custom_sham1, custom_sham2 = nil, nil

        is_awaiting_lobby = true
        map_sched.load(LOBBY_MAPCODE)
    end
end

--[[
    signal newGame.
    status => false if current map is unexpected, will auto reload.
    return status (bool), fields (table)
    fields:
        - is_lobby
        - difficulty
        - mode
        - is_custom_load
]]--
TsmRotation.signalNgAndHandover = function()
    local mapcode = int_mapcode(room.currentMap)

    if is_awaiting_lobby then
        if mapcode ~= LOBBY_MAPCODE then
            if module_started then
                map_sched.load(LOBBY_MAPCODE)
            end
            return false
        end
    elseif awaiting_mapcode == nil then
        if module_started then
            TsmRotation.doLobby()
        end
        return false
    elseif awaiting_mapcode ~= mapcode then
        if module_started then
            map_sched.load(awaiting_mapcode)
        end
        return false
    end

    local ret = {}
    ret.is_lobby = is_awaiting_lobby
    ret.mods = chosen_mods

    -- Check for expected shamans and in the worst case scenario manually set
    -- correct ones using tfm.exec.setShaman
    local sh, shk = TsmRound.getShamans()
    local recheck = false
    for i = 1, #sh do
        if (expect_sham1 and sh[i] ~= expect_sham1)
                and (expect_sham2 and sh[i] ~= expect_sham2) then
            -- unexpected shaman
            recheck = true
            tfm.exec.setShaman(sh[i], false)
            -- TODO: a more elegant way to put mouse back to spawn?
            tfm.exec.killPlayer(sh[i])
            tfm.exec.respawnPlayer(sh[i])
            print("Unexpected shaman: " .. sh[i])
        end
    end

    if expect_sham1 and not shk[expect_sham1] then
        tfm.exec.setShaman(expect_sham1)
        recheck = true
    end
    if expect_sham2 and not shk[expect_sham2] then
        tfm.exec.setShaman(expect_sham2)
        recheck = true
    end

    if recheck then
        ret.shamans, ret.shamans_key = {expect_sham1, expect_sham2}, {}
        for i = 1, #ret.shamans do
            ret.shamans_key[ret.shamans[i]] = true
        end
        print(string.format("Unexpected shamans caught - The expected ones are: %s%s",
                expect_sham1, expect_sham2 and (" & " .. expect_sham2) or ""))
    else
        ret.shamans, ret.shamans_key = sh, shk
    end

    if not is_awaiting_lobby then
        ret.difficulty = awaiting_diff
        ret.mode = awaiting_mode
        ret.is_custom_load = custom_map ~= nil
        ret.mods = chosen_mods

        custom_map = nil
        custom_mode = nil
        expect_sham1 = nil
        expect_sham2 = nil
    end

    is_awaiting_lobby = nil
    awaiting_mapcode = nil
    awaiting_diff = nil
    chosen_mode = nil
    preferred_diff_range = nil
    chosen_mods = nil

    return true, ret
end

TsmRotation.doRotate = function()
    if not MDHelper.getMdLoaded() then
        print("module data hasn't been loaded, retrying...")
        TimedTask.add(1000, TsmRotation.doRotate)
        return
    end

    local map
    local mode = custom_mode or chosen_mode or TSM_HARD
    if custom_map then
        map = custom_map
        awaiting_diff = 0
    else
        local diff = math.random(preferred_diff_range[1], preferred_diff_range[2])
        map = choose_map(mode, diff)
        awaiting_diff = diff
    end
    awaiting_mapcode = map
    awaiting_mode = mode
    map_sched.load(map)
end
