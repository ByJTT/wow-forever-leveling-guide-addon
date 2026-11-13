local _, ns = ...

-- Original open route scaffolds (Alliance) for ForeverLevelingGuide by ByJTT.
-- Clean-room, open, and extensible: structured 1-60 guidance skeletons intended for
-- in-game verification and expansion on WoW Forever (quest IDs/mapIDs/coords may differ).
-- Contributions welcome: https://github.com/ByJTT/wow-forever-leveling-guide-addon

ns:RegisterGuide("alliance_10_20_westfall_loch_modan_darkshore_scaffold", {
    title = "Alliance 10-20: Westfall / Loch Modan / Darkshore (Scaffold)",
    faction = "Alliance",
    minLevel = 10,
    maxLevel = 20,
    scaffold = true,
    steps = {
        { type = "note", title = "Scaffold route (WIP, original)", zone = "Westfall", note = "Structured 10-20 Alliance skeleton. Verify quest availability, turn-ins, and travel on WoW Forever; add quest IDs and coords as you confirm them." },
        { type = "note", title = "Prep", note = "Repair, restock food/water/ammo/reagents, clear bags, and pick up professions/secondary skills in Stormwind/Ironforge/Darnassus if needed." },
        { type = "train", title = "Class skills (10-12)", note = "Train new abilities when convenient. Check your class trainer before leaving a major hub." },
        { type = "note", title = "Choose a 10-20 hub", note = "Common Alliance paths: Westfall (Sentinel Hill), Loch Modan (Thelsamar), or Darkshore (Auberdine). Pick the most quest-dense path for your race/travel access and server pacing." },
        { type = "note", title = "Westfall option", zone = "Westfall", npc = "Sentinel Hill questgivers", note = "If in Westfall, work Sentinel Hill and surrounding farm/coast chains in circuits. Watch for Defias/elite or group steps and handle them when ready." },
        { type = "note", title = "Loch Modan option", zone = "Loch Modan", npc = "Thelsamar questgivers", note = "If in Loch Modan, complete Thelsamar and valley/lake circuits. Bundle kill/collect objectives to minimize travel." },
        { type = "note", title = "Darkshore option", zone = "Darkshore", npc = "Auberdine questgivers", note = "If in Darkshore, follow Auberdine-area chains along the coast and forest, batching objectives and turn-ins." },
        { type = "level", level = 12, title = "Reach level 12", note = "Checkpoint: train, vendor, and continue the strongest local quest chains." },
        { type = "train", title = "Class skills (14-16)", note = "Train key upgrades. Set hearth to your active quest hub when convenient." },
        { type = "note", title = "Dungeon/group options (optional)", note = "Deadmines or other groups can be strong XP/loot in this range if available. Use only if efficient for your server and party." },
        { type = "note", title = "Bridge toward 20", note = "As local quests run out, transition to Redridge, Duskwood borders, Ashenvale, or Wetlands breadcrumbs (as appropriate/verified on WoW Forever)." },
        { type = "level", level = 16, title = "Reach level 16", note = "Checkpoint: finish nearby chains, avoid long backtracking, and restock before moving hubs." },
        { type = "train", title = "Class skills (18-20)", note = "Train before pushing to new zones. Prepare for 20+ travel and group opportunities." },
        { type = "level", level = 20, title = "Reach level 20", note = "Milestone reached. Continue with /flg suggest or load the next Alliance 20-30 scaffold and refine steps with verified data." },
    },
})

ns:RegisterGuide("alliance_20_30_duskwood_redridge_wetlands_scaffold", {
    title = "Alliance 20-30: Duskwood / Redridge / Wetlands (Scaffold)",
    faction = "Alliance",
    minLevel = 20,
    maxLevel = 30,
    scaffold = true,
    steps = {
        { type = "note", title = "Scaffold route (WIP, original)", zone = "Duskwood", note = "Structured 20-30 Alliance skeleton. Validate hub order, quest chains, and travel routes on WoW Forever; add verified quest IDs/coords." },
        { type = "note", title = "Choose your 20+ path", note = "Common paths: Redridge Mountains, Duskwood, Wetlands, and Ashenvale/Darkshore leftovers. Pick the densest, safest chains for your level and group access." },
        { type = "note", title = "Redridge Mountains (Lakeshire)", zone = "Redridge Mountains", npc = "Lakeshire questgivers", note = "If in Redridge, work Lakeshire and surrounding valleys/lakes. Handle gnoll/orc chains in efficient loops." },
        { type = "level", level = 22, title = "Reach level 22", note = "Train, vendor, and batch turn-ins before changing subzones." },
        { type = "note", title = "Duskwood (Darkshire)", zone = "Duskwood", npc = "Darkshire questgivers", note = "If in Duskwood, establish Darkshire as hub and complete road/town/forest circuits. Watch for higher-level or elite threats; group when needed." },
        { type = "train", title = "Class skills (24)", note = "Train major upgrades. Update food/water and repair." },
        { type = "note", title = "Wetlands (Menethil Harbor)", zone = "Wetlands", note = "Wetlands can fit mid 20s depending on path. Use Menethil Harbor as a hub and combine marsh/coast objectives to reduce travel." },
        { type = "note", title = "Dungeon/group options (optional)", note = "Blackfathom Deeps, Shadowfang Keep, Stockade, or other groups can supplement XP/loot if efficient on your server." },
        { type = "level", level = 26, title = "Reach level 26", note = "Midpoint: reassess zone choice (Duskwood/Redridge/Wetlands/Ashenvale) based on remaining quest density." },
        { type = "note", title = "Late 20s circuits", note = "Finish strong chains and transition toward Duskwood/Arathi/Ashenvale/STV breadcrumbs as appropriate. Avoid long travel for low-value turn-ins." },
        { type = "train", title = "Class skills (28)", note = "Train and restock before final 30 push." },
        { type = "level", level = 30, title = "Reach level 30", note = "Milestone reached. Prepare for 30-40 zones (Stranglethorn, Arathi, Desolace, etc.). Continue with /flg suggest." },
    },
})

ns:RegisterGuide("alliance_30_40_stranglethorn_arathi_desolace_scaffold", {
    title = "Alliance 30-40: Stranglethorn / Arathi / Desolace (Scaffold)",
    faction = "Alliance",
    minLevel = 30,
    maxLevel = 40,
    scaffold = true,
    steps = {
        { type = "note", title = "Scaffold route (WIP, original)", zone = "Stranglethorn Vale", note = "Structured 30-40 Alliance skeleton. Verify quest hubs, chains, and travel paths on WoW Forever; add quest IDs/coords for your route." },
        { type = "note", title = "Plan your 30s route", note = "Common options: Stranglethorn Vale (Rebel Camp/Booty Bay area quests), Arathi Highlands, Desolace, Hillsbrad/Alterac, and Dustwallow/Thousand Needles-adjacent travel only if applicable to your server." },
        { type = "note", title = "Stranglethorn Vale (STV)", zone = "Stranglethorn Vale", note = "Work STV quest chains in batches (Nesingwary/wildlife, Rebel Camp/Bal'lal Ruins/etc. as available). Group objectives by sub-area to reduce long runs." },
        { type = "train", title = "Class skills (30-32)", note = "Train important upgrades and refresh consumables before long circuits." },
        { type = "note", title = "Arathi Highlands", zone = "Arathi Highlands", note = "Pick up Refuge Pointe and nearby quests if in level range. Combine kill/collect objectives and handle elite/group quests with parties when needed." },
        { type = "level", level = 33, title = "Reach level 33", note = "Checkpoint: turn in completed chains and pick up follow-ups that stay in-range." },
        { type = "note", title = "Desolace", zone = "Desolace", note = "Desolace can be efficient for mid 30s. Establish hub flow (Nijel's Point area), do circuits, and skip inefficient long-distance steps." },
        { type = "note", title = "Dungeon/group options (optional)", note = "Scarlet Monastery, Razorfen Downs, Gnomeregan (if still useful), or other dungeons can be strong XP/gear in this range if groups are available." },
        { type = "train", title = "Class skills (36)", note = "Train and repair. Re-evaluate zone choice for late 30s." },
        { type = "level", level = 36, title = "Reach level 36", note = "Late-30s checkpoint: focus on high-value chains leading into 40+ zones." },
        { type = "note", title = "Late 30s wrap-up", note = "Finish efficient STV/Arathi/Desolace quests, clear inventory, and plan transition to Badlands, Swamp of Sorrows, Tanaris/Feralas/Hinterlands as appropriate for WoW Forever." },
        { type = "level", level = 40, title = "Reach level 40", note = "Milestone reached. Continue with /flg suggest or load the next Alliance 40-50 scaffold." },
    },
})

ns:RegisterGuide("alliance_40_50_tanaris_feralas_hinterlands_scaffold", {
    title = "Alliance 40-50: Tanaris / Feralas / Hinterlands (Scaffold)",
    faction = "Alliance",
    minLevel = 40,
    maxLevel = 50,
    scaffold = true,
    steps = {
        { type = "note", title = "Scaffold route (WIP, original)", zone = "Tanaris", note = "Structured 40-50 Alliance skeleton. Verify hub availability, quest chains, and travel on WoW Forever; add quest IDs/coords." },
        { type = "note", title = "Plan your 40s route", note = "Common options: Tanaris, Feralas, Hinterlands, Stranglethorn leftovers, Badlands, and Searing Gorge entry later. Prioritize dense, in-level chains." },
        { type = "note", title = "Tanaris (Gadgetzan/Steamwheedle)", zone = "Tanaris", note = "Work Tanaris hubs and desert circuits. Bundle pirate/wastewander/basilisk/etc. objectives where possible to reduce travel." },
        { type = "train", title = "Class skills (40-42)", note = "Train upgrades and restock consumables/repair." },
        { type = "level", level = 42, title = "Reach level 42", note = "Checkpoint: keep quests yellow/green-efficient; drop overly grindy chains if better options exist." },
        { type = "note", title = "Feralas (Feathermoon Stronghold)", zone = "Feralas", note = "Progress Feathermoon and inland quest loops as available. Group objectives by region for efficiency." },
        { type = "note", title = "The Hinterlands (Aerie Peak)", zone = "The Hinterlands", note = "Aerie Peak and nearby chains can be strong in this range. Combine collection/kill objectives and handle elites with groups when needed." },
        { type = "note", title = "Dungeon/group options (optional)", note = "Zul'Farrak, Maraudon, Uldaman, or other dungeons can provide strong XP/loot bursts if groups are efficient." },
        { type = "train", title = "Class skills (46)", note = "Train and prepare for late-40s zones (Searing Gorge, Felwood, Azshara alternatives)." },
        { type = "level", level = 46, title = "Reach level 46", note = "Late-40s checkpoint: target chains that lead into 50+ zones." },
        { type = "note", title = "Searing Gorge / late 40s wrap-up", zone = "Searing Gorge", note = "Begin Searing Gorge or other high-40s hubs if unlocked/available. Finish best remaining Tanaris/Feralas/Hinterlands chains." },
        { type = "level", level = 50, title = "Reach level 50", note = "Milestone reached. Continue with /flg suggest or load the next Alliance 50-60 scaffold." },
    },
})

ns:RegisterGuide("alliance_50_60_ungoro_felwood_burning_steppes_scaffold", {
    title = "Alliance 50-60: Un'Goro / Felwood / WPL-EPL / Endgame (Scaffold)",
    faction = "Alliance",
    minLevel = 50,
    maxLevel = 60,
    scaffold = true,
    steps = {
        { type = "note", title = "Scaffold route (WIP, original)", zone = "Un'Goro Crater", note = "Structured 50-60 Alliance skeleton. Verify endgame hub/quest progression and travel on WoW Forever; add quest IDs/coords and tune for your server." },
        { type = "note", title = "Plan your 50s route", note = "Common options: Un'Goro Crater, Felwood, Winterspring, Western/Eastern Plaguelands, Burning Steppes, and Silithus near cap. Mix questing with dungeons as efficient." },
        { type = "note", title = "Un'Goro Crater", zone = "Un'Goro Crater", note = "Run crater circuits for collection/kill chains; many objectives overlap well. Set hearth/flight paths as available and batch turn-ins." },
        { type = "train", title = "Class skills (50-52)", note = "Train key abilities and ensure gear/consumables are up to date." },
        { type = "level", level = 52, title = "Reach level 52", note = "Checkpoint: rotate to Felwood/Burning Steppes/Winterspring or continue Un'Goro based on remaining quests." },
        { type = "note", title = "Felwood / Winterspring", zone = "Felwood", note = "Work Felwood hubs (e.g. Talonbranch area routes as applicable) and extend into Winterspring when level-appropriate. Prioritize efficient chains." },
        { type = "note", title = "Burning Steppes", zone = "Burning Steppes", note = "Complete Burning Steppes chains and dungeon-related breadcrumbs where useful (BRD/UBRS prep) if that fits your server progression." },
        { type = "note", title = "Western & Eastern Plaguelands", zone = "Western Plaguelands", note = "Plaguelands offer strong late leveling chains and group content (Chillwind/Caer Darrow areas as available). Follow hub circuits and handle elite areas with groups." },
        { type = "train", title = "Class skills (56-58)", note = "Final talent/skill upgrades before cap. Stock consumables for tougher zones/instances." },
        { type = "level", level = 56, title = "Reach level 56", note = "Late leveling: focus on EPL/Silithus/Winterspring high-value chains and efficient dungeon runs." },
        { type = "note", title = "Silithus / endgame prep (optional)", zone = "Silithus", note = "If available and in range, do Silithus intro/chains and prepare for endgame activities. Verify all requirements on WoW Forever." },
        { type = "note", title = "Dungeon/group options (optional)", note = "BRD, LBRS/UBRS, Strat/Scholo, or other endgame dungeons can complement or replace final questing levels depending on group availability." },
        { type = "level", level = 60, title = "Reach level 60", note = "Leveling complete. Refine this scaffold with verified quest IDs/coords for a polished, server-accurate route." },
    },
})
