if not InspectEquip then
    return
end

local _, _table_ = ...


local BB = LibStub("LibBabble-Boss-3.0"):GetUnstrictLookupTable()
local BZ = LibStub("LibBabble-SubZone-3.0"):GetUnstrictLookupTable()
local L = LibStub("AceLocale-3.0"):GetLocale("InspectEquip")

_table_.ManualItemDB = {
    Zones = {},
    Bosses = {
        [-1] = L["Quest"],
        [0] = L["Trash"],
        [10001] = BB["Nightbane"] or "Nightbane",
        [90101] = L["Kyrian Nathrian Weapon Vendors"],
        [90102] = L["Venthyr Nathrian Weapon Vendors"],
        [90103] = L["Necrolord Nathrian Weapon Vendors"],
        [90104] = L["Night Fae Nathrian Weapon Vendors"],
    },
    Items = {
        -- Return to Karazhan : Nightbane loot
        [143523] = "d_860_4_10001",
        [143524] = "d_860_4_10001",
        [143525] = "d_860_4_10001",
        [143526] = "d_860_4_10001",
        [143527] = "d_860_4_10001",
        [143528] = "d_860_4_10001",
        [143529] = "d_860_4_10001",
        [143530] = "d_860_4_10001",
        [143531] = "d_860_4_10001",
        [143532] = "d_860_4_10001",
        [142166] = "d_860_4_10001",
        [142297] = "d_860_4_10001",
        [142203] = "d_860_4_10001",
        [142301] = "d_860_4_10001",
        [142303] = "d_860_4_10001",
        [142552] = "d_860_4_10001",
        -- Emerald Nightmare : Trash loot
        [140993] = "r_768_15360_0",
        [140996] = "r_768_15360_0",
        [141694] = "r_768_15360_0",
        [141695] = "r_768_15360_0",
        [141696] = "r_768_15360_0",
        -- Trial of Valor : Trash loot
        [142541] = "r_861_15360_0",
        -- Nighthold : Quest reward and trash loot
        [141324] = "r_786_1024_-1",
        [141325] = "r_786_2048_-1",
        [141326] = "r_786_4096_-1",
        [144404] = "r_786_15360_0",
        [144405] = "r_786_15360_0",
        [144406] = "r_786_15360_0",
        [144407] = "r_786_15360_0",
        [144399] = "r_786_15360_0",
        [144400] = "r_786_15360_0",
        [144401] = "r_786_15360_0",
        [144403] = "r_786_15360_0",
        -- Tomb of Sargeras : Trash loot
        [147423] = "r_875_15360_0",
        [147422] = "r_875_15360_0",
        [146989] = "r_875_15360_0",
        [147425] = "r_875_15360_0",
        [147424] = "r_875_15360_0",
        [147038] = "r_875_15360_0",
        [147427] = "r_875_15360_0",
        [147426] = "r_875_15360_0",
        [147044] = "r_875_15360_0",
        [147429] = "r_875_15360_0",
        [147428] = "r_875_15360_0",
        [147064] = "r_875_15360_0",
        -- Antorus, the Burning Throne : Trash loot/ Hidden loot
        [152084] = "r_946_15360_0",
        [152085] = "r_946_15360_0",
        [153018] = "r_946_15360_0",
        [151993] = "r_946_15360_0",
        [152087] = "r_946_15360_0",
        [152413] = "r_946_15360_0",
        [152088] = "r_946_15360_0",
        [152089] = "r_946_15360_0",
        [152682] = "r_946_15360_0",
        [152090] = "r_946_15360_0",
        [152091] = "r_946_15360_0",
        [153019] = "r_946_15360_0",
        [151974] = "r_946_15360_1987",
        -- Uldir : Trash loot
        [161071] = "r_1031_15360_0",
        [160612] = "r_1031_15360_0",
        [161072] = "r_1031_15360_0",
        [161075] = "r_1031_15360_0",
        [161073] = "r_1031_15360_0",
        [161076] = "r_1031_15360_0",
        [161074] = "r_1031_15360_0",
        [161077] = "r_1031_15360_0",
        -- Battle of Dazar'alor : Trash loot
        [165765] = "r_1176_15360_0",
        [165509] = "r_1176_15360_0",
        [165518] = "r_1176_15360_0",
        [165520] = "r_1176_15360_0",
        [165545] = "r_1176_15360_0",
        [165547] = "r_1176_15360_0",
        [165564] = "r_1176_15360_0",
        [165563] = "r_1176_15360_0",
        [165925] = "r_1176_15360_0",
        -- Eternal Palace : Trash Loot
        [169930] = "r_1179_15360_0",
        [169929] = "r_1179_15360_0",
        [169932] = "r_1179_15360_0",
        [169931] = "r_1179_15360_0",
        [169934] = "r_1179_15360_0",
        [169933] = "r_1179_15360_0",
        [169936] = "r_1179_15360_0",
        [169935] = "r_1179_15360_0",
        [168602] = "r_1179_15360_0",
        -- Operation:Mechagon : Hardmode Azerite Helms
        [169003] = "d_1178_4_2331",
        [169004] = "d_1178_4_2331",
        [169005] = "d_1178_4_2331",
        [169006] = "d_1178_4_2331",
        [168830] = "d_1178_4_2331",
        -- Ny'alotha, the Waking City : Trash Loot
        [175004] = "r_1180_15360_0",
        [175005] = "r_1180_15360_0",
        [175006] = "r_1180_15360_0",
        [175007] = "r_1180_15360_0",
        [175008] = "r_1180_15360_0",
        [175009] = "r_1180_15360_0",
        [175010] = "r_1180_15360_0",
        -- Castle Nathria : Trash Loot
        [183035] = "r_1190_15360_0",
        [181393] = "r_1190_15360_0",
        [183008] = "r_1190_15360_0",
        [183017] = "r_1190_15360_0",
        [183010] = "r_1190_15360_0",
        [182978] = "r_1190_15360_0",
        [182990] = "r_1190_15360_0",
        [182982] = "r_1190_15360_0",
        [183013] = "r_1190_15360_0",
        [183031] = "r_1190_15360_0",
        -- Castle Nathria : Weapons
        -- Kyrian
        [174298] = "r_1190_15360_90101",
        [174302] = "r_1190_15360_90101",
        [174310] = "r_1190_15360_90101",
        [174315] = "r_1190_15360_90101",
        [175251] = "r_1190_15360_90101",
        [175254] = "r_1190_15360_90101",
        [175279] = "r_1190_15360_90101",
        [176098] = "r_1190_15360_90101",
        [177849] = "r_1190_15360_90101",
        [177850] = "r_1190_15360_90101",
        [177855] = "r_1190_15360_90101",
        [177860] = "r_1190_15360_90101",
        [177865] = "r_1190_15360_90101",
        [177870] = "r_1190_15360_90101",
        [177872] = "r_1190_15360_90101",
        [178973] = "r_1190_15360_90101",
        [178975] = "r_1190_15360_90101",
        [180312] = "r_1190_15360_90101",
        [180315] = "r_1190_15360_90101",
        [184230] = "r_1190_15360_90101",
        [184236] = "r_1190_15360_90101",
        [184243] = "r_1190_15360_90101",
        [184270] = "r_1190_15360_90101",
        [184271] = "r_1190_15360_90101",
        [184272] = "r_1190_15360_90101",
        [184273] = "r_1190_15360_90101",
        [184274] = "r_1190_15360_90101",
        [184275] = "r_1190_15360_90101",
        -- Venthyr
        [182388] = "r_1190_15360_90102",
        [182389] = "r_1190_15360_90102",
        [182390] = "r_1190_15360_90102",
        [182391] = "r_1190_15360_90102",
        [182392] = "r_1190_15360_90102",
        [182393] = "r_1190_15360_90102",
        [182394] = "r_1190_15360_90102",
        [182395] = "r_1190_15360_90102",
        [182396] = "r_1190_15360_90102",
        [182397] = "r_1190_15360_90102",
        [182398] = "r_1190_15360_90102",
        [182399] = "r_1190_15360_90102",
        [182400] = "r_1190_15360_90102",
        [182414] = "r_1190_15360_90102",
        [182415] = "r_1190_15360_90102",
        [182416] = "r_1190_15360_90102",
        [182417] = "r_1190_15360_90102",
        [182418] = "r_1190_15360_90102",
        [182419] = "r_1190_15360_90102",
        [182420] = "r_1190_15360_90102",
        [182421] = "r_1190_15360_90102",
        [182422] = "r_1190_15360_90102",
        [182423] = "r_1190_15360_90102",
        [182424] = "r_1190_15360_90102",
        [182425] = "r_1190_15360_90102",
        [182426] = "r_1190_15360_90102",
        -- Necrolord
        [184244] = "r_1190_15360_90103",
        [184245] = "r_1190_15360_90103",
        [184246] = "r_1190_15360_90103",
        [184247] = "r_1190_15360_90103",
        [184248] = "r_1190_15360_90103",
        [184249] = "r_1190_15360_90103",
        [184250] = "r_1190_15360_90103",
        [184251] = "r_1190_15360_90103",
        [184252] = "r_1190_15360_90103",
        [184253] = "r_1190_15360_90103",
        [184254] = "r_1190_15360_90103",
        [184255] = "r_1190_15360_90103",
        [184256] = "r_1190_15360_90103",
        [184257] = "r_1190_15360_90103",
        [184258] = "r_1190_15360_90103",
        [184259] = "r_1190_15360_90103",
        [184260] = "r_1190_15360_90103",
        [184261] = "r_1190_15360_90103",
        [184262] = "r_1190_15360_90103",
        [184263] = "r_1190_15360_90103",
        [184264] = "r_1190_15360_90103",
        [184265] = "r_1190_15360_90103",
        [184266] = "r_1190_15360_90103",
        [184267] = "r_1190_15360_90103",
        -- Night Fae
        [179492] = "r_1190_15360_90104",
        [179497] = "r_1190_15360_90104",
        [179527] = "r_1190_15360_90104",
        [179530] = "r_1190_15360_90104",
        [179541] = "r_1190_15360_90104",
        [179544] = "r_1190_15360_90104",
        [179557] = "r_1190_15360_90104",
        [179561] = "r_1190_15360_90104",
        [179566] = "r_1190_15360_90104",
        [179570] = "r_1190_15360_90104",
        [179577] = "r_1190_15360_90104",
        [179579] = "r_1190_15360_90104",
        [179610] = "r_1190_15360_90104",
        [179611] = "r_1190_15360_90104",
        [180000] = "r_1190_15360_90104",
        [180002] = "r_1190_15360_90104",
        [180022] = "r_1190_15360_90104",
        [180023] = "r_1190_15360_90104",
        [180071] = "r_1190_15360_90104",
        [180073] = "r_1190_15360_90104",
        [180258] = "r_1190_15360_90104",
        [180260] = "r_1190_15360_90104",
        [182351] = "r_1190_15360_90104",
        [184241] = "r_1190_15360_90104",
        -- Sanctum of Domination : Trash Loot
        [186356] = "r_1193_15360_0",
        [186358] = "r_1193_15360_0",
        [186362] = "r_1193_15360_0",
        [186359] = "r_1193_15360_0",
        [186367] = "r_1193_15360_0",
        [186364] = "r_1193_15360_0",
        [186373] = "r_1193_15360_0",
        [186371] = "r_1193_15360_0",
        [186410] = "r_1193_15360_1615",
        -- Sepulcher of the First Ones : Trash Loot
        [190631] = "r_1195_15360_0",
        [190630] = "r_1195_15360_0",
        [190626] = "r_1195_15360_0",
        [190627] = "r_1195_15360_0",
        [190629] = "r_1195_15360_0",
        [190628] = "r_1195_15360_0",
        [190624] = "r_1195_15360_0",
        [190625] = "r_1195_15360_0",
        [190334] = "r_1195_15360_0",
        -- Sepulcher of the First Ones : Tier set pieces
        -- Death Knight
        [188868] = "t_r_1195_15360_2469;t_tgv;t_cc", -- Head -  Anduin Wrynn
        [188867] = "t_r_1195_15360_2457;t_tgv;t_cc", -- Shoulder - Lords of Dread
        [188864] = "t_r_1195_15360_2467;t_tgv;t_cc", -- Chest - Rygelon
        [188866] = "t_r_1195_15360_2463;t_tgv;t_cc", -- Legs - Halondrus
        [188863] = "t_r_1195_15360_2461;t_tgv;t_cc", -- Hands - Lihuvim
        -- Demon Hunter
        [188892] = "t_r_1195_15360_2469;t_tgv;t_cc", -- Head -  Anduin Wrynn
        [188896] = "t_r_1195_15360_2457;t_tgv;t_cc", -- Shoulder - Lords of Dread
        [188894] = "t_r_1195_15360_2467;t_tgv;t_cc", -- Chest - Rygelon
        [188893] = "t_r_1195_15360_2463;t_tgv;t_cc", -- Legs - Halondrus
        [188898] = "t_r_1195_15360_2461;t_tgv;t_cc", -- Hands - Lihuvim
        -- Warlock
        [188889] = "t_r_1195_15360_2469;t_tgv;t_cc", -- Head -  Anduin Wrynn
        [188888] = "t_r_1195_15360_2457;t_tgv;t_cc", -- Shoulder - Lords of Dread
        [188884] = "t_r_1195_15360_2467;t_tgv;t_cc", -- Chest - Rygelon
        [188887] = "t_r_1195_15360_2463;t_tgv;t_cc", -- Legs - Halondrus
        [188890] = "t_r_1195_15360_2461;t_tgv;t_cc", -- Hands - Lihuvim
        -- Druid
        [188847] = "t_r_1195_15360_2469;t_tgv;t_cc", -- Head -  Anduin Wrynn
        [188851] = "t_r_1195_15360_2457;t_tgv;t_cc", -- Shoulder - Lords of Dread
        [188849] = "t_r_1195_15360_2467;t_tgv;t_cc", -- Chest - Rygelon
        [188848] = "t_r_1195_15360_2463;t_tgv;t_cc", -- Legs - Halondrus
        [188853] = "t_r_1195_15360_2461;t_tgv;t_cc", -- Hands - Lihuvim
        -- Hunter
        [188859] = "t_r_1195_15360_2469;t_tgv;t_cc", -- Head -  Anduin Wrynn
        [188856] = "t_r_1195_15360_2457;t_tgv;t_cc", -- Shoulder - Lords of Dread
        [188858] = "t_r_1195_15360_2467;t_tgv;t_cc", -- Chest - Rygelon
        [188860] = "t_r_1195_15360_2463;t_tgv;t_cc", -- Legs - Halondrus
        [188861] = "t_r_1195_15360_2461;t_tgv;t_cc", -- Hands - Lihuvim
        -- Mage
        [188844] = "t_r_1195_15360_2469;t_tgv;t_cc", -- Head -  Anduin Wrynn
        [188843] = "t_r_1195_15360_2457;t_tgv;t_cc", -- Shoulder - Lords of Dread
        [188839] = "t_r_1195_15360_2467;t_tgv;t_cc", -- Chest - Rygelon
        [188842] = "t_r_1195_15360_2463;t_tgv;t_cc", -- Legs - Halondrus
        [188845] = "t_r_1195_15360_2461;t_tgv;t_cc", -- Hands - Lihuvim
        -- Paladin
        [188933] = "t_r_1195_15360_2469;t_tgv;t_cc", -- Head -  Anduin Wrynn
        [188932] = "t_r_1195_15360_2457;t_tgv;t_cc", -- Shoulder - Lords of Dread
        [188929] = "t_r_1195_15360_2467;t_tgv;t_cc", -- Chest - Rygelon
        [188931] = "t_r_1195_15360_2463;t_tgv;t_cc", -- Legs - Halondrus
        [188928] = "t_r_1195_15360_2461;t_tgv;t_cc", -- Hands - Lihuvim
        -- Priest
        [188880] = "t_r_1195_15360_2469;t_tgv;t_cc", -- Head -  Anduin Wrynn
        [188879] = "t_r_1195_15360_2457;t_tgv;t_cc", -- Shoulder - Lords of Dread
        [188875] = "t_r_1195_15360_2467;t_tgv;t_cc", -- Chest - Rygelon
        [188878] = "t_r_1195_15360_2463;t_tgv;t_cc", -- Legs - Halondrus
        [188881] = "t_r_1195_15360_2461;t_tgv;t_cc", -- Hands - Lihuvim
        -- Shaman
        [188923] = "t_r_1195_15360_2469;t_tgv;t_cc", -- Head -  Anduin Wrynn
        [188920] = "t_r_1195_15360_2457;t_tgv;t_cc", -- Shoulder - Lords of Dread
        [188922] = "t_r_1195_15360_2467;t_tgv;t_cc", -- Chest - Rygelon
        [188924] = "t_r_1195_15360_2463;t_tgv;t_cc", -- Legs - Halondrus
        [188925] = "t_r_1195_15360_2461;t_tgv;t_cc", -- Hands - Lihuvim
        -- Monk
        [188910] = "t_r_1195_15360_2469;t_tgv;t_cc", -- Head -  Anduin Wrynn
        [188914] = "t_r_1195_15360_2457;t_tgv;t_cc", -- Shoulder - Lords of Dread
        [188912] = "t_r_1195_15360_2467;t_tgv;t_cc", -- Chest - Rygelon
        [188911] = "t_r_1195_15360_2463;t_tgv;t_cc", -- Legs - Halondrus
        [188916] = "t_r_1195_15360_2461;t_tgv;t_cc", -- Hands - Lihuvim
        -- Rogue
        [188901] = "t_r_1195_15360_2469;t_tgv;t_cc", -- Head -  Anduin Wrynn
        [188905] = "t_r_1195_15360_2457;t_tgv;t_cc", -- Shoulder - Lords of Dread
        [188903] = "t_r_1195_15360_2467;t_tgv;t_cc", -- Chest - Rygelon
        [188902] = "t_r_1195_15360_2463;t_tgv;t_cc", -- Legs - Halondrus
        [188907] = "t_r_1195_15360_2461;t_tgv;t_cc", -- Hands - Lihuvim
        -- Warrior
        [188942] = "t_r_1195_15360_2469;t_tgv;t_cc", -- Head -  Anduin Wrynn
        [188941] = "t_r_1195_15360_2457;t_tgv;t_cc", -- Shoulder - Lords of Dread
        [188938] = "t_r_1195_15360_2467;t_tgv;t_cc", -- Chest - Rygelon
        [188940] = "t_r_1195_15360_2463;t_tgv;t_cc", -- Legs - Halondrus
        [188937] = "t_r_1195_15360_2461;t_tgv;t_cc", -- Hands - Lihuvim
        -- Sepulcher of the First Ones : Tier set off-pieces
        -- Death Knight
        [188873] = "cc", -- Back
        [188869] = "cc", -- Wrist
        [188870] = "cc", -- Waist
        [188865] = "cc", -- Feet
        -- Demon Hunter
        [188900] = "cc", -- Back
        [188895] = "cc", -- Wrist
        [188897] = "cc", -- Waist
        [188899] = "cc", -- Feet
        -- Warlock
        [188891] = "cc", -- Back
        [188885] = "cc", -- Wrist
        [188886] = "cc", -- Waist
        [188883] = "cc", -- Feet
        -- Druid
        [188871] = "cc", -- Back
        [188850] = "cc", -- Wrist
        [188852] = "cc", -- Waist
        [188854] = "cc", -- Feet
        -- Hunter
        [188872] = "cc", -- Back
        [188855] = "cc", -- Wrist
        [188857] = "cc", -- Waist
        [188862] = "cc", -- Feet
        -- Mage
        [188846] = "cc", -- Back
        [188840] = "cc", -- Wrist
        [188841] = "cc", -- Waist
        [188838] = "cc", -- Feet
        -- Paladin
        [188936] = "cc", -- Back
        [188934] = "cc", -- Wrist
        [188935] = "cc", -- Waist
        [188930] = "cc", -- Feet
        -- Priest
        [188882] = "cc", -- Back
        [188876] = "cc", -- Wrist
        [188877] = "cc", -- Waist
        [188874] = "cc", -- Feet
        -- Shaman
        [188927] = "cc", -- Back
        [188919] = "cc", -- Wrist
        [188921] = "cc", -- Waist
        [188926] = "cc", -- Feet
        -- Monk
        [188918] = "cc", -- Back
        [188913] = "cc", -- Wrist
        [188915] = "cc", -- Waist
        [188917] = "cc", -- Feet
        -- Rogue
        [188909] = "cc", -- Back
        [188904] = "cc", -- Wrist
        [188906] = "cc", -- Waist
        [188908] = "cc", -- Feet
        -- Warrior
        [188945] = "cc", -- Back
        [188943] = "cc", -- Wrist
        [188944] = "cc", -- Waist
        [188939] = "cc", -- Feet

        -- Vault of the Incarnates : Trash Loot
        [202007] = "r_1200_15360_0",
        [202003] = "r_1200_15360_0",
        [202009] = "r_1200_15360_0",
        [202006] = "r_1200_15360_0",
        [202008] = "r_1200_15360_0",
        [202005] = "r_1200_15360_0",
        [201992] = "r_1200_15360_0",
        [202004] = "r_1200_15360_0",
        [202010] = "r_1200_15360_0",

        -- Vault of the Incarnates : Tier set main pieces
        -- Death Knight
        [200408] = "t_r_1200_15360_2499;t_tgv;t_ic", -- Head - Raszageth the Storm-Eater
        [200410] = "t_r_1200_15360_2493;t_tgv;t_ic", -- Shoulder - Broodkeeper Diurna
        [200405] = "t_r_1200_15360_2491;t_tgv;t_ic", -- Chest - Kurog Grimtotem
        [200407] = "t_r_1200_15360_2502;t_tgv;t_ic", -- Legs - Dathea, Ascended
        [200409] = "t_r_1200_15360_2482;t_tgv;t_ic", -- Hands - Sennarath, the Cold Breath
        -- Demon Hunter
        [200345] = "t_r_1200_15360_2499;t_tgv;t_ic", -- Head - Raszageth the Storm-Eater
        [200347] = "t_r_1200_15360_2493;t_tgv;t_ic", -- Shoulder - Broodkeeper Diurna
        [200342] = "t_r_1200_15360_2491;t_tgv;t_ic", -- Chest - Kurog Grimtotem
        [200344] = "t_r_1200_15360_2502;t_tgv;t_ic", -- Legs - Dathea, Ascended
        [200346] = "t_r_1200_15360_2482;t_tgv;t_ic", -- Hands - Sennarath, the Cold Breath
        -- Warlock
        [200336] = "t_r_1200_15360_2499;t_tgv;t_ic", -- Head - Raszageth the Storm-Eater
        [200338] = "t_r_1200_15360_2493;t_tgv;t_ic", -- Shoulder - Broodkeeper Diurna
        [200333] = "t_r_1200_15360_2491;t_tgv;t_ic", -- Chest - Kurog Grimtotem
        [200335] = "t_r_1200_15360_2502;t_tgv;t_ic", -- Legs - Dathea, Ascended
        [200337] = "t_r_1200_15360_2482;t_tgv;t_ic", -- Hands - Sennarath, the Cold Breath
        -- Druid
        [200354] = "t_r_1200_15360_2499;t_tgv;t_ic", -- Head - Raszageth the Storm-Eater
        [200356] = "t_r_1200_15360_2493;t_tgv;t_ic", -- Shoulder - Broodkeeper Diurna
        [200351] = "t_r_1200_15360_2491;t_tgv;t_ic", -- Chest - Kurog Grimtotem
        [200353] = "t_r_1200_15360_2502;t_tgv;t_ic", -- Legs - Dathea, Ascended
        [200355] = "t_r_1200_15360_2482;t_tgv;t_ic", -- Hands - Sennarath, the Cold Breath
        -- Hunter
        [200390] = "t_r_1200_15360_2499;t_tgv;t_ic", -- Head - Raszageth the Storm-Eater
        [200392] = "t_r_1200_15360_2493;t_tgv;t_ic", -- Shoulder - Broodkeeper Diurna
        [200387] = "t_r_1200_15360_2491;t_tgv;t_ic", -- Chest - Kurog Grimtotem
        [200389] = "t_r_1200_15360_2502;t_tgv;t_ic", -- Legs - Dathea, Ascended
        [200391] = "t_r_1200_15360_2482;t_tgv;t_ic", -- Hands - Sennarath, the Cold Breath
        -- Mage
        [200318] = "t_r_1200_15360_2499;t_tgv;t_ic", -- Head - Raszageth the Storm-Eater
        [200320] = "t_r_1200_15360_2493;t_tgv;t_ic", -- Shoulder - Broodkeeper Diurna
        [200315] = "t_r_1200_15360_2491;t_tgv;t_ic", -- Chest - Kurog Grimtotem
        [200317] = "t_r_1200_15360_2502;t_tgv;t_ic", -- Legs - Dathea, Ascended
        [200319] = "t_r_1200_15360_2482;t_tgv;t_ic", -- Hands - Sennarath, the Cold Breath
        -- Paladin
        [200417] = "t_r_1200_15360_2499;t_tgv;t_ic", -- Head - Raszageth the Storm-Eater
        [200419] = "t_r_1200_15360_2493;t_tgv;t_ic", -- Shoulder - Broodkeeper Diurna
        [200414] = "t_r_1200_15360_2491;t_tgv;t_ic", -- Chest - Kurog Grimtotem
        [200416] = "t_r_1200_15360_2502;t_tgv;t_ic", -- Legs - Dathea, Ascended
        [200418] = "t_r_1200_15360_2482;t_tgv;t_ic", -- Hands - Sennarath, the Cold Breath
        -- Priest
        [200327] = "t_r_1200_15360_2499;t_tgv;t_ic", -- Head - Raszageth the Storm-Eater
        [200329] = "t_r_1200_15360_2493;t_tgv;t_ic", -- Shoulder - Broodkeeper Diurna
        [200324] = "t_r_1200_15360_2491;t_tgv;t_ic", -- Chest - Kurog Grimtotem
        [200326] = "t_r_1200_15360_2502;t_tgv;t_ic", -- Legs - Dathea, Ascended
        [200328] = "t_r_1200_15360_2482;t_tgv;t_ic", -- Hands - Sennarath, the Cold Breath
        -- Shaman
        [200399] = "t_r_1200_15360_2499;t_tgv;t_ic", -- Head - Raszageth the Storm-Eater
        [200401] = "t_r_1200_15360_2493;t_tgv;t_ic", -- Shoulder - Broodkeeper Diurna
        [200396] = "t_r_1200_15360_2491;t_tgv;t_ic", -- Chest - Kurog Grimtotem
        [200398] = "t_r_1200_15360_2502;t_tgv;t_ic", -- Legs - Dathea, Ascended
        [200400] = "t_r_1200_15360_2482;t_tgv;t_ic", -- Hands - Sennarath, the Cold Breath
        -- Monk
        [200363] = "t_r_1200_15360_2499;t_tgv;t_ic", -- Head - Raszageth the Storm-Eater
        [200365] = "t_r_1200_15360_2493;t_tgv;t_ic", -- Shoulder - Broodkeeper Diurna
        [200360] = "t_r_1200_15360_2491;t_tgv;t_ic", -- Chest - Kurog Grimtotem
        [200362] = "t_r_1200_15360_2502;t_tgv;t_ic", -- Legs - Dathea, Ascended
        [200364] = "t_r_1200_15360_2482;t_tgv;t_ic", -- Hands - Sennarath, the Cold Breath
        -- Rogue
        [200372] = "t_r_1200_15360_2499;t_tgv;t_ic", -- Head - Raszageth the Storm-Eater
        [200374] = "t_r_1200_15360_2493;t_tgv;t_ic", -- Shoulder - Broodkeeper Diurna
        [200369] = "t_r_1200_15360_2491;t_tgv;t_ic", -- Chest - Kurog Grimtotem
        [200371] = "t_r_1200_15360_2502;t_tgv;t_ic", -- Legs - Dathea, Ascended
        [200373] = "t_r_1200_15360_2482;t_tgv;t_ic", -- Hands - Sennarath, the Cold Breath
        -- Warrior
        [200426] = "t_r_1200_15360_2499;t_tgv;t_ic", -- Head - Raszageth the Storm-Eater
        [200428] = "t_r_1200_15360_2493;t_tgv;t_ic", -- Shoulder - Broodkeeper Diurna
        [200423] = "t_r_1200_15360_2491;t_tgv;t_ic", -- Chest - Kurog Grimtotem
        [200425] = "t_r_1200_15360_2502;t_tgv;t_ic", -- Legs - Dathea, Ascended
        [200427] = "t_r_1200_15360_2482;t_tgv;t_ic", -- Hands - Sennarath, the Cold Breath
        -- Evoker
        [200381] = "t_r_1200_15360_2499;t_tgv;t_ic", -- Head - Raszageth the Storm-Eater
        [200383] = "t_r_1200_15360_2493;t_tgv;t_ic", -- Shoulder - Broodkeeper Diurna
        [200378] = "t_r_1200_15360_2491;t_tgv;t_ic", -- Chest - Kurog Grimtotem
        [200380] = "t_r_1200_15360_2502;t_tgv;t_ic", -- Legs - Dathea, Ascended
        [200382] = "t_r_1200_15360_2482;t_tgv;t_ic", -- Hands - Sennarath, the Cold Breath

        -- Vault of the Incarnates : Tier set off pieces
        -- Death Knight
        [200413] = "ic", -- Back
        [200412] = "ic", -- Wrist
        [200411] = "ic", -- Waist
        [200406] = "ic", -- Feet
        -- Demon Hunter
        [200350] = "ic", -- Back
        [200349] = "ic", -- Wrist
        [200348] = "ic", -- Waist
        [200343] = "ic", -- Feet
        -- Warlock
        [200341] = "ic", -- Back
        [200340] = "ic", -- Wrist
        [200339] = "ic", -- Waist
        [200334] = "ic", -- Feet
        -- Druid
        [200359] = "ic", -- Back
        [200358] = "ic", -- Wrist
        [200357] = "ic", -- Waist
        [200352] = "ic", -- Feet
        -- Hunter
        [200395] = "ic", -- Back
        [200394] = "ic", -- Wrist
        [200393] = "ic", -- Waist
        [200388] = "ic", -- Feet
        -- Mage
        [200323] = "ic", -- Back
        [200322] = "ic", -- Wrist
        [200321] = "ic", -- Waist
        [200316] = "ic", -- Feet
        -- Paladin
        [200422] = "ic", -- Back
        [200421] = "ic", -- Wrist
        [200420] = "ic", -- Waist
        [200415] = "ic", -- Feet
        -- Priest
        [200332] = "ic", -- Back
        [200331] = "ic", -- Wrist
        [200330] = "ic", -- Waist
        [200325] = "ic", -- Feet
        -- Shaman
        [200404] = "ic", -- Back
        [200403] = "ic", -- Wrist
        [200402] = "ic", -- Waist
        [200397] = "ic", -- Feet
        -- Monk
        [200368] = "ic", -- Back
        [200367] = "ic", -- Wrist
        [200366] = "ic", -- Waist
        [200361] = "ic", -- Feet
        -- Rogue
        [200377] = "ic", -- Back
        [200376] = "ic", -- Wrist
        [200375] = "ic", -- Waist
        [200370] = "ic", -- Feet
        -- Warrior
        [200431] = "ic", -- Back
        [200430] = "ic", -- Wrist
        [200429] = "ic", -- Waist
        [200424] = "ic", -- Feet
        -- Evoker
        [200386] = "ic", -- Back
        [200385] = "ic", -- Wrist
        [200384] = "ic", -- Waist
        [200379] = "ic", -- Feet

        -- Aberrus, the Shadowed Crucible : Trash Loot
        [204430] = "r_1208_15360_0",
        [204422] = "r_1208_15360_0",
        [204411] = "r_1208_15360_0",
        [204423] = "r_1208_15360_0",
        [204429] = "r_1208_15360_0",
        [204414] = "r_1208_15360_0",
        [204410] = "r_1208_15360_0",
        [204415] = "r_1208_15360_0",

        -- Aberrus, the Shadowed Crucible : Tier set main pieces
        -- Death Knight
        [202461] = "t_r_1208_15360_2527;t_tgv;t_ic", -- Head - Magmorax
        [202459] = "t_r_1208_15360_2523;t_tgv;t_ic", -- Shoulder - Neltharion
        [202464] = "t_r_1208_15360_2532;t_tgv;t_ic", -- Chest - Zskarn
        [202460] = "t_r_1208_15360_2525;t_tgv;t_ic", -- Legs - Rashok
        [202462] = "t_r_1208_15360_2530;t_tgv;t_ic", -- Hands - The Forgotten Experiments
        -- Demon Hunter
        [202524] = "t_r_1208_15360_2527;t_tgv;t_ic", -- Head - Magmorax
        [202522] = "t_r_1208_15360_2523;t_tgv;t_ic", -- Shoulder - Neltharion
        [202527] = "t_r_1208_15360_2532;t_tgv;t_ic", -- Chest - Zskarn
        [202523] = "t_r_1208_15360_2525;t_tgv;t_ic", -- Legs - Rashok
        [202525] = "t_r_1208_15360_2530;t_tgv;t_ic", -- Hands - The Forgotten Experiments
        -- Warlock
        [202533] = "t_r_1208_15360_2527;t_tgv;t_ic", -- Head - Magmorax
        [202531] = "t_r_1208_15360_2523;t_tgv;t_ic", -- Shoulder - Neltharion
        [202536] = "t_r_1208_15360_2532;t_tgv;t_ic", -- Chest - Zskarn
        [202532] = "t_r_1208_15360_2525;t_tgv;t_ic", -- Legs - Rashok
        [202534] = "t_r_1208_15360_2530;t_tgv;t_ic", -- Hands - The Forgotten Experiments
        -- Druid
        [202515] = "t_r_1208_15360_2527;t_tgv;t_ic", -- Head - Magmorax
        [202513] = "t_r_1208_15360_2523;t_tgv;t_ic", -- Shoulder - Neltharion
        [202518] = "t_r_1208_15360_2532;t_tgv;t_ic", -- Chest - Zskarn
        [202514] = "t_r_1208_15360_2525;t_tgv;t_ic", -- Legs - Rashok
        [202516] = "t_r_1208_15360_2530;t_tgv;t_ic", -- Hands - The Forgotten Experiments
        -- Hunter
        [202479] = "t_r_1208_15360_2527;t_tgv;t_ic", -- Head - Magmorax
        [202477] = "t_r_1208_15360_2523;t_tgv;t_ic", -- Shoulder - Neltharion
        [202482] = "t_r_1208_15360_2532;t_tgv;t_ic", -- Chest - Zskarn
        [202478] = "t_r_1208_15360_2525;t_tgv;t_ic", -- Legs - Rashok
        [202480] = "t_r_1208_15360_2530;t_tgv;t_ic", -- Hands - The Forgotten Experiments
        -- Mage
        [202551] = "t_r_1208_15360_2527;t_tgv;t_ic", -- Head - Magmorax
        [202549] = "t_r_1208_15360_2523;t_tgv;t_ic", -- Shoulder - Neltharion
        [202554] = "t_r_1208_15360_2532;t_tgv;t_ic", -- Chest - Zskarn
        [202550] = "t_r_1208_15360_2525;t_tgv;t_ic", -- Legs - Rashok
        [202552] = "t_r_1208_15360_2530;t_tgv;t_ic", -- Hands - The Forgotten Experiments
        -- Paladin
        [202452] = "t_r_1208_15360_2527;t_tgv;t_ic", -- Head - Magmorax
        [202450] = "t_r_1208_15360_2523;t_tgv;t_ic", -- Shoulder - Neltharion
        [202455] = "t_r_1208_15360_2532;t_tgv;t_ic", -- Chest - Zskarn
        [202451] = "t_r_1208_15360_2525;t_tgv;t_ic", -- Legs - Rashok
        [202453] = "t_r_1208_15360_2530;t_tgv;t_ic", -- Hands - The Forgotten Experiments
        -- Priest
        [202542] = "t_r_1208_15360_2527;t_tgv;t_ic", -- Head - Magmorax
        [202540] = "t_r_1208_15360_2523;t_tgv;t_ic", -- Shoulder - Neltharion
        [202545] = "t_r_1208_15360_2532;t_tgv;t_ic", -- Chest - Zskarn
        [202541] = "t_r_1208_15360_2525;t_tgv;t_ic", -- Legs - Rashok
        [202543] = "t_r_1208_15360_2530;t_tgv;t_ic", -- Hands - The Forgotten Experiments
        -- Shaman
        [202470] = "t_r_1208_15360_2527;t_tgv;t_ic", -- Head - Magmorax
        [202468] = "t_r_1208_15360_2523;t_tgv;t_ic", -- Shoulder - Neltharion
        [202473] = "t_r_1208_15360_2532;t_tgv;t_ic", -- Chest - Zskarn
        [202469] = "t_r_1208_15360_2525;t_tgv;t_ic", -- Legs - Rashok
        [202471] = "t_r_1208_15360_2530;t_tgv;t_ic", -- Hands - The Forgotten Experiments
        -- Monk
        [202506] = "t_r_1208_15360_2527;t_tgv;t_ic", -- Head - Magmorax
        [202504] = "t_r_1208_15360_2523;t_tgv;t_ic", -- Shoulder - Neltharion
        [202509] = "t_r_1208_15360_2532;t_tgv;t_ic", -- Chest - Zskarn
        [202505] = "t_r_1208_15360_2525;t_tgv;t_ic", -- Legs - Rashok
        [202507] = "t_r_1208_15360_2530;t_tgv;t_ic", -- Hands - The Forgotten Experiments
        -- Rogue
        [202497] = "t_r_1208_15360_2527;t_tgv;t_ic", -- Head - Magmorax
        [202495] = "t_r_1208_15360_2523;t_tgv;t_ic", -- Shoulder - Neltharion
        [202500] = "t_r_1208_15360_2532;t_tgv;t_ic", -- Chest - Zskarn
        [202496] = "t_r_1208_15360_2525;t_tgv;t_ic", -- Legs - Rashok
        [202498] = "t_r_1208_15360_2530;t_tgv;t_ic", -- Hands - The Forgotten Experiments
        -- Warrior
        [202443] = "t_r_1208_15360_2527;t_tgv;t_ic", -- Head - Magmorax
        [202441] = "t_r_1208_15360_2523;t_tgv;t_ic", -- Shoulder - Neltharion
        [202446] = "t_r_1208_15360_2532;t_tgv;t_ic", -- Chest - Zskarn
        [202442] = "t_r_1208_15360_2525;t_tgv;t_ic", -- Legs - Rashok
        [202444] = "t_r_1208_15360_2530;t_tgv;t_ic", -- Hands - The Forgotten Experiments
        -- Evoker
        [202488] = "t_r_1208_15360_2527;t_tgv;t_ic", -- Head - Magmorax
        [202486] = "t_r_1208_15360_2523;t_tgv;t_ic", -- Shoulder - Neltharion
        [202491] = "t_r_1208_15360_2532;t_tgv;t_ic", -- Chest - Zskarn
        [202487] = "t_r_1208_15360_2525;t_tgv;t_ic", -- Legs - Rashok
        [202489] = "t_r_1208_15360_2530;t_tgv;t_ic", -- Hands - The Forgotten Experiments

        -- Aberrus, the Shadowed Crucible : Tier set off pieces
        -- Death Knight
        [202456] = "ic", -- Back
        [202457] = "ic", -- Wrist
        [202458] = "ic", -- Waist
        [202463] = "ic", -- Feet
        -- Demon Hunter
        [202519] = "ic", -- Back
        [202520] = "ic", -- Wrist
        [202521] = "ic", -- Waist
        [202526] = "ic", -- Feet
        -- Warlock
        [202528] = "ic", -- Back
        [202529] = "ic", -- Wrist
        [202530] = "ic", -- Waist
        [202535] = "ic", -- Feet
        -- Druid
        [202510] = "ic", -- Back
        [202511] = "ic", -- Wrist
        [202512] = "ic", -- Waist
        [202517] = "ic", -- Feet
        -- Hunter
        [202474] = "ic", -- Back
        [202475] = "ic", -- Wrist
        [202476] = "ic", -- Waist
        [202481] = "ic", -- Feet
        -- Mage
        [202546] = "ic", -- Back
        [202547] = "ic", -- Wrist
        [202548] = "ic", -- Waist
        [202553] = "ic", -- Feet
        -- Paladin
        [202447] = "ic", -- Back
        [202448] = "ic", -- Wrist
        [202449] = "ic", -- Waist
        [202454] = "ic", -- Feet
        -- Priest
        [202537] = "ic", -- Back
        [202538] = "ic", -- Wrist
        [202539] = "ic", -- Waist
        [202544] = "ic", -- Feet
        -- Shaman
        [202465] = "ic", -- Back
        [202466] = "ic", -- Wrist
        [202467] = "ic", -- Waist
        [202472] = "ic", -- Feet
        -- Monk
        [202501] = "ic", -- Back
        [202502] = "ic", -- Wrist
        [202503] = "ic", -- Waist
        [202508] = "ic", -- Feet
        -- Rogue
        [202492] = "ic", -- Back
        [202493] = "ic", -- Wrist
        [202494] = "ic", -- Waist
        [202499] = "ic", -- Feet
        -- Warrior
        [202438] = "ic", -- Back
        [202439] = "ic", -- Wrist
        [202440] = "ic", -- Waist
        [202445] = "ic", -- Feet
        -- Evoker
        [202483] = "ic", -- Back
        [202484] = "ic", -- Wrist
        [202485] = "ic", -- Waist
        [202490] = "ic", -- Feet

        -- Amirdrassil, the Dream's Hope : Tier set main pieces
        -- Death Knight
        [207200] = "t_r_1207_15360_2565;t_tgv;t_ic", -- Head - Tindral
        [207198] = "t_r_1207_15360_2563;t_tgv;t_ic", -- Shoulder - Smolderon
        [207203] = "t_r_1207_15360_2556;t_tgv;t_ic", -- Chest - Nymue
        [207199] = "t_r_1207_15360_2553;t_tgv;t_ic", -- Legs - Larodar
        [207201] = "t_r_1207_15360_2554;t_tgv;t_ic", -- Hands - Igira
        -- Demon Hunter
        [207263] = "t_r_1207_15360_2565;t_tgv;t_ic", -- Head - Tindral
        [207261] = "t_r_1207_15360_2563;t_tgv;t_ic", -- Shoulder - Smolderon
        [207266] = "t_r_1207_15360_2556;t_tgv;t_ic", -- Chest - Nymue
        [207262] = "t_r_1207_15360_2553;t_tgv;t_ic", -- Legs - Larodar
        [207264] = "t_r_1207_15360_2554;t_tgv;t_ic", -- Hands - Igira
        -- Warlock
        [207272] = "t_r_1207_15360_2565;t_tgv;t_ic", -- Head - Tindral
        [207270] = "t_r_1207_15360_2563;t_tgv;t_ic", -- Shoulder - Smolderon
        [207275] = "t_r_1207_15360_2556;t_tgv;t_ic", -- Chest - Nymue
        [207271] = "t_r_1207_15360_2553;t_tgv;t_ic", -- Legs - Larodar
        [207273] = "t_r_1207_15360_2554;t_tgv;t_ic", -- Hands - Igira
        -- Druid
        [207254] = "t_r_1207_15360_2565;t_tgv;t_ic", -- Head - Tindral
        [207252] = "t_r_1207_15360_2563;t_tgv;t_ic", -- Shoulder - Smolderon
        [207257] = "t_r_1207_15360_2556;t_tgv;t_ic", -- Chest - Nymue
        [207253] = "t_r_1207_15360_2553;t_tgv;t_ic", -- Legs - Larodar
        [207255] = "t_r_1207_15360_2554;t_tgv;t_ic", -- Hands - Igira
        -- Hunter
        [207218] = "t_r_1207_15360_2565;t_tgv;t_ic", -- Head - Tindral
        [207216] = "t_r_1207_15360_2563;t_tgv;t_ic", -- Shoulder - Smolderon
        [207221] = "t_r_1207_15360_2556;t_tgv;t_ic", -- Chest - Nymue
        [207217] = "t_r_1207_15360_2553;t_tgv;t_ic", -- Legs - Larodar
        [207219] = "t_r_1207_15360_2554;t_tgv;t_ic", -- Hands - Igira
        -- Mage
        [207290] = "t_r_1207_15360_2565;t_tgv;t_ic", -- Head - Tindral
        [207288] = "t_r_1207_15360_2563;t_tgv;t_ic", -- Shoulder - Smolderon
        [207293] = "t_r_1207_15360_2556;t_tgv;t_ic", -- Chest - Nymue
        [207289] = "t_r_1207_15360_2553;t_tgv;t_ic", -- Legs - Larodar
        [207291] = "t_r_1207_15360_2554;t_tgv;t_ic", -- Hands - Igira
        -- Paladin
        [207191] = "t_r_1207_15360_2565;t_tgv;t_ic", -- Head - Tindral
        [207189] = "t_r_1207_15360_2563;t_tgv;t_ic", -- Shoulder - Smolderon
        [207194] = "t_r_1207_15360_2556;t_tgv;t_ic", -- Chest - Nymue
        [207190] = "t_r_1207_15360_2553;t_tgv;t_ic", -- Legs - Larodar
        [207192] = "t_r_1207_15360_2554;t_tgv;t_ic", -- Hands - Igira
        -- Priest
        [207281] = "t_r_1207_15360_2565;t_tgv;t_ic", -- Head - Tindral
        [207279] = "t_r_1207_15360_2563;t_tgv;t_ic", -- Shoulder - Smolderon
        [207284] = "t_r_1207_15360_2556;t_tgv;t_ic", -- Chest - Nymue
        [207280] = "t_r_1207_15360_2553;t_tgv;t_ic", -- Legs - Larodar
        [207282] = "t_r_1207_15360_2554;t_tgv;t_ic", -- Hands - Igira
        -- Shaman
        [207209] = "t_r_1207_15360_2565;t_tgv;t_ic", -- Head - Tindral
        [207207] = "t_r_1207_15360_2563;t_tgv;t_ic", -- Shoulder - Smolderon
        [207212] = "t_r_1207_15360_2556;t_tgv;t_ic", -- Chest - Nymue
        [207208] = "t_r_1207_15360_2553;t_tgv;t_ic", -- Legs - Larodar
        [207210] = "t_r_1207_15360_2554;t_tgv;t_ic", -- Hands - Igira
        -- Monk
        [207245] = "t_r_1207_15360_2565;t_tgv;t_ic", -- Head - Tindral
        [207243] = "t_r_1207_15360_2563;t_tgv;t_ic", -- Shoulder - Smolderon
        [207248] = "t_r_1207_15360_2556;t_tgv;t_ic", -- Chest - Nymue
        [207244] = "t_r_1207_15360_2553;t_tgv;t_ic", -- Legs - Larodar
        [207246] = "t_r_1207_15360_2554;t_tgv;t_ic", -- Hands - Igira
        -- Rogue
        [207236] = "t_r_1207_15360_2565;t_tgv;t_ic", -- Head - Tindral
        [207234] = "t_r_1207_15360_2563;t_tgv;t_ic", -- Shoulder - Smolderon
        [207239] = "t_r_1207_15360_2556;t_tgv;t_ic", -- Chest - Nymue
        [207235] = "t_r_1207_15360_2553;t_tgv;t_ic", -- Legs - Larodar
        [207237] = "t_r_1207_15360_2554;t_tgv;t_ic", -- Hands - Igira
        -- Warrior
        [207182] = "t_r_1207_15360_2565;t_tgv;t_ic", -- Head - Tindral
        [207180] = "t_r_1207_15360_2563;t_tgv;t_ic", -- Shoulder - Smolderon
        [207185] = "t_r_1207_15360_2556;t_tgv;t_ic", -- Chest - Nymue
        [207181] = "t_r_1207_15360_2553;t_tgv;t_ic", -- Legs - Larodar
        [207183] = "t_r_1207_15360_2554;t_tgv;t_ic", -- Hands - Igira
        -- Evoker
        [207227] = "t_r_1207_15360_2565;t_tgv;t_ic", -- Head - Tindral
        [207225] = "t_r_1207_15360_2563;t_tgv;t_ic", -- Shoulder - Smolderon
        [207230] = "t_r_1207_15360_2556;t_tgv;t_ic", -- Chest - Nymue
        [207226] = "t_r_1207_15360_2553;t_tgv;t_ic", -- Legs - Larodar
        [207228] = "t_r_1207_15360_2554;t_tgv;t_ic", -- Hands - Igira



        -- Amirdrassil, the Dream's Hope : Tier set off pieces
        -- Death Knight
        [207195] = "ic", -- Back
        [207196] = "ic", -- Wrist
        [207197] = "ic", -- Waist
        [207202] = "ic", -- Feet
        -- Demon Hunter
        [207258] = "ic", -- Back
        [207259] = "ic", -- Wrist
        [207260] = "ic", -- Waist
        [207265] = "ic", -- Feet
        -- Warlock
        [207267] = "ic", -- Back
        [207268] = "ic", -- Wrist
        [207269] = "ic", -- Waist
        [207274] = "ic", -- Feet
        -- Druid
        [207249] = "ic", -- Back
        [207250] = "ic", -- Wrist
        [207251] = "ic", -- Waist
        [207256] = "ic", -- Feet
        -- Hunter
        [207213] = "ic", -- Back
        [207214] = "ic", -- Wrist
        [207215] = "ic", -- Waist
        [207220] = "ic", -- Feet
        -- Mage
        [207285] = "ic", -- Back
        [207286] = "ic", -- Wrist
        [207287] = "ic", -- Waist
        [207292] = "ic", -- Feet
        -- Paladin
        [207186] = "ic", -- Back
        [207187] = "ic", -- Wrist
        [207188] = "ic", -- Waist
        [207193] = "ic", -- Feet
        -- Priest
        [207276] = "ic", -- Back
        [207277] = "ic", -- Wrist
        [207278] = "ic", -- Waist
        [207283] = "ic", -- Feet
        -- Shaman
        [207204] = "ic", -- Back
        [207205] = "ic", -- Wrist
        [207206] = "ic", -- Waist
        [207211] = "ic", -- Feet
        -- Monk
        [207240] = "ic", -- Back
        [207241] = "ic", -- Wrist
        [207242] = "ic", -- Waist
        [207247] = "ic", -- Feet
        -- Rogue
        [207231] = "ic", -- Back
        [207232] = "ic", -- Wrist
        [207233] = "ic", -- Waist
        [207238] = "ic", -- Feet
        -- Warrior
        [207176] = "ic", -- Back
        [207177] = "ic", -- Wrist
        [207179] = "ic", -- Waist
        [207184] = "ic", -- Feet
        -- Evoker
        [207222] = "ic", -- Back
        [207223] = "ic", -- Wrist
        [207224] = "ic", -- Waist
        [207229] = "ic", -- Feet

        -- Amirdrassil, the Dream's Hope : Trash Loot
        [208430] = "r_1207_15360_0",
        [208431] = "r_1207_15360_0",
        [208432] = "r_1207_15360_0",
        [208420] = "r_1207_15360_0",
        [208428] = "r_1207_15360_0",
        [208434] = "r_1207_15360_0",
        [208427] = "r_1207_15360_0",
        [208426] = "r_1207_15360_0",
        [208442] = "r_1207_15360_0",

        -- DragonFlight Season 4 : Tier set main pieces
        -- Death Knight
        [217223] = "t_r_1200_15360_2499;t_r_1208_15360_2527;t_r_1207_15360_2565;t_tgv;t_ic", -- Head
        [217225] = "t_r_1200_15360_2493;t_r_1208_15360_2523;t_r_1207_15360_2563;t_tgv;t_ic", -- Shoulder
        [217221] = "t_r_1200_15360_2491;t_r_1208_15360_2532;t_r_1207_15360_2556;t_tgv;t_ic", -- Chest
        [217224] = "t_r_1200_15360_2502;t_r_1208_15360_2525;t_r_1207_15360_2553;t_tgv;t_ic", -- Legs
        [217222] = "t_r_1200_15360_2482;t_r_1208_15360_2530;t_r_1207_15360_2554;t_tgv;t_ic", -- Hands
        -- Demon Hunter
        [217228] = "t_r_1200_15360_2499;t_r_1208_15360_2527;t_r_1207_15360_2565;t_tgv;t_ic", -- Head
        [217230] = "t_r_1200_15360_2493;t_r_1208_15360_2523;t_r_1207_15360_2563;t_tgv;t_ic", -- Shoulder
        [217226] = "t_r_1200_15360_2491;t_r_1208_15360_2532;t_r_1207_15360_2556;t_tgv;t_ic", -- Chest
        [217229] = "t_r_1200_15360_2502;t_r_1208_15360_2525;t_r_1207_15360_2553;t_tgv;t_ic", -- Legs
        [217227] = "t_r_1200_15360_2482;t_r_1208_15360_2530;t_r_1207_15360_2554;t_tgv;t_ic", -- Hands
        -- Warlock
        [217212] = "t_r_1200_15360_2499;t_r_1208_15360_2527;t_r_1207_15360_2565;t_tgv;t_ic", -- Head
        [217214] = "t_r_1200_15360_2493;t_r_1208_15360_2523;t_r_1207_15360_2563;t_tgv;t_ic", -- Shoulder
        [217215] = "t_r_1200_15360_2491;t_r_1208_15360_2532;t_r_1207_15360_2556;t_tgv;t_ic", -- Chest
        [217213] = "t_r_1200_15360_2502;t_r_1208_15360_2525;t_r_1207_15360_2553;t_tgv;t_ic", -- Legs
        [217211] = "t_r_1200_15360_2482;t_r_1208_15360_2530;t_r_1207_15360_2554;t_tgv;t_ic", -- Hands
        -- Druid
        [217193] = "t_r_1200_15360_2499;t_r_1208_15360_2527;t_r_1207_15360_2565;t_tgv;t_ic", -- Head
        [217195] = "t_r_1200_15360_2493;t_r_1208_15360_2523;t_r_1207_15360_2563;t_tgv;t_ic", -- Shoulder
        [217191] = "t_r_1200_15360_2491;t_r_1208_15360_2532;t_r_1207_15360_2556;t_tgv;t_ic", -- Chest
        [217194] = "t_r_1200_15360_2502;t_r_1208_15360_2525;t_r_1207_15360_2553;t_tgv;t_ic", -- Legs
        [217192] = "t_r_1200_15360_2482;t_r_1208_15360_2530;t_r_1207_15360_2554;t_tgv;t_ic", -- Hands
        -- Hunter
        [217183] = "t_r_1200_15360_2499;t_r_1208_15360_2527;t_r_1207_15360_2565;t_tgv;t_ic", -- Head
        [217185] = "t_r_1200_15360_2493;t_r_1208_15360_2523;t_r_1207_15360_2563;t_tgv;t_ic", -- Shoulder
        [217181] = "t_r_1200_15360_2491;t_r_1208_15360_2532;t_r_1207_15360_2556;t_tgv;t_ic", -- Chest
        [217184] = "t_r_1200_15360_2502;t_r_1208_15360_2525;t_r_1207_15360_2553;t_tgv;t_ic", -- Legs
        [217182] = "t_r_1200_15360_2482;t_r_1208_15360_2530;t_r_1207_15360_2554;t_tgv;t_ic", -- Hands
        -- Mage
        [217232] = "t_r_1200_15360_2499;t_r_1208_15360_2527;t_r_1207_15360_2565;t_tgv;t_ic", -- Head
        [217234] = "t_r_1200_15360_2493;t_r_1208_15360_2523;t_r_1207_15360_2563;t_tgv;t_ic", -- Shoulder
        [217235] = "t_r_1200_15360_2491;t_r_1208_15360_2532;t_r_1207_15360_2556;t_tgv;t_ic", -- Chest
        [217233] = "t_r_1200_15360_2502;t_r_1208_15360_2525;t_r_1207_15360_2553;t_tgv;t_ic", -- Legs
        [217231] = "t_r_1200_15360_2482;t_r_1208_15360_2530;t_r_1207_15360_2554;t_tgv;t_ic", -- Hands
        -- Paladin
        [217198] = "t_r_1200_15360_2499;t_r_1208_15360_2527;t_r_1207_15360_2565;t_tgv;t_ic", -- Head
        [217200] = "t_r_1200_15360_2493;t_r_1208_15360_2523;t_r_1207_15360_2563;t_tgv;t_ic", -- Shoulder
        [217196] = "t_r_1200_15360_2491;t_r_1208_15360_2532;t_r_1207_15360_2556;t_tgv;t_ic", -- Chest
        [217199] = "t_r_1200_15360_2502;t_r_1208_15360_2525;t_r_1207_15360_2553;t_tgv;t_ic", -- Legs
        [217197] = "t_r_1200_15360_2482;t_r_1208_15360_2530;t_r_1207_15360_2554;t_tgv;t_ic", -- Hands
        -- Priest
        [217202] = "t_r_1200_15360_2499;t_r_1208_15360_2527;t_r_1207_15360_2565;t_tgv;t_ic", -- Head
        [217204] = "t_r_1200_15360_2493;t_r_1208_15360_2523;t_r_1207_15360_2563;t_tgv;t_ic", -- Shoulder
        [217205] = "t_r_1200_15360_2491;t_r_1208_15360_2532;t_r_1207_15360_2556;t_tgv;t_ic", -- Chest
        [217203] = "t_r_1200_15360_2502;t_r_1208_15360_2525;t_r_1207_15360_2553;t_tgv;t_ic", -- Legs
        [217201] = "t_r_1200_15360_2482;t_r_1208_15360_2530;t_r_1207_15360_2554;t_tgv;t_ic", -- Hands
        -- Shaman
        [217238] = "t_r_1200_15360_2499;t_r_1208_15360_2527;t_r_1207_15360_2565;t_tgv;t_ic", -- Head
        [217240] = "t_r_1200_15360_2493;t_r_1208_15360_2523;t_r_1207_15360_2563;t_tgv;t_ic", -- Shoulder
        [217236] = "t_r_1200_15360_2491;t_r_1208_15360_2532;t_r_1207_15360_2556;t_tgv;t_ic", -- Chest
        [217239] = "t_r_1200_15360_2502;t_r_1208_15360_2525;t_r_1207_15360_2553;t_tgv;t_ic", -- Legs
        [217237] = "t_r_1200_15360_2482;t_r_1208_15360_2530;t_r_1207_15360_2554;t_tgv;t_ic", -- Hands
        -- Monk
        [217188] = "t_r_1200_15360_2499;t_r_1208_15360_2527;t_r_1207_15360_2565;t_tgv;t_ic", -- Head
        [217190] = "t_r_1200_15360_2493;t_r_1208_15360_2523;t_r_1207_15360_2563;t_tgv;t_ic", -- Shoulder
        [217186] = "t_r_1200_15360_2491;t_r_1208_15360_2532;t_r_1207_15360_2556;t_tgv;t_ic", -- Chest
        [217189] = "t_r_1200_15360_2502;t_r_1208_15360_2525;t_r_1207_15360_2553;t_tgv;t_ic", -- Legs
        [217187] = "t_r_1200_15360_2482;t_r_1208_15360_2530;t_r_1207_15360_2554;t_tgv;t_ic", -- Hands
        -- Rogue
        [217208] = "t_r_1200_15360_2499;t_r_1208_15360_2527;t_r_1207_15360_2565;t_tgv;t_ic", -- Head
        [217210] = "t_r_1200_15360_2493;t_r_1208_15360_2523;t_r_1207_15360_2563;t_tgv;t_ic", -- Shoulder
        [217206] = "t_r_1200_15360_2491;t_r_1208_15360_2532;t_r_1207_15360_2556;t_tgv;t_ic", -- Chest
        [217209] = "t_r_1200_15360_2502;t_r_1208_15360_2525;t_r_1207_15360_2553;t_tgv;t_ic", -- Legs
        [217207] = "t_r_1200_15360_2482;t_r_1208_15360_2530;t_r_1207_15360_2554;t_tgv;t_ic", -- Hands
        -- Warrior
        [217218] = "t_r_1200_15360_2499;t_r_1208_15360_2527;t_r_1207_15360_2565;t_tgv;t_ic", -- Head
        [217220] = "t_r_1200_15360_2493;t_r_1208_15360_2523;t_r_1207_15360_2563;t_tgv;t_ic", -- Shoulder
        [217216] = "t_r_1200_15360_2491;t_r_1208_15360_2532;t_r_1207_15360_2556;t_tgv;t_ic", -- Chest
        [217219] = "t_r_1200_15360_2502;t_r_1208_15360_2525;t_r_1207_15360_2553;t_tgv;t_ic", -- Legs
        [217217] = "t_r_1200_15360_2482;t_r_1208_15360_2530;t_r_1207_15360_2554;t_tgv;t_ic", -- Hands
        -- Evoker
        [217178] = "t_r_1200_15360_2499;t_r_1208_15360_2527;t_r_1207_15360_2565;t_tgv;t_ic", -- Head
        [217180] = "t_r_1200_15360_2493;t_r_1208_15360_2523;t_r_1207_15360_2563;t_tgv;t_ic", -- Shoulder
        [217176] = "t_r_1200_15360_2491;t_r_1208_15360_2532;t_r_1207_15360_2556;t_tgv;t_ic", -- Chest
        [217179] = "t_r_1200_15360_2502;t_r_1208_15360_2525;t_r_1207_15360_2553;t_tgv;t_ic", -- Legs
        [217177] = "t_r_1200_15360_2482;t_r_1208_15360_2530;t_r_1207_15360_2554;t_tgv;t_ic", -- Hands

    }
}
