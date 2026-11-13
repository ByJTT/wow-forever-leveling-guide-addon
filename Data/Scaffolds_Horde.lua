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
        { type = "note", title = "Scaffold route (WIP, original)", zone = "The Barrens", note = "Structured 10-20 Horde skeleton compared at a high level to established leveling-guide flow (Barrens core with a possible mid-teens Stonetalon detour). Use this as an original pacing/checklist scaffold - verify quest availability, turn-ins, travel, and any map/quest details on WoW Forever before adding quest IDs and coords." },
        { type = "note", title = "Prep before leaving town", zone = "The Barrens", note = "Repair, restock food/water/ammo/reagents, clear bags, and confirm class reagents/totems as needed. Train professions/secondary skills in a capital if convenient, but avoid long detours that cost more time than they save." },
        { type = "train", title = "Train class skills (level 10)", note = "Pick up key level-10 abilities/talents. Even small upgrades improve kill speed and safety for the next bracket." },
        { type = "note", title = "Establish Crossroads as your main hub", zone = "The Barrens", npc = "Crossroads innkeeper and questgivers", note = "Travel to the Crossroads area if you are not there already. Set hearth if practical, grab the flight path when available, and pick up all available local quests. Plan to work objectives in loops and return for batch turn-ins." },
        { type = "note", title = "Crossroads local circuits (10-12)", zone = "The Barrens", note = "Complete nearby Crossroads-area quest chains in compact circuits (group kill/collect objectives that share locations). Skip overcrowded, elite, or inefficient camps for now and revisit later if they become convenient." },
        { type = "level", level = 12, title = "Reach level 12 (checkpoint)", zone = "The Barrens", note = "Checkpoint: vendor junk, repair, restock, and turn in completed quests in batches. Pick up follow-ups that stay in the same sub-area." },
        { type = "train", title = "Train class skills (12, if needed)", note = "Train if you are near a trainer and upgrades are meaningful; otherwise keep momentum and train at the next convenient stop." },
        { type = "note", title = "Crossroads follow-ups and Ratchet options (12-14)", zone = "The Barrens", note = "Continue efficient Crossroads chains and include Ratchet-area tasks only if they fit your route on WoW Forever. Avoid long single-purpose runs; prefer clusters of objectives and turn-ins." },
        { type = "note", title = "Optional group content (Wailing Caverns / RFC)", zone = "The Barrens", note = "If a good group forms, Ragefire Chasm or Wailing Caverns can supplement XP/gear. Treat dungeons as optional breaks - questing remains the baseline path in this scaffold." },
        { type = "level", level = 14, title = "Reach level 14 (checkpoint)", zone = "The Barrens", note = "Checkpoint: reassess quest density. If Barrens quests are thinning, prepare a mid-teens detour (often Stonetalon) while keeping travel efficient." },
        { type = "train", title = "Train class skills (14)", note = "Train before longer travel or tougher camps. Restock consumables and ammo/reagents." },
        { type = "note", title = "Stonetalon Mountains detour (14-16, if efficient)", zone = "Stonetalon Mountains", note = "Follow available breadcrumbs to Stonetalon (commonly Sun Rock Retreat area) when quest levels and travel are favorable. Do compact local circuits, then return to Barrens follow-ups as directed. If this detour is inefficient on your server, stay in Barrens." },
        { type = "note", title = "Stonetalon hub routine (if visited)", zone = "Stonetalon Mountains", note = "At your Stonetalon hub, pick up all local quests, check flight path/hearth options if useful, and prioritize short loops over back-and-forth travel. Defer elite/group quests unless a party is ready." },
        { type = "level", level = 16, title = "Reach level 16 (checkpoint)", zone = "Stonetalon Mountains", note = "Checkpoint: finish nearby chains and plan your return/wrap-up path. Avoid abandoning almost-complete local objectives." },
        { type = "train", title = "Train class skills (16)", note = "Train and restock. Update hearth to the hub you will use most for the remainder of this bracket." },
        { type = "note", title = "Southern/central Barrens wrap-up (16-18)", zone = "The Barrens", note = "Work Camp Taurajo and other southern/central Barrens chains as level-appropriate. Combine objectives by area, complete escort/group steps with help when efficient, and turn in batches." },
        { type = "level", level = 18, title = "Reach level 18 (checkpoint)", zone = "The Barrens", note = "Checkpoint: prioritize orange/yellow quests that keep you in one region. Drop or postpone low-value, long-travel tasks." },
        { type = "train", title = "Train class skills (18)", note = "Train before the final push to 20 so combat remains smooth and downtime stays low." },
        { type = "note", title = "Final push to 20 (18-20)", zone = "The Barrens", note = "Complete the most efficient remaining Barrens/Stonetalon quests. If options are limited, grind safely on mobs near your active objectives/hub. Prepare for 20+ transitions (Stonetalon follow-ups, Ashenvale, Southern Barrens, or Thousand Needles) based on verified WoW Forever quest flow." },
        { type = "level", level = 20, title = "Reach level 20 (milestone)", zone = "The Barrens", note = "Milestone reached. Use /flg continue to load the next scaffold (20-30) and refine this route with WoW Forever-verified quest IDs, mapIDs, coords, and NPC details." },
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
        { type = "note", title = "Scaffold route (WIP, original)", zone = "Stonetalon Mountains", note = "Structured 20-30 Horde skeleton compared at a high level to established leveling-guide flow (Stonetalon/Ashenvale early, Southern Barrens mid 20s, Thousand Needles late 20s, with Hillsbrad alternatives). Original checklist scaffold - verify hub order, chains, travel, and quest/map details on WoW Forever before adding IDs/coords." },
        { type = "note", title = "Plan your 20-30 bracket", note = "Pick 1-2 active zones at a time. Common path: early 20s in Stonetalon and/or Ashenvale, mid 20s in Southern Barrens plus Stonetalon follow-ups, late 20s in Thousand Needles (or Hillsbrad/Ashenvale leftovers) depending on quest density and travel efficiency." },
        { type = "train", title = "Train class skills (20)", note = "Train milestone abilities, update talents, and restock before traveling to your first 20+ hub." },
        { type = "note", title = "Stonetalon and/or Ashenvale start (20-22)", zone = "Stonetalon Mountains", note = "Work Sun Rock Retreat/Stonetalon circuits and/or Splintertree Post-area Ashenvale chains when efficient. Pick up all local quests, complete objectives in loops, and batch turn-ins to minimize cross-zone travel." },
        { type = "level", level = 22, title = "Reach level 22 (checkpoint)", zone = "Ashenvale", note = "Checkpoint: turn in batches, take follow-ups that stay local, and choose the next hub based on in-level quest density." },
        { type = "train", title = "Train class skills (22-24)", note = "Train when convenient and keep consumables stocked. Avoid long trainer detours unless multiple upgrades justify it." },
        { type = "note", title = "Southern Barrens and Stonetalon follow-ups (22-25)", zone = "The Barrens", note = "Return to Camp Taurajo/Southern Barrens and remaining Stonetalon quests as appropriate. Prioritize compact chains; handle elites/escorts with groups or defer if inefficient." },
        { type = "note", title = "Optional dungeons (22-26)", zone = "The Barrens", note = "Blackfathom Deeps or Shadowfang Keep runs can be good XP/loot breaks if groups are efficient and quests align. Optional - do not let queue/wait time stall leveling momentum." },
        { type = "level", level = 25, title = "Reach level 25 (midpoint)", zone = "The Barrens", note = "Midpoint checkpoint: compare Thousand Needles, Ashenvale, Hillsbrad, and remaining Barrens/Stonetalon options. Move to the hub with the best cluster of yellow quests." },
        { type = "train", title = "Train class skills (24-26)", note = "Train upgrades and repair before longer circuits or a zone transition." },
        { type = "note", title = "Transition to Thousand Needles (25-27, common path)", zone = "Thousand Needles", note = "Travel to Thousand Needles when quest levels fit (often mid/late 20s). Establish a hub routine (inn/flight path when available), pick up local quests, and complete desert circuits in loops." },
        { type = "level", level = 27, title = "Reach level 27 (checkpoint)", zone = "Thousand Needles", note = "Checkpoint: focus on efficient kill/collect chains and nearby turn-ins. Defer quests that require excessive backtracking across the zone." },
        { type = "train", title = "Train class skills (26-28)", note = "Train and restock. Consider hearth placement at the hub you will use for the final stretch of this bracket." },
        { type = "note", title = "Late 20s wrap-up and alternatives (27-30)", zone = "Thousand Needles", note = "Finish strong Thousand Needles chains and/or Ashenvale/Hillsbrad leftovers depending on what is efficient on WoW Forever. Keep quest log organized: complete/turn in local clusters before moving on." },
        { type = "note", title = "Prepare for 30+ transitions", note = "Common 30+ options include Hillsbrad/Arathi, Stranglethorn Vale, Desolace, or continued regional chains. Pick up breadcrumb/lead-in quests only when they align with your next hub." },
        { type = "train", title = "Train class skills (30)", note = "Train milestone abilities before entering higher-level zones." },
        { type = "level", level = 30, title = "Reach level 30 (milestone)", zone = "Thousand Needles", note = "Milestone reached. Use /flg continue for the next scaffold (30-40) and tune routes with verified WoW Forever data." },
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
        { type = "note", title = "Scaffold route (WIP, original)", zone = "Stranglethorn Vale", note = "Structured 30-40 Horde skeleton compared at a high level to established leveling-guide flow (Hillsbrad/Arathi, Desolace, and Stranglethorn Vale options with bracket flexibility). Original checklist scaffold - verify hubs, chains, travel, and map/quest details on WoW Forever; add verified quest IDs/coords." },
        { type = "note", title = "Plan your 30s route (region choice)", note = "Common options: Hillsbrad early 30s, Arathi and/or Desolace mid 30s, Stranglethorn Vale across much of the bracket (with travel awareness), plus any efficient Thousand Needles/Shimmering Flats leftovers. Choose by quest density, safety, and flight/travel access." },
        { type = "train", title = "Train class skills (30)", note = "Train important upgrades and refresh consumables before longer circuits and contested travel." },
        { type = "note", title = "Early 30s hub: Hillsbrad foothills (30-33)", zone = "Hillsbrad Foothills", note = "Work Tarren Mill/Hillsbrad-area chains if efficient. In contested regions, stay alert to PvP risk and avoid overcommitting to slow camps. Batch objectives by sub-area and turn in together." },
        { type = "level", level = 33, title = "Reach level 33 (checkpoint)", zone = "Hillsbrad Foothills", note = "Checkpoint: complete/turn in local chains, repair, and decide whether to continue Hillsbrad, move to Arathi/Desolace, or begin STV circuits." },
        { type = "train", title = "Train class skills (32-34)", note = "Train and repair before switching regions or starting longer STV loops." },
        { type = "note", title = "Mid 30s option: Arathi Highlands (33-36)", zone = "Arathi Highlands", note = "Use Hammerfall-area hubs/chains if available and in-level. Do compact circuits, combine kill/collect objectives, and bring a group for elite steps when worthwhile. Leave if quests become sparse or over-leveled." },
        { type = "note", title = "Mid 30s option: Desolace (33-36)", zone = "Desolace", note = "Desolace can offer efficient mid-30s chains at Horde hubs (verify availability on WoW Forever). Prioritize clustered objectives and avoid cross-zone errands that break momentum." },
        { type = "note", title = "Stranglethorn Vale circuits (33-38)", zone = "Stranglethorn Vale", note = "STV often spans several levels: work Grom'gol and nearby chains in sub-area batches to reduce travel. Be selective with deep-penetration or contested objectives; neutral turn-ins only when efficient." },
        { type = "note", title = "Optional dungeons/groups (30s)", note = "Scarlet Monastery wings, Razorfen Downs, or other groups can provide strong XP/gear bursts if efficient. Use them to supplement questing, not replace a stalled plan." },
        { type = "level", level = 36, title = "Reach level 36 (late-30s checkpoint)", zone = "Stranglethorn Vale", note = "Checkpoint: focus on high-value chains that naturally lead into 40+ zones. Clear quest log clutter and keep only relevant follow-ups." },
        { type = "train", title = "Train class skills (36-38)", note = "Train and restock for tougher mobs and longer routes. Upgrade gear where practical." },
        { type = "note", title = "Late 30s wrap-up (36-40)", zone = "Desolace", note = "Finish efficient Arathi/Desolace/STV leftovers and gather breadcrumbs for 40+ zones (Badlands, Swamp of Sorrows, Dustwallow-adjacent options, Tanaris, or Feralas) as verified on WoW Forever." },
        { type = "level", level = 40, title = "Reach level 40 (milestone)", zone = "Stranglethorn Vale", note = "Milestone reached. Use /flg continue for the next scaffold (40-50)." },
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
        { type = "note", title = "Scaffold route (WIP, original)", zone = "Tanaris", note = "Structured 40-50 Horde skeleton compared at a high level to established leveling-guide flow (Badlands/Swamp early 40s, Tanaris/Feralas/Hinterlands mid-late 40s, with Searing Gorge/Azshara/Felwood entry options late). Original checklist scaffold - verify hubs, chains, travel, and quest/map details on WoW Forever; add verified quest IDs/coords." },
        { type = "note", title = "Plan your 40s route (region choice)", note = "Common options: Badlands and/or Swamp of Sorrows around 40-43, Tanaris mid 40s, Feralas and/or Hinterlands mid-late 40s, with Searing Gorge or other high-40s hubs near the end. Prioritize dense, in-level chains and manageable travel." },
        { type = "train", title = "Train class skills (40)", note = "Train milestone upgrades and restock. Review gear and consumables for longer circuits." },
        { type = "note", title = "Early 40s hubs: Badlands / Swamp of Sorrows (40-43)", zone = "Badlands", note = "Work Badlands and/or Swamp of Sorrows circuits if available and efficient. Bundle objectives by area, watch for elite zones, and use groups for elite/dungeon quests when worthwhile." },
        { type = "level", level = 42, title = "Reach level 42 (checkpoint)", zone = "Badlands", note = "Checkpoint: keep quest selection efficient (prefer yellow chains in one region). Drop overly grindy or high-travel tasks if better options exist." },
        { type = "train", title = "Train class skills (42-44)", note = "Train and repair before transitioning to desert/jungle regions." },
        { type = "note", title = "Tanaris circuits (43-46)", zone = "Tanaris", note = "Use Gadgetzan and nearby Horde/neutral quest hubs as available. Complete circuits in loops to reduce travel, group related objectives, and handle dangerous areas carefully." },
        { type = "level", level = 44, title = "Reach level 44 (checkpoint)", zone = "Tanaris", note = "Checkpoint: decide between continuing Tanaris, moving to Feralas, or starting Hinterlands chains based on available in-level quests." },
        { type = "note", title = "Optional dungeons/groups (40s)", note = "Zul'Farrak, Maraudon, Uldaman, or other dungeon groups can provide strong XP/loot bursts if efficient and quest-aligned. Optional; balance with steady questing." },
        { type = "note", title = "Feralas and/or Hinterlands (44-48)", zone = "Feralas", note = "Camp Mojache/Feralas loops and Revantusk Village/Hinterlands chains can be strong in this range. Group objectives by region, use flight paths where available, and handle elite quests with parties." },
        { type = "level", level = 46, title = "Reach level 46 (late-40s checkpoint)", zone = "The Hinterlands", note = "Checkpoint: target chains that naturally lead into 50+ zones. Clear out low-value leftovers and keep follow-ups for your next region." },
        { type = "train", title = "Train class skills (46-48)", note = "Train and prepare for higher-level zones with tougher mobs." },
        { type = "note", title = "Late 40s wrap-up and 50+ entry (46-50)", zone = "The Hinterlands", note = "Finish best remaining Tanaris/Feralas/Hinterlands chains. Begin Searing Gorge, Azshara, Felwood, or other high-40s/early-50s hubs if unlocked and efficient on WoW Forever." },
        { type = "level", level = 50, title = "Reach level 50 (milestone)", zone = "Tanaris", note = "Milestone reached. Use /flg continue for the final scaffold (50-60)." },
    },
})

ns:RegisterGuide("horde_50_60_ungoro_felwood_burning_steppes_scaffold", {
    title = "Horde 50-60: Felwood / Un'Goro / Plaguelands / Silithus (Scaffold)",
    faction = "Horde",
    minLevel = 50,
    maxLevel = 60,
    scaffold = true,
    steps = {
        { type = "note", title = "Scaffold route (WIP, original)", zone = "Un'Goro Crater", note = "Structured 50-60 Horde skeleton compared at a high level to established leveling-guide flow (Felwood/Un'Goro/Winterspring mid 50s, Western/Eastern Plaguelands and Burning Steppes/Silithus options late). Original checklist scaffold - verify endgame hub progression, travel, and quest/map details on WoW Forever; add verified quest IDs/coords." },
        { type = "note", title = "Plan your 50s route (region choice)", note = "Common options: Azshara/Felwood/Burning Steppes/Searing Gorge leftovers around 50-53, Un'Goro Crater and Winterspring mid 50s, Western/Eastern Plaguelands late 50s, with Silithus near cap if available. Mix questing and dungeons based on group availability and efficiency." },
        { type = "train", title = "Train class skills (50)", note = "Train key abilities and ensure gear, consumables, and bags are ready for longer circuits and tougher mobs." },
        { type = "note", title = "Early 50s hubs (50-53)", zone = "Felwood", note = "Work Felwood and/or Azshara, Burning Steppes, or Searing Gorge leftovers as available. Prioritize dense chains and avoid low-value cross-zone travel. Pick up dungeon breadcrumbs if they fit your plan." },
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

