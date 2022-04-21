--[[
    Table Format:
        Key     - english class name, independent of game-client
        Value   - class icon fileid
--]]

local _, _table_ = ...

local CLASS_ICONS = {
    ["WARRIOR"] = 626008, 
    ["PALADIN"] = 626003,
    ["HUNTER"] = 626000,
    ["ROGUE"] = 626005,
    ["PRIEST"] = 626004,
    ["DEATHKNIGHT"] = 625998,
    ["SHAMAN"] = 626006,
    ["MAGE"] = 626001,
    ["WARLOCK"] = 626007,
    ["MONK"] = 626002,
    ["DRUID"] = 625999,
    ["DEMONHUNTER"] = 1260827,
}

_table_.CLASS_ICONS = CLASS_ICONS