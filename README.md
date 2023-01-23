# Announcement
**Due to the withdrawn of Blizzard games from Mainland China, I couldn't keep maintaining this project during this period. I'll be back working on this project as soon as a new deal is struck between Activision and a Chinese proxy company**

# InspectEquip
InspectEquip is a WoW addon which could summarize and show a player's gear info based on item drop sources.

Use command `/inspectequip` in game to open the configuration panel.

## Supported Game Version
Only guaranteed to work in **Retail WoW**.

Notes: I don't play any Classic versions of WoW and I don't have any interest or intention to make this addon work in those versions.

## Credits
This addon is a continuation of [InspectEquip](https://www.curseforge.com/wow/addons/inspect-equip) and was created when the original project lacked maintenance around year 2015. Thanks to the original authors and contributors for all the work they put into the original addon.

To my knowledge, there's another fork of this addon that's been actively maintained. Choose to your liking!

## Bugs & Suggestions
I've been posting updates on the Chinese forum NGA since Nov 2015. You can provide feedback on this [NGA page](https://bbs.nga.cn/read.php?tid=8749947) if you want.

Also, feel free to open up an [issue](https://github.com/Nukme/InspectEquip/issues) here on Github.

## Major Updates and Fixes
- Update item level system
    - Revise the formula to calculate average-item-level to make it the same as the one shown in character panel.
        - Fixes for off-piece artifact item level.
        - Fixes for dual-wielding two-handed weapons.
    - Use API `GetDetailedItemLevelInfo()` to retrieve item level info instead of functions provided by `LibItemUpgradeInfo-1.0`
- Update item categories system
    - Add `Legendary` category
    - Add `Artifact` category
    - Add `Heirloom` category
    - Add `PVP Gear` category
    - Add `Class Tier Set` category
    - `Unknown` category always at bottom
- Update item source system
    - Optimize Encounter Journal Scanning procedure
        - Prevent the validation process from causing freezes and errors to the game
        - Visualize the validation process
        - Reduce scan cycles
        - Change method to deactivate EJ during scanning to prevent tainting
        - Fix lua errors due to EJ API changes
    - Revise source indexing system
        - Use Instance ID to index instances
        - Use Encounter ID to index bosses
        - Change binary formats for restoring instance difficulties
    - Remove old item source info from Vendor/Quest/Crafting
    - Change text format for item source info to save space
    - Add raid trash loots source info since Legion
    - Add dungeon hidden items source info since Legion
    - Add some quest/vendor items source info since Legion
        - Nighthold necklace
        - Castle Nathria weapons
        - etc.
    - Add `PVP Gear` source info since BFA season 1
    - Add source info for all tier set pieces (Raid Boss/The Great Vault/Creation Catalyst) in Shadowlands S3
    - Fixes for discrepancy between EJ and actual in-game item ids.
- Update enchantment-detection system
    - Update valid slots according to current game expansion
    - Distinguish between main-hand and off-hand pieces
    - Detect specializations for strength/agility/intellect enchantments
- Refactor Addon
    - Rewrite the structure of the addon
    - Rewrite the database module
- UI Updates
    - Fix and restore gear info frame border style due to `SetBackDrop()` API changes
    - Fix the tainting which prevents player from inspecting others while in combat
    - Fix for 10.0.2 Tooltip API change
    - Workaroudn unstable EJ API

