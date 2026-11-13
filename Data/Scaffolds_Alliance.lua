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
        { type = "note", title = "Scaffold route (WIP, original)", zone = "Darkshore", note = "Structured 10-20 Alliance skeleton compared at a high level to established leveling-guide flow (Darkshore, Loch Modan, and/or Westfall paths depending on race/travel). Original pacing/checklist scaffold - verify quest availability, turn-ins, travel, and any map/quest details on WoW Forever before adding quest IDs and coords." },
        { type = "note", title = "Prep before heading out", note = "Repair, restock food/water/ammo/reagents, clear bags, and confirm class reagents as needed. Train professions/secondary skills in a capital if convenient, but avoid long detours that cost more time than they save." },
        { type = "train", title = "Train class skills (level 10)", note = "Pick up key level-10 abilities/talents. Even small upgrades improve kill speed and safety for the next bracket." },
        { type = "note", title = "Choose your 10-20 hub path", note = "Common Alliance options: Darkshore (Auberdine area) for Night Elves and boat travelers, Loch Modan (Thelsamar area) for dwarves/gnomes with Ironforge access, or Westfall (Sentinel Hill area) for humans with Stormwind access. Pick the densest, most convenient path for your character and server." },
        { type = "note", title = "Establish your main hub", zone = "Westfall", npc = "Local innkeeper and questgivers", note = "Travel to your chosen hub (Sentinel Hill, Thelsamar, or Auberdine). Set hearth if practical, grab the flight path when available, and pick up all local quests. Plan to work objectives in loops and return for batch turn-ins." },
        { type = "note", title = "Early local circuits (10-12)", zone = "Loch Modan", note = "Complete nearby quest chains around your hub (farms/coast in Westfall, valley/lake in Loch Modan, forest/coast in Darkshore). Group kill/collect objectives that share locations and skip overcrowded or inefficient camps for now." },
        { type = "level", level = 12, title = "Reach level 12 (checkpoint)", zone = "Darkshore", note = "Checkpoint: vendor junk, repair, restock, and turn in completed quests in batches. Pick up follow-ups that stay in the same sub-area." },
        { type = "train", title = "Train class skills (12-14, if needed)", note = "Train when convenient if upgrades are meaningful; otherwise keep momentum and train at the next practical stop." },
        { type = "note", title = "Mid-bracket progression and optional second zone (13-16)", zone = "Westfall", note = "Continue your hub's chains and consider a second zone if quests thin out (Westfall/Loch Modan/Darkshore transitions are common in established guide flows). Keep travel efficient and focus on one or two active hubs at a time." },
        { type = "note", title = "Optional dungeon/group content (Deadmines)", zone = "Westfall", note = "If a good group forms, Deadmines or other dungeon runs can supplement XP/loot in this range. Treat dungeons as optional breaks - questing remains the baseline path in this scaffold." },
        { type = "level", level = 16, title = "Reach level 16 (checkpoint)", zone = "Loch Modan", note = "Checkpoint: finish nearby chains, avoid long backtracking, restock, and plan the remainder of the bracket." },
        { type = "train", title = "Train class skills (16-18)", note = "Train key upgrades before moving into tougher areas or transitioning to 20+ zones." },
        { type = "note", title = "Late teens wrap-up (16-18)", zone = "Darkshore", note = "Complete the most efficient remaining quests in your chosen 10-20 zones. Prioritize clustered objectives and turn-ins; defer long travel or elite steps unless they fit naturally." },
        { type = "level", level = 18, title = "Reach level 18 (checkpoint)", zone = "Westfall", note = "Checkpoint: focus on orange/yellow quests that stay in one region. Drop or postpone low-value, high-travel tasks." },
        { type = "train", title = "Train class skills (18)", note = "Train before the final push to 20 so combat remains smooth and downtime stays low." },
        { type = "note", title = "Bridge toward 20 (18-20)", zone = "Redridge Mountains", note = "As local quests run out, transition toward Redridge Mountains, Duskwood, Ashenvale, or Wetlands breadcrumbs as appropriate and verified on WoW Forever. Prioritize in-level, low-travel chains and avoid overcommitting to red quests." },
        { type = "level", level = 20, title = "Reach level 20 (milestone)", zone = "Darkshore", note = "Milestone reached. Use /flg continue to load the next scaffold (20-30) and refine this route with WoW Forever-verified quest IDs, mapIDs, coords, and NPC details." },
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
        { type = "note", title = "Scaffold route (WIP, original)", zone = "Redridge Mountains", note = "Structured 20-30 Alliance skeleton compared at a high level to established leveling-guide flow (Redridge/Duskwood early, Ashenvale/Wetlands mid, with flexible wrap-up toward 30). Original checklist scaffold - verify hub order, chains, travel, and quest/map details on WoW Forever before adding IDs/coords." },
        { type = "note", title = "Plan your 20-30 bracket", note = "Pick 1-2 active zones at a time. Common path: Redridge Mountains and/or Duskwood early 20s, Ashenvale and/or Wetlands mid 20s, then Duskwood/Wetlands/Ashenvale leftovers toward 30 depending on quest density and travel efficiency." },
        { type = "train", title = "Train class skills (20)", note = "Train milestone abilities, update talents, and restock before traveling to your first 20+ hub." },
        { type = "note", title = "Redridge and/or Duskwood start (20-23)", zone = "Redridge Mountains", note = "Work Lakeshire/Redridge or Darkshire/Duskwood hubs as available. Do local circuits, batch turn-ins, and handle higher-level or elite threats with caution/groups when needed. Keep travel between zones minimal." },
        { type = "level", level = 22, title = "Reach level 22 (checkpoint)", zone = "Duskwood", note = "Checkpoint: vendor, repair, train if convenient, and choose the next hub based on in-level quest density." },
        { type = "train", title = "Train class skills (22-24)", note = "Train upgrades and keep consumables stocked. Avoid long trainer detours unless multiple upgrades justify it." },
        { type = "note", title = "Ashenvale and/or Wetlands circuits (23-26)", zone = "Ashenvale", note = "Progress Astranaar/Ashenvale or Menethil Harbor/Wetlands chains if efficient. Combine objectives into loops and use flight paths/boats deliberately to avoid wasted travel." },
        { type = "note", title = "Optional dungeons/groups (20s)", note = "Blackfathom Deeps, Stockades, Shadowfang Keep, or other groups can supplement XP/loot if efficient and quest-aligned. Optional - do not let queue/wait time stall leveling momentum." },
        { type = "level", level = 25, title = "Reach level 25 (midpoint)", zone = "Wetlands", note = "Midpoint checkpoint: reassess Duskwood, Wetlands, Ashenvale, and Redridge leftovers. Move to the hub with the best cluster of yellow quests." },
        { type = "train", title = "Train class skills (24-26)", note = "Train and repair before longer circuits or a zone transition." },
        { type = "note", title = "Mid-late 20s wrap-up (26-28)", zone = "Wetlands", note = "Finish strong chains in Wetlands, Ashenvale, or Duskwood. Avoid long travel for single turn-ins and keep your quest log focused on one or two hubs." },
        { type = "level", level = 28, title = "Reach level 28 (checkpoint)", zone = "Duskwood", note = "Checkpoint: prepare transition to late-20s/early-30s zones (Duskwood/Ashenvale leftovers, Stranglethorn Vale, Arathi, or Desolace options)." },
        { type = "train", title = "Train class skills (28)", note = "Train before the final push to 30 if upgrades are available." },
        { type = "note", title = "Final push to 30 (28-30)", zone = "Ashenvale", note = "Complete remaining efficient Duskwood, Ashenvale, or Wetlands quests. Pick up breadcrumb/lead-in quests only when they align with your next 30+ hub." },
        { type = "level", level = 30, title = "Reach level 30 (milestone)", zone = "Duskwood", note = "Milestone reached. Use /flg continue for the next scaffold (30-40) and tune routes with verified WoW Forever data." },
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
        { type = "note", title = "Scaffold route (WIP, original)", zone = "Stranglethorn Vale", note = "Structured 30-40 Alliance skeleton compared at a high level to established leveling-guide flow (Hillsbrad/Southshore area, Arathi, Desolace, and Stranglethorn Vale options with bracket flexibility). Original checklist scaffold - verify hubs, chains, travel, and map/quest details on WoW Forever; add verified quest IDs/coords." },
        { type = "note", title = "Plan your 30s route (region choice)", note = "Common options: Hillsbrad/Alterac-adjacent content early 30s, Arathi Highlands and/or Desolace mid 30s, Stranglethorn Vale across much of the bracket (with travel awareness). Choose by quest density, safety, and flight/travel access." },
        { type = "train", title = "Train class skills (30)", note = "Train important upgrades and refresh consumables before longer circuits and contested travel." },
        { type = "note", title = "Early 30s hub: Hillsbrad foothills (30-33)", zone = "Hillsbrad Foothills", note = "Work Southshore/Hillsbrad-area chains if efficient and available. In contested regions, stay alert to PvP risk and avoid overcommitting to slow camps. Batch objectives by sub-area and turn in together." },
        { type = "level", level = 33, title = "Reach level 33 (checkpoint)", zone = "Hillsbrad Foothills", note = "Checkpoint: complete/turn in local chains, repair, and decide whether to continue Hillsbrad, move to Arathi/Desolace, or begin STV circuits." },
        { type = "train", title = "Train class skills (32-34)", note = "Train and repair before switching regions or starting longer STV loops." },
        { type = "note", title = "Mid 30s option: Arathi Highlands (33-36)", zone = "Arathi Highlands", note = "Use Refuge Pointe/Arathi-area hubs and chains if available and in-level. Do compact circuits, combine kill/collect objectives, and bring a group for elite steps when worthwhile. Leave if quests become sparse or over-leveled." },
        { type = "note", title = "Mid 30s option: Desolace (33-36)", zone = "Desolace", note = "Nijel's Point/Desolace can offer efficient mid-30s chains (verify availability on WoW Forever). Prioritize clustered objectives and avoid cross-zone errands that break momentum." },
        { type = "note", title = "Stranglethorn Vale circuits (33-38)", zone = "Stranglethorn Vale", note = "STV often spans several levels: work Rebel Camp and nearby chains in sub-area batches to reduce travel. Be selective with deep-penetration or contested objectives; use neutral hubs/turn-ins only when efficient." },
        { type = "note", title = "Optional dungeons/groups (30s)", note = "Scarlet Monastery wings, Razorfen Downs, Gnomeregan (if still useful), or other groups can provide strong XP/gear bursts if efficient. Use them to supplement questing, not replace a stalled plan." },
        { type = "level", level = 36, title = "Reach level 36 (late-30s checkpoint)", zone = "Stranglethorn Vale", note = "Checkpoint: focus on high-value chains that naturally lead into 40+ zones. Clear quest log clutter and keep only relevant follow-ups." },
        { type = "train", title = "Train class skills (36-38)", note = "Train and restock for tougher mobs and longer routes. Upgrade gear where practical." },
        { type = "note", title = "Late 30s wrap-up (36-40)", zone = "Desolace", note = "Finish efficient Arathi/Desolace/STV leftovers and gather breadcrumbs for 40+ zones (Badlands, Swamp of Sorrows, Tanaris, Feralas, or Hinterlands) as verified on WoW Forever." },
        { type = "level", level = 40, title = "Reach level 40 (milestone)", zone = "Stranglethorn Vale", note = "Milestone reached. Use /flg continue for the next scaffold (40-50)." },
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
        { type = "note", title = "Scaffold route (WIP, original)", zone = "Tanaris", note = "Structured 40-50 Alliance skeleton compared at a high level to established leveling-guide flow (Badlands/Swamp early 40s, Tanaris/Feralas/Hinterlands mid-late 40s, with Searing Gorge/Felwood/Azshara entry options late). Original checklist scaffold - verify hubs, chains, travel, and quest/map details on WoW Forever; add verified quest IDs/coords." },
        { type = "note", title = "Plan your 40s route (region choice)", note = "Common options: Badlands and/or Swamp of Sorrows around 40-43, Tanaris mid 40s, Feralas and/or Hinterlands mid-late 40s, with Searing Gorge or other high-40s hubs near the end. Prioritize dense, in-level chains and manageable travel." },
        { type = "train", title = "Train class skills (40)", note = "Train milestone upgrades and restock. Review gear and consumables for longer circuits." },
        { type = "note", title = "Early 40s hubs: Badlands / Swamp of Sorrows (40-43)", zone = "Badlands", note = "Work Badlands and/or Swamp of Sorrows circuits if available and efficient. Bundle objectives by area, watch for elite zones, and use groups for elite/dungeon quests when worthwhile." },
        { type = "level", level = 42, title = "Reach level 42 (checkpoint)", zone = "Badlands", note = "Checkpoint: keep quest selection efficient (prefer yellow chains in one region). Drop overly grindy or high-travel tasks if better options exist." },
        { type = "train", title = "Train class skills (42-44)", note = "Train and repair before transitioning to desert/jungle regions." },
        { type = "note", title = "Tanaris circuits (43-46)", zone = "Tanaris", note = "Use Gadgetzan and nearby Alliance/neutral quest hubs as available. Complete circuits in loops to reduce travel, group related objectives, and handle dangerous areas carefully." },
        { type = "level", level = 44, title = "Reach level 44 (checkpoint)", zone = "Tanaris", note = "Checkpoint: decide between continuing Tanaris, moving to Feralas, or starting Hinterlands chains based on available in-level quests." },
        { type = "note", title = "Optional dungeons/groups (40s)", note = "Zul'Farrak, Maraudon, Uldaman, or other dungeon groups can provide strong XP/loot bursts if efficient and quest-aligned. Optional; balance with steady questing." },
        { type = "note", title = "Feralas and/or Hinterlands (44-48)", zone = "Feralas", note = "Feathermoon Stronghold/Feralas loops and Aerie Peak/Hinterlands chains can be strong in this range. Group objectives by region, use flight paths where available, and handle elite quests with parties." },
        { type = "level", level = 46, title = "Reach level 46 (late-40s checkpoint)", zone = "The Hinterlands", note = "Checkpoint: target chains that naturally lead into 50+ zones. Clear out low-value leftovers and keep follow-ups for your next region." },
        { type = "train", title = "Train class skills (46-48)", note = "Train and prepare for higher-level zones with tougher mobs." },
        { type = "note", title = "Late 40s wrap-up and 50+ entry (46-50)", zone = "The Hinterlands", note = "Finish best remaining Tanaris/Feralas/Hinterlands chains. Begin Searing Gorge, Felwood, Azshara, or other high-40s/early-50s hubs if unlocked and efficient on WoW Forever." },
        { type = "level", level = 50, title = "Reach level 50 (milestone)", zone = "Tanaris", note = "Milestone reached. Use /flg continue for the final scaffold (50-60)." },
    },
})

ns:RegisterGuide("alliance_50_60_ungoro_felwood_burning_steppes_scaffold", {
    title = "Alliance 50-60: Felwood / Un'Goro / Plaguelands / Silithus (Scaffold)",
    faction = "Alliance",
    minLevel = 50,
    maxLevel = 60,
    scaffold = true,
    steps = {
        { type = "note", title = "Scaffold route (WIP, original)", zone = "Un'Goro Crater", note = "Structured 50-60 Alliance skeleton compared at a high level to established leveling-guide flow (Felwood/Un'Goro/Winterspring mid 50s, Western/Eastern Plaguelands and Burning Steppes/Silithus options late). Original checklist scaffold - verify endgame hub progression, travel, and quest/map details on WoW Forever; add verified quest IDs/coords." },
        { type = "note", title = "Plan your 50s route (region choice)", note = "Common options: Searing Gorge/Burning Steppes/Felwood leftovers around 50-53, Un'Goro Crater and Winterspring mid 50s, Western/Eastern Plaguelands late 50s, with Silithus near cap if available. Mix questing and dungeons based on group availability and efficiency." },
        { type = "train", title = "Train class skills (50)", note = "Train key abilities and ensure gear, consumables, and bags are ready for longer circuits and tougher mobs." },
        { type = "note", title = "Early 50s hubs (50-53)", zone = "Felwood", note = "Work Felwood and/or Burning Steppes, Searing Gorge leftovers as available. Prioritize dense chains and avoid low-value cross-zone travel. Pick up dungeon breadcrumbs if they fit your plan." },
        { type = "level", level = 52, title = "Reach level 52 (checkpoint)", zone = "Felwood", note = "Checkpoint: rotate to Un'Goro, Winterspring, or other strong zones based on remaining in-level quests." },
        { type = "note", title = "Un'Goro Crater circuits (52-55)", zone = "Un'Goro Crater", note = "Run Un'Goro crater loops where objectives overlap efficiently. Use available flight paths/hearth placement to reduce downtime, and batch turn-ins at hubs. Group for elite objectives when practical." },
        { type = "note", title = "Winterspring option (52-56)", zone = "Winterspring", note = "Winterspring chains can complement or replace parts of Un'Goro depending on quest availability and travel. Stay with the zone that offers the best cluster of yellow quests for your character." },
        { type = "train", title = "Train class skills (54-56)", note = "Train and restock for tougher areas and potential dungeon groups." },
        { type = "level", level = 55, title = "Reach level 55 (checkpoint)", zone = "Un'Goro Crater", note = "Checkpoint: begin steering toward late-50s Plaguelands and endgame-prep chains while finishing high-value mid-50s objectives." },
        { type = "note", title = "Western Plaguelands (55-57)", zone = "Western Plaguelands", note = "Follow hub circuits and complete strong late-leveling chains. Handle elite areas with groups when needed, and keep travel efficient by batching objectives and turn-ins." },
        { type = "note", title = "Eastern Plaguelands and Burning Steppes options (56-58)", zone = "Eastern Plaguelands", note = "Move into Eastern Plaguelands and/or Burning Steppes chains as level/quests allow. Pick up relevant dungeon breadcrumbs (Stratholme/Scholomance/BRD/UBRS) if they support your leveling or pre-endgame goals." },
        { type = "train", title = "Train class skills (58)", note = "Final pre-cap upgrades. Stock consumables for tougher zones and instance runs." },
        { type = "level", level = 58, title = "Reach level 58 (late-leveling checkpoint)", zone = "Eastern Plaguelands", note = "Checkpoint: focus on EPL, Winterspring leftovers, Silithus (if in range), and efficient dungeon runs to close the final gap." },
        { type = "note", title = "Final push to 60 (58-60)", zone = "Eastern Plaguelands", note = "Complete the highest-value remaining quest chains. Dungeon groups can replace or complement questing - choose the fastest, safest option for your character, group availability, and WoW Forever pacing." },
        { type = "note", title = "Silithus / endgame prep (optional)", zone = "Silithus", note = "If available and in range, do Silithus intro/chains and prepare for endgame activities. Verify all requirements, reputations, and unlocks on WoW Forever." },
        { type = "level", level = 60, title = "Reach level 60 (leveling complete)", note = "Leveling complete. Refine this scaffold with verified quest IDs/mapIDs/coords/NPCs for a polished, server-accurate route. Congratulations!" },
    },
})
