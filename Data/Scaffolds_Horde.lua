local _, ns = ...

-- Original open route scaffolds (Horde) for ForeverLevelingGuide by ByJTT.
-- Clean-room, open, and extensible: structured 1-60 guidance skeletons intended for
-- in-game verification and expansion on WoW Forever (quest IDs/mapIDs/coords may differ).
-- Bracket/zone progression is compared at a high level to established leveling guide
-- patterns for pacing and flow, but all step text and structure here are original.
-- Contributions welcome: https://github.com/ByJTT/wow-forever-leveling-guide-addon

ns:RegisterGuide("horde_10_20_barrens_stonetalon_scaffold", {
    title = "Horde 10-20: Barrens / Stonetalon (Scaffold)",
    faction = "Horde",
    minLevel = 10,
    maxLevel = 20,
    next = "horde_20_30_ashenvale_thousand_needles_scaffold",
    scaffold = true,
    steps = {
        { type = "note", title = "Scaffold route (WIP, original)", zone = "The Barrens", note = "Structured 10-20 Horde skeleton compared at a high level to established leveling-guide flow (Barrens hubs with a possible mid-teens Stonetalon detour). Verify quest availability, turn-ins, travel, and any map/quest details on WoW Forever; add quest IDs and coords as you confirm them." },
        { type = "note", title = "Prep and hub setup", zone = "The Barrens", note = "Repair, restock food/water/ammo/reagents, and clear bags. Set hearth at a convenient hub (often Crossroads) when practical. Train professions/secondary skills in a capital if needed." },
        { type = "train", title = "Class skills (10)", note = "Train new abilities before pushing out. Even-level upgrades matter for speed and safety." },
        { type = "goto", title = "Establish Crossroads as your main hub", zone = "The Barrens", npc = "Crossroads innkeeper and questgivers", note = "Pick up all available local quests. Work nearby objectives in circuits to reduce backtracking; turn in batches and grab follow-ups in the same area." },
        { type = "note", title = "Barrens circuits (10-12)", zone = "The Barrens", note = "Focus on efficient local chains around Crossroads and nearby roads. Skip dangerous or overly crowded camps and return later if needed. Keep your quest log focused on one area at a time." },
        { type = "level", level = 12, title = "Reach level 12", note = "Checkpoint: vendor, repair, and train if convenient." },
        { type = "note", title = "Crossroads and Ratchet (12-14)", zone = "The Barrens", note = "Continue Crossroads follow-ups and include Ratchet-area tasks if efficient on your server. Turn in batches and avoid long detours for low-value quests." },
        { type = "note", title = "Dungeon/group option (optional)", zone = "The Barrens", note = "Ragefire Chasm or Wailing Caverns can be good XP/loot breaks if groups are available and efficient. Optional only - questing remains the baseline path." },
        { type = "level", level = 14, title = "Reach level 14", note = "Checkpoint: refresh skills/consumables and plan a mid-teens hub change if Barrens quests thin out." },
        { type = "train", title = "Class skills (14)", note = "Train key upgrades before longer travel or tougher camps." },
        { type = "note", title = "Stonetalon Mountains detour (14-16, if efficient)", zone = "Stonetalon Mountains", note = "Follow available breadcrumbs to Stonetalon (often Sun Rock Retreat area) when quests fit. Do compact local circuits, then return to Barrens as follow-ups direct. If travel/quests are poor on WoW Forever, stay in Barrens." },
        { type = "level", level = 16, title = "Reach level 16", note = "Checkpoint: finish nearby chains and avoid long backtracking." },
        { type = "train", title = "Class skills (16)", note = "Train and restock. Update hearth to the hub you will use most." },
        { type = "note", title = "Southern/central Barrens wrap-up (16-18)", zone = "The Barrens", note = "Work Camp Taurajo/southern Barrens and remaining Crossroads chains as level-appropriate. Group nearby objectives; handle escort/elite/group steps with help or defer if inefficient." },
        { type = "level", level = 18, title = "Reach level 18", note = "Checkpoint: prioritize orange/yellow quests that stay in one area." },
        { type = "train", title = "Class skills (18)", note = "Train before the final push to 20." },
        { type = "note", title = "Final 18-20 push", zone = "The Barrens", note = "Complete the most efficient remaining Barrens/Stonetalon quests. Prepare for 20+ options (Stonetalon, Ashenvale, Southern Barrens, or Thousand Needles depending on server/class/quest flow)." },
        { type = "level", level = 20, title = "Reach level 20", zone = "The Barrens", note = "Milestone reached. Use /flg continue to load the next scaffold and refine it with WoW Forever-verified details." },
    },
})

ns:RegisterGuide("horde_20_30_ashenvale_thousand_needles_scaffold", {
    title = "Horde 20-30: Stonetalon / Ashenvale / Barrens / Thousand Needles (Scaffold)",
    faction = "Horde",
    minLevel = 20,
    maxLevel = 30,
    next = "horde_30_40_stranglethorn_arathi_desolace_scaffold",
    scaffold = true,
    steps = {
        { type = "note", title = "Scaffold route (WIP, original)", zone = "Stonetalon Mountains", note = "Structured 20-30 Horde skeleton compared at a high level to established leveling-guide flow (Stonetalon/Ashenvale early, Barrens/Southern Barrens mid 20s, Thousand Needles and alternatives late 20s). Validate hub order, chains, and travel on WoW Forever; add verified quest IDs/coords." },
        { type = "note", title = "Choose your 20-30 path", note = "Common Horde flow: early 20s in Stonetalon and/or Ashenvale, mid 20s in Southern Barrens and remaining Stonetalon quests, late 20s in Thousand Needles with Ashenvale/Hillsbrad alternatives. Follow the densest in-level chains available to you." },
        { type = "train", title = "Class skills (20)", note = "Train milestone abilities and restock before traveling." },
        { type = "note", title = "Stonetalon and/or Ashenvale start (20-22)", zone = "Stonetalon Mountains", note = "Work Sun Rock Retreat/Stonetalon circuits and/or Splintertree Post-area Ashenvale chains when efficient. Batch objectives by sub-area; avoid long cross-zone runs for single turn-ins." },
        { type = "level", level = 22, title = "Reach level 22", note = "Checkpoint: turn in batches, pick up follow-ups, and choose the best next hub." },
        { type = "train", title = "Class skills (22-24)", note = "Train upgrades and keep consumables stocked." },
        { type = "note", title = "Southern Barrens and Stonetalon follow-ups (22-25)", zone = "The Barrens", note = "Return to Southern Barrens/Camp Taurajo-area chains and remaining Stonetalon quests as appropriate. Dungeon groups (e.g. BFD/SFK) can supplement XP if efficient, but are optional." },
        { type = "level", level = 25, title = "Reach level 25", note = "Midpoint: reassess Ashenvale, Hillsbrad, Stonetalon, or Thousand Needles based on quest density." },
        { type = "note", title = "Thousand Needles transition (25-27)", zone = "Thousand Needles", note = "Move to Thousand Needles when quest levels fit (commonly mid/late 20s). Establish hub flow (e.g. Freewind Post area as available) and complete local circuits to minimize travel." },
        { type = "train", title = "Class skills (26)", note = "Train and repair before longer circuits." },
        { type = "level", level = 27, title = "Reach level 27", note = "Checkpoint: focus on efficient kill/collect loops and nearby turn-ins." },
        { type = "note", title = "Late 20s wrap-up (27-30)", zone = "Thousand Needles", note = "Finish strong Thousand Needles and/or Ashenvale/Hillsbrad leftovers. Prepare to transition toward Hillsbrad/Arathi, Stranglethorn, Desolace, or other 30+ options as available on WoW Forever." },
        { type = "train", title = "Class skills (28-30)", note = "Train before entering higher-level zones." },
        { type = "level", level = 30, title = "Reach level 30", zone = "Thousand Needles", note = "Milestone reached. Use /flg continue for the next scaffold and tune with verified WoW Forever data." },
    },
})

ns:RegisterGuide("horde_30_40_stranglethorn_arathi_desolace_scaffold", {
    title = "Horde 30-40: Hillsbrad / Arathi / Stranglethorn / Desolace (Scaffold)",
    faction = "Horde",
    minLevel = 30,
    maxLevel = 40,
    next = "horde_40_50_tanaris_feralas_hinterlands_scaffold",
    scaffold = true,
    steps = {
        { type = "note", title = "Scaffold route (WIP, original)", zone = "Stranglethorn Vale", note = "Structured 30-40 Horde skeleton compared at a high level to established leveling-guide flow (Hillsbrad/Arathi/STV/Desolace options with some bracket flexibility). Verify hubs, chains, and travel paths on WoW Forever; add quest IDs/coords for your route." },
        { type = "note", title = "Plan your 30s route", note = "Common options: Hillsbrad foothills early 30s, Arathi Highlands and/or Desolace mid 30s, Stranglethorn Vale across much of the bracket, with Thousand Needles/Shimmering Flats wrap-up if still relevant. Choose by quest density, safety, and travel access." },
        { type = "train", title = "Class skills (30)", note = "Train important upgrades and refresh consumables before long circuits." },
        { type = "note", title = "Early 30s hubs (30-33)", zone = "Hillsbrad Foothills", note = "Work available Tarren Mill/Hillsbrad or other efficient local chains. Be mindful of contested areas and PvP risk on your realm. Batch objectives and avoid overtravel." },
        { type = "level", level = 33, title = "Reach level 33", note = "Checkpoint: turn in completed chains and pick up follow-ups that stay in-range." },
        { type = "train", title = "Class skills (32-34)", note = "Train and repair before switching regions." },
        { type = "note", title = "Mid 30s options: Arathi and/or Desolace (33-36)", zone = "Arathi Highlands", note = "Hammerfall/Arathi and Desolace hubs can be efficient in the mid 30s. Do compact circuits, combine kill/collect objectives, and handle elite/group quests with a party when needed." },
        { type = "note", title = "Stranglethorn Vale circuits (33-38)", zone = "Stranglethorn Vale", note = "STV can span several levels: work Grom'gol and nearby chains in batches by sub-area. Long travel means grouping objectives is important; use neutral hubs/turn-ins only when efficient." },
        { type = "note", title = "Dungeon/group option (optional)", note = "Scarlet Monastery wings, Razorfen Downs, or other groups can provide strong XP/gear if efficient. Optional; keep questing momentum otherwise." },
        { type = "level", level = 36, title = "Reach level 36", note = "Late-30s checkpoint: focus on high-value chains leading into 40+ zones." },
        { type = "train", title = "Class skills (36-38)", note = "Train and restock for tougher mobs and longer routes." },
        { type = "note", title = "Late 30s wrap-up (36-40)", zone = "Desolace", note = "Finish efficient Arathi/Desolace/STV leftovers and prepare for Badlands, Swamp of Sorrows, Dustwallow-adjacent routes, Tanaris, or Feralas as appropriate for WoW Forever." },
        { type = "level", level = 40, title = "Reach level 40", zone = "Stranglethorn Vale", note = "Milestone reached. Use /flg continue for the next scaffold." },
    },
})

ns:RegisterGuide("horde_40_50_tanaris_feralas_hinterlands_scaffold", {
    title = "Horde 40-50: Badlands / Swamp / Tanaris / Feralas / Hinterlands (Scaffold)",
    faction = "Horde",
    minLevel = 40,
    maxLevel = 50,
    next = "horde_50_60_ungoro_felwood_burning_steppes_scaffold",
    scaffold = true,
    steps = {
        { type = "note", title = "Scaffold route (WIP, original)", zone = "Tanaris", note = "Structured 40-50 Horde skeleton compared at a high level to established leveling-guide flow (Badlands/Swamp early 40s, Tanaris/Feralas/Hinterlands mid-late 40s, Searing Gorge or other late-40s entry). Verify hubs, chains, and travel on WoW Forever; add quest IDs/coords." },
        { type = "note", title = "Plan your 40s route", note = "Common options: Badlands and/or Swamp of Sorrows around 40-43, Stranglethorn leftovers, then Tanaris/Feralas/Hinterlands through mid/late 40s, with Searing Gorge or other high-40s hubs near the end. Prioritize dense, in-level chains." },
        { type = "train", title = "Class skills (40)", note = "Train milestone upgrades and restock." },
        { type = "note", title = "Early 40s hubs (40-43)", zone = "Badlands", note = "Work Badlands and/or Swamp of Sorrows circuits if available and efficient. Bundle objectives, watch for elite areas, and use groups for dungeon/elite quests when worthwhile." },
        { type = "level", level = 42, title = "Reach level 42", note = "Checkpoint: keep quests yellow/green-efficient; drop overly grindy chains if better options exist." },
        { type = "train", title = "Class skills (42-44)", note = "Train and repair before desert/jungle circuits." },
        { type = "note", title = "Tanaris circuits (43-46)", zone = "Tanaris", note = "Use Gadgetzan and nearby hubs as available. Complete desert circuits in loops to reduce travel and group related objectives together." },
        { type = "note", title = "Feralas and/or Hinterlands (44-48)", zone = "Feralas", note = "Camp Mojache/Feralas loops and Revantusk/Hinterlands chains can be strong in this range. Group objectives by region and handle elite quests with parties." },
        { type = "note", title = "Dungeon/group option (optional)", note = "Zul'Farrak, Maraudon, Uldaman, or other dungeons can provide strong XP/loot bursts if groups are efficient. Optional." },
        { type = "level", level = 46, title = "Reach level 46", note = "Late-40s checkpoint: target chains that lead into 50+ zones." },
        { type = "train", title = "Class skills (46-48)", note = "Train and prepare for higher-level zones." },
        { type = "note", title = "Late 40s wrap-up (46-50)", zone = "The Hinterlands", note = "Finish best remaining Tanaris/Feralas/Hinterlands chains and begin Searing Gorge, Azshara, Felwood, or other high-40s hubs if unlocked/available on WoW Forever." },
        { type = "level", level = 50, title = "Reach level 50", zone = "Tanaris", note = "Milestone reached. Use /flg continue for the final scaffold." },
    },
})

ns:RegisterGuide("horde_50_60_ungoro_felwood_burning_steppes_scaffold", {
    title = "Horde 50-60: Felwood / Un'Goro / Plaguelands / Silithus (Scaffold)",
    faction = "Horde",
    minLevel = 50,
    maxLevel = 60,
    scaffold = true,
    steps = {
        { type = "note", title = "Scaffold route (WIP, original)", zone = "Un'Goro Crater", note = "Structured 50-60 Horde skeleton compared at a high level to established leveling-guide flow (Felwood/Un'Goro/Winterspring and Plaguelands/Silithus options late). Verify endgame hub progression and travel on WoW Forever; add quest IDs/coords and tune for your server." },
        { type = "note", title = "Plan your 50s route", note = "Common options: Searing Gorge/Azshara/Felwood around 50-53, Un'Goro Crater and Winterspring mid 50s, Western/Eastern Plaguelands and Burning Steppes late 50s, with Silithus near cap if available. Mix questing with dungeons as efficient." },
        { type = "train", title = "Class skills (50)", note = "Train key abilities and ensure gear/consumables are up to date." },
        { type = "note", title = "Early 50s hubs (50-53)", zone = "Felwood", note = "Work Felwood and/or Azshara/Burning Steppes/Searing Gorge leftovers as available. Prioritize dense chains and avoid long, low-value travel." },
        { type = "level", level = 52, title = "Reach level 52", note = "Checkpoint: rotate to Un'Goro, Winterspring, or other strong zones based on remaining quests." },
        { type = "note", title = "Un'Goro Crater and Winterspring (52-56)", zone = "Un'Goro Crater", note = "Run Un'Goro crater circuits (many objectives overlap well) and/or Winterspring chains when level-appropriate. Set hearth/flight paths where available and batch turn-ins." },
        { type = "train", title = "Class skills (54-56)", note = "Train and restock for tougher areas and dungeon prep." },
        { type = "level", level = 55, title = "Reach level 55", note = "Checkpoint: start steering toward late-50s Plaguelands/endgame chains." },
        { type = "note", title = "Western & Eastern Plaguelands (55-58)", zone = "Western Plaguelands", note = "Plaguelands offer strong late-leveling chains and group content. Follow hub circuits, handle elite areas with groups, and pick up dungeon breadcrumbs (Strat/Scholo/BRD/UBRS) if useful for your progression." },
        { type = "train", title = "Class skills (58)", note = "Final pre-cap upgrades. Stock consumables for tougher zones/instances." },
        { type = "level", level = 58, title = "Reach level 58", note = "Late leveling: focus on EPL, Winterspring, Silithus (if in range), and efficient dungeon runs." },
        { type = "note", title = "Final push to 60 (58-60)", zone = "Eastern Plaguelands", note = "Complete the highest-value remaining chains. Dungeon groups can replace or complement questing depending on availability - choose the fastest, safest option for your character." },
        { type = "note", title = "Silithus / endgame prep (optional)", zone = "Silithus", note = "If available and in range, do Silithus intro/chains and prepare for endgame activities. Verify all requirements on WoW Forever." },
        { type = "level", level = 60, title = "Reach level 60", note = "Leveling complete. Refine this scaffold with verified quest IDs/coords for a polished, server-accurate route. Congratulations!" },
    },
})
