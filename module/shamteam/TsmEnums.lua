
--- Module
local MODULE_ID = 3
local MODULE_ROOMNAME = "shamteam"
local MODULE_VERSION = "v1.0-Beta"

--- Round phases
local PHASE_START = 0
local PHASE_READY = 1
local PHASE_MORTED = 2
local PHASE_TIMESUP = 3

--- Modes
local TSM_HARD = 1
local TSM_DIV = 2

--- Staff
local MODULE_MANAGERS = {
    ["Emeryaurora#0000"] = true,
    ["Pegasusflyer#0000"] = true,
    ["Rini#5475"] = true,
    ["Rayallan#0000"] = true,
    ["Shibbbbbyy#1143"] = true
}

--- Windows
local WINDOW_GUI = bit32.lshift(0, 7)
local WINDOW_HELP = bit32.lshift(1, 7)
local WINDOW_LOBBY = bit32.lshift(2, 7)
local WINDOW_OPTIONS = bit32.lshift(3, 7)
local WINDOW_PROFILE = bit32.lshift(4, 7)
local WINDOW_DB_MAP = bit32.lshift(5, 7)
local WINDOW_DB_HISTORY = bit32.lshift(6, 7)

--- TextAreas
local TA_SPECTATING = 9000

--- GUI color defs
local GUI_BTN = "<font color='#EDCC8D'>"

--- Images
local IMG_FEATHER_HARD = "172e1332b11.png" -- hard feather 30px width
local IMG_FEATHER_DIVINE = "172e14b438a.png" -- divine feather 30px width
local IMG_FEATHER_HARD_DISABLED = "172ed052b25.png"
local IMG_FEATHER_DIVINE_DISABLED = "172ed050e45.png"
local IMG_TOGGLE_ON = "172e5c315f1.png" -- 30px width
local IMG_TOGGLE_OFF = "172e5c335e7.png" -- 30px width
local IMG_LOBBY_BG = "172e68f8d24.png"
local IMG_HELP = "172e72750d9.png" -- 18px width
local IMG_OPTIONS_BG = "172eb766bdd.png" -- 240 x 325
local IMG_RANGE_CIRCLE = "172ef5c1de4.png" -- 240 x 240

--- Link IDs
local LINK_DISCORD = 1

local LINKS = {
    [LINK_DISCORD] = "https://discord.gg/YkzM4rh",
}

--- AntiLag ping (ms) thresholds
local ANTILAG_WARN_THRESHOLD = 1400 -- 690
local ANTILAG_FORCE_THRESHOLD = 3000 -- 1100

--- Difficulty level
local HIGHEST_DIFFICULTY = 5

--- Shaman objects / summons
local O_BTYPE_ARROW = 0
local O_BTYPE_BALLOON = 28

local O_TYPE_TOTEM = 44

--- Others
local THM_SPAWN_RANGE = 60 -- Spawn range radius (px) in hard mode
local MAX_SOLID_BALLOONS = 3

--- MODS
local MOD_TELEPATHY = 1
local MOD_WORK_FAST = 2
local MOD_BUTTER_FINGERS = 3
local MOD_SNAIL_NAIL = 4

-- {name (localisation key), multiplier, description (localisation key)}
local GAME_MODS = {
    [MOD_TELEPATHY] = {"name_telepathy", 0.5, "desc_telepathy"},
    [MOD_WORK_FAST] = {"name_work_fast", 0.3, "desc_work_fast"},
    [MOD_BUTTER_FINGERS] = {"name_butter_fingers", -0.5, "desc_butter_fingers"},
    [MOD_SNAIL_NAIL] = {"name_snail_nail", -0.5, "desc_snail_nail"},
}

--- OPTIONS
local OPT_ANTILAG = 1
local OPT_GUI = 2
local OPT_CIRCLE = 3
local OPT_LANGUAGE = 4

-- {name (localisation key), description (localisation key)}
local PLAYER_OPTIONS = {
    [OPT_ANTILAG] = {"name_antilag", "desc_antilag"},
    [OPT_GUI] = {"name_gui", "desc_gui"},
    [OPT_CIRCLE] = {"name_circle", "desc_circle"},
}

--- EXP / LEVEL
local EXP_ADVANCE_HALF = 50 -- should be half of the EXP required to reach level 2
local EXP_ADVANCE = EXP_ADVANCE_HALF * 2
