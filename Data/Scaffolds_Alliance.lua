local _, ns = ...

-- Original open route scaffolds (Alliance) for ForeverLevelingGuide by ByJTT.
-- Clean-room, open, and extensible: structured 1-60 guidance skeletons intended for
-- in-game verification and expansion on WoW Forever (quest IDs/mapIDs/coords may differ).
-- Bracket/zone progression is compared at a high level to established leveling guide
-- patterns for pacing and flow, but all step text and structure here are original.
-- Contributions welcome: https://github.com/ByJTT/wow-forever-leveling-guide-addon

ns:RegisterGuide("alliance_10_20_westfall_loch_modan_darkshore_scaffold", {
    title = "Alliance 10-20: Darkshore / Loch Modan / Westfall (Scaffold)",
    faction = "Alliance",
    minLevel = 10,
    maxLevel = 20,
    next = "alliance_20_30_duskwood_redridge_wetlands_scaffold",
    scaffold = true,
    steps = {
        { type = "note", title = "Scaffold route (WIP, original)", zone = "Darkshore", note = "Structured 10-20 Alliance skeleton compared at a high level to established leveling-guide flow (Darkshore, Loch Modan, and/or Westfall paths depending on race/travel). Verify quest availability, turn-ins, travel, and any map/quest details on WoW Forever; add quest IDs and coords as you confirm them." },
        { type = "note", title = "Prep and hub setup", note = "Repair, restock food/water/ammo/reagents, and clear bags. Train professions/secondary skills in a capital if needed. Set hearth at your active quest hub when convenient." },
        { type = "train", title = "Class skills (10)", note = "Train new abilities before pushing out. Even-level upgrades matter for speed and safety." },
        { type = "note", title = "Choose your 10-20 hub path", note = "Common Alliance options: Darkshore (Auberdine) for Night Elves and boat travelers, Loch Modan (Thelsamar) for dwarves/gnomes and Ironforge access, or Westfall (Sentinel Hill) for humans and Stormwind access. Pick the densest path for your character and server." },
        { type = "goto", title = "Establish your main hub", zone = "Westfall", npc = "Local innkeeper and questgivers", note = "Pick up all available local quests in your chosen zone (Sentinel Hill, Thelsamar, or Auberdine). Work objectives in circuits, turn in batches, and take follow-ups in the same area." },
        { type = "note", title = "Early circuits (10-13)", zone = "Loch Modan", note = "Complete nearby kill/collect chains around your hub (farms/coast in Westfall, valley/lake in Loch Modan, forest/coast in Darkshore). Skip over-dangerous or crowded camps and return later." },
        { type = "level", level = 12, title = "Reach level 12", note = "Checkpoint: vendor, repair, and train if convenient." },
        { type = "train", title = "Class skills (12-14)", note = "Train upgrades and refresh consumables." },
        { type = "note", title = "Mid bracket progression (13-16)", zone = "Darkshore", note = "Continue your hub's chains and consider a second zone if quests thin out (Westfall/Loch Modan/Darkshore transitions are common in established guide flows). Keep travel efficient." },
        { type = "note", title = "Dungeon/group option (optional)", note = "Deadmines or other groups can be strong XP/loot in this range if available and efficient. Optional only - questing remains the baseline path." },
        { type = "level", level = 16, title = "Reach level 16", note = "Checkpoint: finish nearby chains, avoid long backtracking, and restock." },
        { type = "train", title = "Class skills (16-18)", note = "Train key upgrades before moving to 20+ zones." },
        { type = "note", title = "Bridge toward 20 (16-20)", zone = "Redridge Mountains", note = "As local quests run out, transition toward Redridge Mountains, Duskwood, Ashenvale, or Wetlands breadcrumbs as appropriate and verified on WoW Forever. Prioritize in-level, low-travel chains." },
        { type = "level", level = 20, title = "Reach level 20", zone = "Westfall", note = "Milestone reached. Use /flg continue to load the next scaffold and refine it with WoW Forever-verified details." },
    },
})

ns:RegisterGuide("alliance_20_30_duskwood_redridge_wetlands_scaffold", {
    title = "Alliance 20-30: Redridge / Duskwood / Ashenvale / Wetlands (Scaffold)",
    faction = "Alliance",
    minLevel = 20,
    maxLevel = 30,
    next = "alliance_30_40_stranglethorn_arathi_desolace_scaffold",
    scaffold = true,
    steps = {
        { type = "note", title = "Scaffold route (WIP, original)", zone = "Redridge Mountains", note = "Structured 20-30 Alliance skeleton compared at a high level to established leveling-guide flow (Redridge/Duskwood/Ashenvale/Wetlands mix). Validate hub order, chains, and travel routes on WoW Forever; add verified quest IDs/coords." },
        { type = "note", title = "Choose your 20-30 path", note = "Common flow: Redridge Mountains and/or Duskwood early 20s, Ashenvale and Wetlands mid 20s, then Duskwood/Wetlands/Ashenvale wrap-up toward 30. Follow the densest in-level chains available to you." },
        { type = "train", title = "Class skills (20)", note = "Train milestone abilities and restock before traveling." },
        { type = "note", title = "Redridge and/or Duskwood start (20-23)", zone = "Redridge Mountains", note = "Work Lakeshire/Redridge or Darkshire/Duskwood hubs as available. Do local circuits and handle higher-level or elite threats with caution/groups when needed. Batch turn-ins to reduce travel." },
        { type = "level", level = 22, title = "Reach level 22", note = "Checkpoint: train, vendor, and choose the best next hub." },
        { type = "train", title = "Class skills (22-24)", note = "Train upgrades and keep consumables stocked." },
        { type = "note", title = "Ashenvale and/or Wetlands (23-26)", zone = "Ashenvale", note = "Progress Astranaar/Ashenvale or Menethil Harbor/Wetlands chains if efficient. Combine objectives into loops. Dungeon groups (BFD/Stockade/SFK) can supplement XP if efficient, but are optional." },
        { type = "level", level = 25, title = "Reach level 25", note = "Midpoint: reassess Duskwood, Wetlands, Ashenvale, or Redridge leftovers based on quest density." },
        { type = "note", title = "Mid-late 20s circuits (26-28)", zone = "Wetlands", note = "Finish strong chains in Wetlands, Ashenvale, or Duskwood. Avoid long travel for low-value turn-ins and keep your quest log focused on one or two hubs." },
        { type = "train", title = "Class skills (26-28)", note = "Train and repair before the final push." },
        { type = "level", level = 28, title = "Reach level 28", note = "Checkpoint: prepare transition to late-20s/early-30s zones (Duskwood/Ashenvale/STV/Arathi options)." },
        { type = "note", title = "Wrap-up to 30 (28-30)", zone = "Duskwood", note = "Complete remaining efficient Duskwood, Ashenvale, or Wetlands quests. Prepare for Stranglethorn, Arathi, Desolace, or other 30+ options as available on WoW Forever." },
        { type = "level", level = 30, title = "Reach level 30", zone = "Duskwood", note = "Milestone reached. Use /flg continue for the next scaffold and tune with verified WoW Forever data." },
    },
})

ns:RegisterGuide("alliance_30_40_stranglethorn_arathi_desolace_scaffold", {
    title = "Alliance 30-40: Hillsbrad / Arathi / Stranglethorn / Desolace (Scaffold)",
    faction = "Alliance",
    minLevel = 30,
    maxLevel = 40,
    next = "alliance_40_50_tanaris_feralas_hinterlands_scaffold",
    scaffold = true,
    steps = {
        { type = "note", title = "Scaffold route (WIP, original)", zone = "Stranglethorn Vale", note = "Structured 30-40 Alliance skeleton compared at a high level to established leveling-guide flow (Hillsbrad/Southshore area, Arathi, STV, Desolace options). Verify hubs, chains, and travel paths on WoW Forever; add quest IDs/coords for your route." },
        { type = "note", title = "Plan your 30s route", note = "Common options: Hillsbrad/Alterac-adjacent content early 30s, Arathi Highlands and Desolace mid 30s, Stranglethorn Vale across much of the bracket. Choose by quest density, safety, and travel access." },
        { type = "train", title = "Class skills (30)", note = "Train important upgrades and refresh consumables before long circuits." },
        { type = "note", title = "Early 30s hubs (30-33)", zone = "Hillsbrad Foothills", note = "Work Southshore/Hillsbrad or other efficient local chains if available. Be mindful of contested areas and PvP risk. Batch objectives and avoid overtravel." },
        { type = "level", level = 33, title = "Reach level 33", note = "Checkpoint: turn in completed chains and pick up follow-ups that stay in-range." },
        { type = "train", title = "Class skills (32-34)", note = "Train and repair before switching regions." },
        { type = "note", title = "Mid 30s options: Arathi and/or Desolace (33-36)", zone = "Arathi Highlands", note = "Refuge Pointe/Arathi and Nijel's Point/Desolace can be efficient in the mid 30s. Do compact circuits, combine kill/collect objectives, and handle elite/group quests with a party when needed." },
        { type = "note", title = "Stranglethorn Vale circuits (33-38)", zone = "Stranglethorn Vale", note = "STV can span several levels: work Rebel Camp and nearby chains in batches by sub-area. Group objectives to reduce long runs; use neutral hubs/turn-ins only when efficient." },
        { type = "note", title = "Dungeon/group option (optional)", note = "Scarlet Monastery wings, Razorfen Downs, Gnomeregan (if still useful), or other groups can provide strong XP/gear if efficient. Optional." },
        { type = "level", level = 36, title = "Reach level 36", note = "Late-30s checkpoint: focus on high-value chains leading into 40+ zones." },
        { type = "train", title = "Class skills (36-38)", note = "Train and restock for tougher mobs and longer routes." },
        { type = "note", title = "Late 30s wrap-up (36-40)", zone = "Desolace", note = "Finish efficient Arathi/Desolace/STV leftovers and prepare for Badlands, Swamp of Sorrows, Tanaris, Feralas, or Hinterlands as appropriate for WoW Forever." },
        { type = "level", level = 40, title = "Reach level 40", zone = "Stranglethorn Vale", note = "Milestone reached. Use /flg continue for the next scaffold." },
    },
})

ns:RegisterGuide("alliance_40_50_tanaris_feralas_hinterlands_scaffold", {
    title = "Alliance 40-50: Badlands / Tanaris / Feralas / Hinterlands (Scaffold)",
    faction = "Alliance",
    minLevel = 40,
    maxLevel = 50,
    next = "alliance_50_60_ungoro_felwood_burning_steppes_scaffold",
    scaffold = true,
    steps = {
        { type = "note", title = "Scaffold route (WIP, original)", zone = "Tanaris", note = "Structured 40-50 Alliance skeleton compared at a high level to established leveling-guide flow (Badlands/Swamp early 40s, Tanaris/Feralas/Hinterlands mid-late 40s, Searing Gorge or other late-40s entry). Verify hubs, chains, and travel on WoW Forever; add quest IDs/coords." },
        { type = "note", title = "Plan your 40s route", note = "Common options: Badlands and/or Swamp of Sorrows around 40-43, Stranglethorn leftovers, then Tanaris/Feralas/Hinterlands through mid/late 40s, with Searing Gorge or other high-40s hubs near the end. Prioritize dense, in-level chains." },
        { type = "train", title = "Class skills (40)", note = "Train milestone upgrades and restock." },
        { type = "note", title = "Early 40s hubs (40-43)", zone = "Badlands", note = "Work Badlands and/or Swamp of Sorrows circuits if available and efficient. Bundle objectives, watch for elite areas, and use groups for dungeon/elite quests when worthwhile." },
        { type = "level", level = 42, title = "Reach level 42", note = "Checkpoint: keep quests yellow/green-efficient; drop overly grindy chains if better options exist." },
        { type = "train", title = "Class skills (42-44)", note = "Train and repair before desert/jungle circuits." },
        { type = "note", title = "Tanaris circuits (43-46)", zone = "Tanaris", note = "Use Gadgetzan/Steamwheedle hubs as available. Complete desert circuits in loops to reduce travel and group related objectives together." },
        { type = "note", title = "Feralas and/or Hinterlands (44-48)", zone = "Feralas", note = "Feathermoon/Feralas loops and Aerie Peak/Hinterlands chains can be strong in this range. Group objectives by region and handle elite quests with parties." },
        { type = "note", title = "Dungeon/group option (optional)", note = "Zul'Farrak, Maraudon, Uldaman, or other dungeons can provide strong XP/loot bursts if groups are efficient. Optional." },
        { type = "level", level = 46, title = "Reach level 46", note = "Late-40s checkpoint: target chains that lead into 50+ zones." },
        { type = "train", title = "Class skills (46-48)", note = "Train and prepare for higher-level zones." },
        { type = "note", title = "Late 40s wrap-up (46-50)", zone = "The Hinterlands", note = "Finish best remaining Tanaris/Feralas/Hinterlands chains and begin Searing Gorge, Felwood, Azshara, or other high-40s hubs if unlocked/available on WoW Forever." },
        { type = "level", level = 50, title = "Reach level 50", zone = "Tanaris", note = "Milestone reached. Use /flg continue for the final scaffold." },
    },
})

ns:RegisterGuide("alliance_50_60_ungoro_felwood_burning_steppes_scaffold", {
    title = "Alliance 50-60: Felwood / Un'Goro / Plaguelands / Silithus (Scaffold)",
    faction = "Alliance",
    minLevel = 50,
    maxLevel = 60,
    scaffold = true,
    steps = {
        { type = "note", title = "Scaffold route (WIP, original)", zone = "Un'Goro Crater", note = "Structured 50-60 Alliance skeleton compared at a high level to established leveling-guide flow (Felwood/Un'Goro/Winterspring and Plaguelands/Silithus options late). Verify endgame hub progression and travel on WoW Forever; add quest IDs/coords and tune for your server." },
        { type = "note", title = "Plan your 50s route", note = "Common options: Searing Gorge/Burning Steppes/Felwood around 50-53, Un'Goro Crater and Winterspring mid 50s, Western/Eastern Plaguelands late 50s, with Silithus near cap if available. Mix questing with dungeons as efficient." },
        { type = "train", title = "Class skills (50)", note = "Train key abilities and ensure gear/consumables are up to date." },
        { type = "note", title = "Early 50s hubs (50-53)", zone = "Felwood", note = "Work Felwood and/or Burning Steppes/Searing Gorge leftovers as available. Prioritize dense chains and avoid long, low-value travel." },
        { type = "level", level = 52, title = "Reach level 52", note = "Checkpoint: rotate to Un'Goro, Winterspring, or other strong zones based on remaining quests." },
        { type = "note", title = "Un'Goro Crater and Winterspring (52-56)", zone = "Un'Goro Crater", note = "Run Un'Goro crater circuits (many objectives overlap well) and/or Winterspring chains when level-appropriate. Set hearth/flight paths where available and batch turn-ins." },
        { type = "train", title = "Class skills (54-56)", note = "Train and restock for tougher areas and dungeon prep." },
        { type = "level", level = 55, title = "Reach level 55", note = "Checkpoint: start steering toward late-50s Plaguelands/endgame chains." },
        { type = "note", title = "Western & Eastern Plaguelands (55-58)", zone = "Western Plaguelands", note = "Plaguelands offer strong late-leveling chains and group content. Follow hub circuits, handle elite areas with groups, and pick up dungeon breadcrumbs if useful for your progression." },
        { type = "train", title = "Class skills (58)", note = "Final pre-cap upgrades. Stock consumables for tougher zones/instances." },
        { type = "level", level = 58, title = "Reach level 58", note = "Late leveling: focus on EPL, Winterspring, Silithus (if in range), and efficient dungeon runs." },
        { type = "note", title = "Final push to 60 (58-60)", zone = "Eastern Plaguelands", note = "Complete the highest-value remaining chains. Dungeon groups can replace or complement questing depending on availability - choose the fastest, safest option for your character." },
        { type = "note", title = "Silithus / endgame prep (optional)", zone = "Silithus", note = "If available and in range, do Silithus intro/chains and prepare for endgame activities. Verify all requirements on WoW Forever." },
        { type = "level", level = 60, title = "Reach level 60", note = "Leveling complete. Refine this scaffold with verified quest IDs/coords for a polished, server-accurate route. Congratulations!" },
    },
})
