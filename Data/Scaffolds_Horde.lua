local _, ns = ...

-- Original open route scaffolds (Horde) for ForeverLevelingGuide by ByJTT.
-- Clean-room, open, and extensible: structured 1-60 guidance skeletons intended for
-- in-game verification and expansion on WoW Forever (quest IDs/mapIDs/coords may differ).
-- Contributions welcome: https://github.com/ByJTT/wow-forever-leveling-guide-addon

ns:RegisterGuide("horde_10_20_barrens_stonetalon_scaffold", {
    title = "Horde 10-20: Barrens / Stonetalon (Scaffold)",
    faction = "Horde",
    minLevel = 10,
    maxLevel = 20,
    scaffold = true,
    steps = {
        { type = "note", title = "Scaffold route (WIP, original)", zone = "The Barrens", note = "Structured 10-20 Horde skeleton. Verify quest availability, turn-ins, and travel on WoW Forever; add quest IDs and coords as you confirm them." },
        { type = "note", title = "Prep", note = "Repair, restock food/water/ammo/reagents, clear bags, and pick up professions/secondary skills in a capital if needed." },
        { type = "train", title = "Class skills (10-12)", note = "Train new abilities when convenient. Check your class trainer before heading deep into quest hubs." },
        { type = "note", title = "Crossroads hub", zone = "The Barrens", npc = "Crossroads questgivers/innkeeper", note = "Make Crossroads your main hub. Pick up available local quests (fields, wildlife, raptors, quilboar, etc.) and follow logical clusters to reduce travel." },
        { type = "note", title = "Barrens circuit", zone = "The Barrens", note = "Work quest loops around Crossroads, Ratchet, and Camp Taurajo as appropriate. Turn in batches, then pick up follow-ups in the same area." },
        { type = "note", title = "Ratchet & Wailing Caverns (optional)", zone = "The Barrens", note = "Pick up and complete Ratchet-area quests if efficient. Wailing Caverns is an optional dungeon for quests/XP/gear - run if your group/server pacing makes it worthwhile." },
        { type = "level", level = 12, title = "Reach level 12", note = "Good checkpoint to refresh skills, vendor, and continue Barrens quest clusters." },
        { type = "note", title = "Camp Taurajo & south Barrens", zone = "The Barrens", note = "Progress southward chains when ready. Watch for elite/escort/group steps and skip/return later if needed." },
        { type = "train", title = "Class skills (14-16)", note = "Train key upgrades. Keep hearth set to a convenient hub (often Crossroads or Camp Taurajo)." },
        { type = "note", title = "Stonetalon Mountains breadcrumb", zone = "Stonetalon Mountains", note = "Take Stonetalon breadcrumb/follow-up quests when offered (often mid teens). Work Sun Rock Retreat and nearby hubs if efficient on WoW Forever." },
        { type = "note", title = "Stonetalon / Ashenvale alternates", note = "Depending on quest density and XP, split time between Stonetalon, Ashenvale (Splintertree-area breadcrumbs), and remaining Barrens quests. Choose the densest, safest chains." },
        { type = "level", level = 16, title = "Reach level 16", note = "Checkpoint: finish nearby chains, avoid long backtracking, and restock before moving hubs." },
        { type = "note", title = "Dungeon/group options (optional)", note = "Shadowfang Keep/Ragefire Chasm or other groups can supplement XP if available. Use only if efficient for your server and party." },
        { type = "note", title = "Wrap-up 18-20", note = "Complete efficient orange/yellow quests in Barrens/Stonetalon, turn in follow-ups, and prepare for 20+ zones (Hillsbrad/Ashenvale/Thousand Needles routes)." },
        { type = "train", title = "Class skills (18-20)", note = "Train before pushing to new zones. Consider mount/prep goals if relevant to your class/server rules." },
        { type = "level", level = 20, title = "Reach level 20", note = "Milestone reached. Continue with /flg suggest or load the next Horde 20-30 scaffold and refine steps with verified data." },
    },
})

ns:RegisterGuide("horde_20_30_ashenvale_thousand_needles_scaffold", {
    title = "Horde 20-30: Ashenvale / Hillsbrad / Thousand Needles (Scaffold)",
    faction = "Horde",
    minLevel = 20,
    maxLevel = 30,
    scaffold = true,
    steps = {
        { type = "note", title = "Scaffold route (WIP, original)", zone = "Ashenvale", note = "Structured 20-30 Horde skeleton. Validate hub order, quest chains, and travel routes on WoW Forever; add verified quest IDs/coords." },
        { type = "note", title = "Choose your 20+ path", note = "Common Horde paths: Ashenvale + Stonetalon leftovers, Hillsbrad Foothills, and Thousand Needles around mid/late 20s. Pick the most quest-dense path for your pace/server." },
        { type = "note", title = "Ashenvale (Splintertree Post)", zone = "Ashenvale", npc = "Splintertree questgivers", note = "Work Splintertree and nearby camps. Do efficient wildlife/camp chains and avoid overlong travel until flight/connectivity is set (where applicable)." },
        { type = "level", level = 22, title = "Reach level 22", note = "Train, vendor, and batch turn-ins before changing subzones." },
        { type = "note", title = "Hillsbrad Foothills (Tarren Mill)", zone = "Hillsbrad Foothills", note = "If taking Hillsbrad, establish Tarren Mill as a hub and complete local chains. Be mindful of contested areas and PvP risk on your realm." },
        { type = "train", title = "Class skills (24)", note = "Train major upgrades. Update food/water and repair." },
        { type = "note", title = "Dungeon/group options (optional)", zone = "Ashenvale", note = "Blackfathom Deeps, Shadowfang Keep, or other groups can be good XP/loot breaks if you find an efficient party." },
        { type = "level", level = 25, title = "Reach level 25", note = "Midpoint: reassess which zone has the best remaining quest density (Ashenvale, Hillsbrad, Stonetalon, or Southern Barrens routes)." },
        { type = "note", title = "Thousand Needles transition", zone = "Thousand Needles", note = "Move to Thousand Needles when quest levels fit (often mid/late 20s). Pick up hub quests and complete circuits around Freewind Post and nearby camps as available." },
        { type = "note", title = "Thousand Needles circuits", zone = "Thousand Needles", note = "Group nearby objectives (creatures, items, drops) to minimize backtracking. Use shimmer/flat or travel routes only if relevant and verified on WoW Forever." },
        { type = "train", title = "Class skills (28)", note = "Train and restock before final 30 push." },
        { type = "level", level = 30, title = "Reach level 30", note = "Milestone reached. Prepare for 30-40 zones (Stranglethorn, Arathi, Desolace, etc.). Continue with /flg suggest." },
    },
})

ns:RegisterGuide("horde_30_40_stranglethorn_arathi_desolace_scaffold", {
    title = "Horde 30-40: Stranglethorn / Arathi / Desolace (Scaffold)",
    faction = "Horde",
    minLevel = 30,
    maxLevel = 40,
    scaffold = true,
    steps = {
        { type = "note", title = "Scaffold route (WIP, original)", zone = "Stranglethorn Vale", note = "Structured 30-40 Horde skeleton. Verify quest hubs, chains, and travel paths on WoW Forever; add quest IDs/coords for your route." },
        { type = "note", title = "Plan your 30s route", note = "Common options: Stranglethorn Vale (Grom'gol/Booty Bay area quests), Arathi Highlands, Desolace, Alterac/Hillsbrad leftovers, and Thousand Needles/Shimmering Flats wrap-up. Choose based on level and density." },
        { type = "note", title = "Stranglethorn Vale (STV)", zone = "Stranglethorn Vale", note = "Work STV quest chains in batches (Nesingwary/wildlife, Grom'gol-area, venture co., etc. as available). STV travel can be long - group objectives by sub-area." },
        { type = "train", title = "Class skills (30-32)", note = "Train important upgrades and refresh consumables before long circuits." },
        { type = "note", title = "Arathi Highlands", zone = "Arathi Highlands", note = "Pick up Hammerfall and nearby quests if in level range. Combine kill/collect objectives and watch for group/elite quests." },
        { type = "level", level = 33, title = "Reach level 33", note = "Checkpoint: turn in completed chains and pick up follow-ups that stay in-range." },
        { type = "note", title = "Desolace", zone = "Desolace", note = "Desolace can offer dense questing for mid 30s. Establish hub flow, do circuits, and skip inefficient long-distance steps." },
        { type = "note", title = "Dungeon/group options (optional)", note = "Scarlet Monastery, Razorfen Downs, or other dungeons can be strong XP/gear in this range if groups are available." },
        { type = "train", title = "Class skills (36)", note = "Train and repair. Re-evaluate zone choice for late 30s." },
        { type = "level", level = 36, title = "Reach level 36", note = "Late-30s checkpoint: focus on high-value chains leading into 40+ zones." },
        { type = "note", title = "Late 30s wrap-up", note = "Finish efficient STV/Arathi/Desolace quests, clear inventory, and plan transition to Badlands, Swamp of Sorrows, Dustwallow/Tanaris/Feralas as appropriate for WoW Forever." },
        { type = "level", level = 40, title = "Reach level 40", note = "Milestone reached. Continue with /flg suggest or load the next Horde 40-50 scaffold." },
    },
})

ns:RegisterGuide("horde_40_50_tanaris_feralas_hinterlands_scaffold", {
    title = "Horde 40-50: Tanaris / Feralas / Hinterlands (Scaffold)",
    faction = "Horde",
    minLevel = 40,
    maxLevel = 50,
    scaffold = true,
    steps = {
        { type = "note", title = "Scaffold route (WIP, original)", zone = "Tanaris", note = "Structured 40-50 Horde skeleton. Verify hub availability, quest chains, and travel on WoW Forever; add quest IDs/coords." },
        { type = "note", title = "Plan your 40s route", note = "Common options: Tanaris, Feralas, Hinterlands, Stranglethorn leftovers, Badlands, Swamp of Sorrows, and Searing Gorge entry later. Prioritize dense, in-level chains." },
        { type = "note", title = "Tanaris (Gadgetzan/Camp Mojache links)", zone = "Tanaris", note = "Work Tanaris hubs and desert circuits. Bundle wastewander/pirate/beast objectives where possible to reduce travel." },
        { type = "train", title = "Class skills (40-42)", note = "Train upgrades and restock consumables/repair." },
        { type = "level", level = 42, title = "Reach level 42", note = "Checkpoint: keep quests yellow/green-efficient; drop overly grindy chains if better options exist." },
        { type = "note", title = "Feralas", zone = "Feralas", note = "Progress Camp Mojache and shoreline/inland quest loops as available. Group objectives by region for efficiency." },
        { type = "note", title = "The Hinterlands", zone = "The Hinterlands", note = "Revantusk Village and nearby chains can be strong in this range. Combine collection/kill objectives and handle elites with groups when needed." },
        { type = "note", title = "Dungeon/group options (optional)", note = "Zul'Farrak, Maraudon, Uldaman, or other dungeons can provide strong XP/loot bursts if groups are efficient." },
        { type = "train", title = "Class skills (46)", note = "Train and prepare for late-40s zones (Searing Gorge, Felwood, Azshara alternatives)." },
        { type = "level", level = 46, title = "Reach level 46", note = "Late-40s checkpoint: target chains that lead into 50+ zones." },
        { type = "note", title = "Searing Gorge / late 40s wrap-up", zone = "Searing Gorge", note = "Begin Searing Gorge or other high-40s hubs if unlocked/available. Finish best remaining Tanaris/Feralas/Hinterlands chains." },
        { type = "level", level = 50, title = "Reach level 50", note = "Milestone reached. Continue with /flg suggest or load the next Horde 50-60 scaffold." },
    },
})

ns:RegisterGuide("horde_50_60_ungoro_felwood_burning_steppes_scaffold", {
    title = "Horde 50-60: Un'Goro / Felwood / WPL-EPL / Endgame (Scaffold)",
    faction = "Horde",
    minLevel = 50,
    maxLevel = 60,
    scaffold = true,
    steps = {
        { type = "note", title = "Scaffold route (WIP, original)", zone = "Un'Goro Crater", note = "Structured 50-60 Horde skeleton. Verify endgame hub/quest progression and travel on WoW Forever; add quest IDs/coords and tune for your server." },
        { type = "note", title = "Plan your 50s route", note = "Common options: Un'Goro Crater, Felwood, Winterspring, Western/Eastern Plaguelands, Burning Steppes, Azshara, and Silithus near cap. Mix questing with dungeons as efficient." },
        { type = "note", title = "Un'Goro Crater", zone = "Un'Goro Crater", note = "Run crater circuits for collection/kill chains; many objectives overlap well. Set hearth/flight paths as available and batch turn-ins." },
        { type = "train", title = "Class skills (50-52)", note = "Train key abilities and ensure gear/consumables are up to date." },
        { type = "level", level = 52, title = "Reach level 52", note = "Checkpoint: rotate to Felwood/Burning Steppes/Azshara or continue Un'Goro based on remaining quests." },
        { type = "note", title = "Felwood / Winterspring", zone = "Felwood", note = "Work Felwood hubs and extend into Winterspring when level-appropriate. Prioritize efficient chains and reputable/valuable turn-ins if relevant." },
        { type = "note", title = "Burning Steppes", zone = "Burning Steppes", note = "Complete Burning Steppes chains and dungeon-related breadcrumbs where useful (BRD/UBRS prep) if that fits your server progression." },
        { type = "note", title = "Western & Eastern Plaguelands", zone = "Western Plaguelands", note = "Plaguelands offer strong late leveling chains and group content. Follow hub circuits and handle elite areas with groups." },
        { type = "train", title = "Class skills (56-58)", note = "Final talent/skill upgrades before cap. Stock consumables for tougher zones/instances." },
        { type = "level", level = 56, title = "Reach level 56", note = "Late leveling: focus on EPL/Silithus/Winterspring high-value chains and efficient dungeon runs." },
        { type = "note", title = "Silithus / endgame prep (optional)", zone = "Silithus", note = "If available and in range, do Silithus intro/chains and prepare for endgame activities. Verify all requirements on WoW Forever." },
        { type = "note", title = "Dungeon/group options (optional)", note = "BRD, LBRS/UBRS, Strat/Scholo, or other endgame dungeons can complement or replace final questing levels depending on group availability." },
        { type = "level", level = 60, title = "Reach level 60", note = "Leveling complete. Refine this scaffold with verified quest IDs/coords for a polished, server-accurate route." },
    },
})
