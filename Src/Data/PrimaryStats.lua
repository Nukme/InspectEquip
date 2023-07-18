--[[
    Table Format :
        Key     - specialization id
        Value   - corresponding primary stat
--]]

local _, _table_ = ...

local primaryStats = {
    -- Death Knight
    ["250"] = LE_UNIT_STAT_STRENGTH,   -- Blood
    ["251"] = LE_UNIT_STAT_STRENGTH,   -- Frost
    ["252"] = LE_UNIT_STAT_STRENGTH,   -- Unholy
    -- Demon Hunter
    ["577"] = LE_UNIT_STAT_AGILITY,    -- Havoc
    ["581"] = LE_UNIT_STAT_AGILITY,    -- Vengeance
    -- Druid
    ["102"] = LE_UNIT_STAT_INTELLECT,  -- Balance
    ["103"] = LE_UNIT_STAT_AGILITY,    -- Feral
    ["104"] = LE_UNIT_STAT_AGILITY,    -- Guardian
    ["105"] = LE_UNIT_STAT_INTELLECT,  -- Restoration
    -- Hunter
    ["253"] = LE_UNIT_STAT_AGILITY,    -- Beast Mastery
    ["254"] = LE_UNIT_STAT_AGILITY,    -- Marksmanship
    ["255"] = LE_UNIT_STAT_AGILITY,    -- Survival
    -- Mage
    ["62"] = LE_UNIT_STAT_INTELLECT,   -- Arcane
    ["63"] = LE_UNIT_STAT_INTELLECT,   -- Fire
    ["64"] = LE_UNIT_STAT_INTELLECT,   -- Frost
    -- Monk
    ["268"] = LE_UNIT_STAT_AGILITY,    -- Brewmaster
    ["270"] = LE_UNIT_STAT_INTELLECT,  -- Mistweaver
    ["269"] = LE_UNIT_STAT_AGILITY,    -- Windwalker
    -- Paladin
    ["65"] = LE_UNIT_STAT_INTELLECT,   -- Holy
    ["66"] = LE_UNIT_STAT_STRENGTH,    -- Protection
    ["70"] = LE_UNIT_STAT_STRENGTH,    -- Retribution
    -- Priest
    ["256"] = LE_UNIT_STAT_INTELLECT,  -- Discipline
    ["257"] = LE_UNIT_STAT_INTELLECT,  -- Holy
    ["258"] = LE_UNIT_STAT_INTELLECT,  -- Shadow
    -- Rogue
    ["259"] = LE_UNIT_STAT_AGILITY,    -- Assassination
    ["260"] = LE_UNIT_STAT_AGILITY,    -- Outlaw
    ["261"] = LE_UNIT_STAT_AGILITY,    -- Subtlety
    -- Shaman
    ["262"] = LE_UNIT_STAT_INTELLECT,  -- Elemental
    ["263"] = LE_UNIT_STAT_AGILITY,    -- Enhancement
    ["264"] = LE_UNIT_STAT_INTELLECT,  -- Restoration
    -- Warlock
    ["265"] = LE_UNIT_STAT_INTELLECT,  -- Affliction
    ["266"] = LE_UNIT_STAT_INTELLECT,  -- Demonology
    ["267"] = LE_UNIT_STAT_INTELLECT,  -- Destruction
    -- Warrior
    ["71"] = LE_UNIT_STAT_STRENGTH,    -- Arms
    ["72"] = LE_UNIT_STAT_STRENGTH,    -- Fury
    ["73"] = LE_UNIT_STAT_STRENGTH,    -- Protection
    -- Evoker
    ["1467"] = LE_UNIT_STAT_INTELLECT, -- Devastation
    ["1468"] = LE_UNIT_STAT_INTELLECT, -- Preservation
    ["1473"] = LE_UNIT_STAT_INTELLECT, -- Augmentation
}

_table_.primaryStats = primaryStats
