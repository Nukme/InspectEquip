local _, _table_ = ...

local L = LibStub("AceLocale-3.0"):GetLocale("InspectEquip")

local seasonAffix = {
    L["Dread"],     -- BFA Season 1
    L["Sinister"],  -- BFA Season 2
    L["Notorious"], -- BFA Season 3
    L["Corrupted"], -- BFA Season 4
    L["Sinful"],    -- Shadowlands Season 1
    L["Unchained"], -- Shadowlands Season 2
    L["Cosmic"],    -- Shadowlands Season 3
    L["Eternal"],   -- Shadowlands Season 4
    L["Crimson"],   -- Dragonflight Season 1
    L["Obsidian"],  -- Dragonflight Season 2
    L["Verdant"],   -- Dragonflight Season 3
    L["Draconic"],  -- Dragonflight Season 4
    L["Forged"],    -- TWW Season 1
    L["Prized"],    -- TWW Season 2
    L["Astral"],    -- TWW Season 3
}

local subAffix = {
    L["Aspirant"],
    L["Gladiator"],
}

_table_.seasonAffix = seasonAffix
_table_.subAffix = subAffix
