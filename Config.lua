local _, _table_ = ...

if not InspectEquip then
    return
end

local IE = InspectEquip
local L = LibStub("AceLocale-3.0"):GetLocale("InspectEquip")




local defaults = {
    profile = {
        tooltips = true,
        showUnknown = true,
        inspectWindow = true,
        charWindow = true,
        checkEnchants = true,
        listItemLevels = true,
        showAvgItemLevel = true,
        _StylizeClassTierCategory_ = true,
        ttR = 1.0,
        ttG = 0.75,
        ttB = 0.0,
        maxSourceCount = 5
    }
}


local options = {
    name = "InspectEquip",
    type = "group",
    args = {
        tooltips = {
            order = 1,
            type = "toggle",
            width = "full",
            name = L["Add drop information to tooltips"],
            desc = L["Add item drop information to all item tooltips"],
            get = function()
                return IE.configDB.profile.tooltips
            end,
            set = function(_, v)
                IE.configDB.profile.tooltips = v;
                if v then
                    IE:HookTooltips()
                end
            end
        },
        showunknown = {
            order = 2,
            type = "toggle",
            width = "full",
            name = L["Include unknown items in overview"],
            desc = L["Show items that cannot be categorized in a seperate category"],
            get = function()
                return IE.configDB.profile.showUnknown
            end,
            set = function(_, v)
                IE.configDB.profile.showUnknown = v
            end
        },
        inspectwindow = {
            order = 3,
            type = "toggle",
            width = "full",
            name = L["Attach to inspect window"],
            desc = L["Show the equipment list when inspecting other characters"],
            get = function()
                return IE.configDB.profile.inspectWindow
            end,
            set = function(_, v)
                IE.configDB.profile.inspectWindow = v
            end
        },
        charwindow = {
            order = 4,
            type = "toggle",
            width = "full",
            name = L["Attach to character window"],
            desc = L["Also show the InspectEquip panel when opening the character window"],
            get = function()
                return IE.configDB.profile.charWindow
            end,
            set = function(_, v)
                IE.configDB.profile.charWindow = v
            end
        },
        checkenchants = {
            order = 5,
            type = "toggle",
            width = "full",
            name = L["Check for unenchanted items"],
            desc = L["Display a warning for unenchanted items"],
            get = function()
                return IE.configDB.profile.checkEnchants
            end,
            set = function(_, v)
                IE.configDB.profile.checkEnchants = v
            end
        },
        listitemlevels = {
            order = 6,
            type = "toggle",
            width = "full",
            name = L["Show item level in equipment list"],
            desc = L["Show the item level of each item in the equipment panel"],
            get = function()
                return IE.configDB.profile.listItemLevels
            end,
            set = function(_, v)
                IE.configDB.profile.listItemLevels = v
            end
        },
        showavgitemlevel = {
            order = 7,
            type = "toggle",
            width = "full",
            name = L["Show average item level in equipment list"],
            desc = L["Show the average item level of all items in the equipment panel"],
            get = function()
                return IE.configDB.profile.showAvgItemLevel
            end,
            set = function(_, v)
                IE.configDB.profile.showAvgItemLevel = v
            end
        },
        stylizeclasstiercategory = {
            order = 8,
            type = "toggle",
            width = "full",
            name = L["Stylize Class Tier Set category label"],
            desc = L["Show Class Tier Set category label with class color and class icon"],
            get = function()
                return IE.configDB.profile._StylizeClassTierCategory_
            end,
            set = function(_, v)
                IE.configDB.profile._StylizeClassTierCategory_ = v
            end
        },
        tooltipcolor = {
            order = 18,
            type = "color",
            name = L["Tooltip text color"],
            width = "full",
            get = function()
                return IE.configDB.profile.ttR, IE.configDB.profile.ttG, IE.configDB.profile.ttB, 1.0
            end,
            set = function(_, r, g, b, a)
                IE.configDB.profile.ttR = r
                IE.configDB.profile.ttG = g
                IE.configDB.profile.ttB = b
            end
        },
        maxsourcecount = {
            order = 19,
            type = "range",
            min = 1,
            max = 20,
            softMax = 10,
            step = 1,
            width = "double",
            name = L["Max. amount of sources in tooltips"],
            desc = L["The maximum amount of sources that are displayed in item tooltips"],
            get = function()
                return IE.configDB.profile.maxSourceCount
            end,
            set = function(_, v)
                IE.configDB.profile.maxSourceCount = v
            end
        },
        database = {
            order = 20,
            type = "group",
            inline = true,
            name = L["Database"],
            args = {
                resetdb = {
                    order = 1,
                    type = "execute",
                    width = "double",
                    name = L["Reset database"],
                    desc = L["Recreate the database"],
                    func = function()
                        IE:CreateLocalDatabase()
                    end
                }
            }
        }
    }
}


_table_.defaults = defaults
_table_.options = options