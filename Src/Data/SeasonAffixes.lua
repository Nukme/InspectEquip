local _, _table_ = ...

local L = LibStub("AceLocale-3.0"):GetLocale("InspectEquip")

local seasonAffix = {
    L["Dread"], -- BFA Season 1
    L["Sinister"], -- BFA Season 2
    L["Notorious"], -- BFA Season 3
    L["Corrupted"], -- BFA Season 4
    L["Sinful"], -- Shadowlands Season 1
    L["Unchained"], -- Shadowlands Season 2
    L["Cosmic"], -- Shadowlands Season 3
    L["Eternal"], -- Shadowlands Season 4
    L["Crimson"], -- Dragonflight Season 1
}

local subAffix = {
    L["Aspirant"],
    L["Gladiator"],
}

_table_.seasonAffix = seasonAffix
_table_.subAffix = subAffix
