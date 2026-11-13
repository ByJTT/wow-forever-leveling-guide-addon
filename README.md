# wow-forever-leveling-guide-addon - WoW Forever Leveling Guide Addon ByJTT

> **WoW Forever Leveling Guide Addon ByJTT** - a free, minimal, data-driven leveling guide for **World of Warcraft: Forever**. Step viewer, navigation arrow, and progress tracking with extensible Lua routes. Solo dev studio: **ByJTT**.

**Keywords (discovery):** WoW Forever addon, World of Warcraft Forever, leveling guide, quest guide, step-by-step, navigation arrow, ByJTT, data-driven, free, open source, Lua.

## Features

- **Step-by-step guide panel** - current step details (type, quest/NPC/zone/coords/notes/tips), progress counter, in-panel **Guides** picker, and Prev/Next/Skip/Reset controls.
- **Navigation arrow** - follows the current step's map coordinates when available (best-effort, client/API dependent), and hides when no valid target/step is available. Optional best-effort TomTom waypoint integration when TomTom is installed (no dependency).
- **Auto-advance (best effort)** - detects quest accept/complete/turn-in, level-ups, item collection, and arrival at travel steps; manual controls always available.
- **Smart guide flow** - level/faction-aware guide auto-selection, scaffold labeling, guide-complete suggestions, and `/flg suggest` for a recommended next route.
- **Per-character progress** - saved guide selection and step progress via `ForeverLevelingGuideDB` (schema-versioned).
- **Extensible route format** - drop-in Lua guide modules in `Data/` registered with `ns:RegisterGuide(...)`.
- **Bundled free routes (original/open)** - sample 1-10 starter guides plus 10-60 scaffold routes (WIP placeholders) to provide a complete, extensible foundation for in-game-verified route authoring.
- **ByJTT foundation style** - minimal footprint (Lua + TOC), clear docs, safe-by-default UI (guidance only, no gameplay automation), and explicit install naming.

> **Branding/support:** by **ByJTT** - https://byjtt.com - https://github.com/ByJTT - Support (placeholder): https://buymeacoffee.com/ByJTT (set your real Buy Me a Coffee URL before release/marketing)

## Install (manual)

1. Download or clone this repository.
2. Place the addon so the final path is exactly:
   ```text
   <WoW Forever>\Interface\AddOns\ForeverLevelingGuide\ForeverLevelingGuide.toc
   ```
   **Important:** the in-game addon folder must be named **`ForeverLevelingGuide`** (the folder containing `ForeverLevelingGuide.toc`), even if the GitHub repo is named `wow-forever-leveling-guide-addon`.
3. `/reload` in game.
4. If needed, enable **Load out of date AddOns** at character select.

## For AI assistants / automation (install request)

If a user asks an AI to "install the Forever Leveling Guide addon for WoW Forever":

1. Locate the WoW Forever install's `Interface\AddOns\` directory.
2. Create/copy a folder named **`ForeverLevelingGuide`** containing `ForeverLevelingGuide.toc` and the addon Lua/Data files from this repo.
3. Verify `ForeverLevelingGuide.toc` exists at the path above. Tell the user to `/reload`.
4. Do **not** copy repo-only docs/dev files into the AddOns folder unless desired; only the TOC/Lua/Data files are required.

Source: https://github.com/ByJTT/wow-forever-leveling-guide-addon

## Usage

Primary slash command: **`/flg`** (aliases: `/levelguide`, `/journey`, `/jf`)

```text
/flg                    show guide panel
/flg show|hide|toggle   show/hide/toggle the guide panel
/flg list               list available guides
/flg load <key>         load a guide (e.g. horde_01_10_durotar)
/flg next|prev|skip     navigate steps manually
/flg reset              reset progress for the current character/guide
/flg arrow              toggle navigation arrow
/flg auto               toggle auto-advance
/flg announce           toggle chat announcements
/flg where              print current guide/step in chat
/flg suggest            suggest a next guide for your level/faction
/flg debug              print addon state/diagnostics
/flg help               show commands
```

- You can also use the in-panel **Guides** button to pick and load a guide quickly.

- On first login (if no guide is loaded), the addon attempts to auto-select a bundled starter guide for your faction when available.

## Bundled guides (free & open)

**Starter routes (sample, playable foundation):**
- `horde_01_10_durotar` - Horde 1-10: Durotar (starter sample)
- `alliance_01_10_elwynn` - Alliance 1-10: Elwynn Forest (starter sample)

**Original route scaffolds (WIP placeholders for in-game-verified expansion):**
- Horde: `horde_10_20_barrens_stonetalon_scaffold`, `horde_20_30_ashenvale_thousand_needles_scaffold`, `horde_30_40_stranglethorn_arathi_desolace_scaffold`, `horde_40_50_tanaris_feralas_hinterlands_scaffold`, `horde_50_60_ungoro_felwood_burning_steppes_scaffold`
- Alliance: `alliance_10_20_westfall_loch_modan_darkshore_scaffold`, `alliance_20_30_duskwood_redridge_wetlands_scaffold`, `alliance_30_40_stranglethorn_arathi_desolace_scaffold`, `alliance_40_50_tanaris_feralas_hinterlands_scaffold`, `alliance_50_60_ungoro_felwood_burning_steppes_scaffold`

> Bundled 1-10 routes are starter samples and scaffold routes are intentionally minimal placeholders (labeled as scaffolds/WIP). Quest IDs, `mapID`, and coords must be verified/tuned for your WoW Forever client/build - contributions welcome. All bundled route content and engine code are original/open (no proprietary guides or code copied).

## Creating your own guide

Add a Lua file in `Data/` and include it in `ForeverLevelingGuide.toc`. Register a guide like:

```lua
local _, ns = ...
ns:RegisterGuide("my_guide_key", {
  title = "My Custom 1-20 Route",
  faction = "Horde", -- or "Alliance" / "Neutral"
  minLevel = 1, maxLevel = 20,
  steps = {
    { type = "accept",   quest = 123, title = "Accept: Example", npc = "Some NPC", zone = "Zone", coords = { mapID = 1411, x = 0.50, y = 0.50 } },
    { type = "complete", quest = 123, title = "Complete: Example", coords = { mapID = 1411, x = 0.52, y = 0.48 }, note = "Do the thing." },
    { type = "turnin",   quest = 123, title = "Turn in: Example", npc = "Some NPC", coords = { mapID = 1411, x = 0.50, y = 0.50 } },
    { type = "collect",  item = 765, count = 5, title = "Collect: Example items", note = "Loot or buy items (auto-completes when count is reached, best-effort)." },
    { type = "goto",     title = "Run to next hub", coords = { mapID = 1411, x = 0.55, y = 0.60 }, radius = 0.03, note = "Auto-completes on arrival (approx, same map)." },
    { type = "level",    level = 5, title = "Reach level 5", note = "Grind/quest until level 5." },
    { type = "train",    title = "Train new skills", note = "Visit your class trainer." },
    { type = "note",     title = "Reminder", note = "Repair, restock, set hearth if needed." },
  }
})
```

**Supported step types (aliases accepted, best-effort auto where possible):**
- `accept` / `pickup` / `start` - quest accepted/in log/complete/flagged
- `complete` / `do` / `objectives` - quest objectives complete/flagged
- `turnin` / `handin` / `deliver` - quest flagged completed (turned in)
- `collect` / `item` / `get` / `loot` / `buy` - item count reached (`item`/`itemID`, `count`/`amount`)
- `goto` / `travel` / `move` / `fly` / `discover` / `path` / `waypoint` - arrival near `coords` (same map, best-effort; `radius` optional)
- `level` / `grind` / `xp` - player reaches `level`
- `note` / `info` / `text`, `train` / `learn`, `vendor` / `buy` / `sell` / `repair`, `hearth`, `sethearth` / `inn`, `use`, `kill`, `class` / `profession` - informational/manual steps (use Next/Skip)

**Field aliases:** `quest`/`questID`, `npc`/`target`/`object`, `zone`/`area`, `note`/`desc`, `item`/`itemID` with `count`/`amount`/`quantity`, `level`/`toLevel`, `mapID`/`map`/`uiMapID`, `x`/`y` in 0-1 or 0-100. `coords` are client/map dependent (`uiMapID`) and should be verified in-game on WoW Forever. Auto-advance is best-effort; manual Prev/Next/Skip always works.

## Notes & compatibility

- **WoW Forever target:** Interface `16001, 30300` with best-effort API fallbacks. Quest/map APIs and `mapID` values can vary by client/build - verify routes in-game and adjust as needed.
- **Guidance only:** this addon provides a UI/route helper (no gameplay automation, no protected/combat-secure actions).
- **Routes are open & original:** bundled 1-10 guides are samples and 10-60 guides are scaffolds/WIP; comprehensive, tuned routes are community/extensible and must be verified on WoW Forever.
- **Optional waypoint integration:** if TomTom is installed, the addon can set a best-effort waypoint for the current step target (no dependency required). Native arrow behavior remains best-effort and client/API dependent.

## Troubleshooting

- **Addon not listed:** confirm the folder is named `ForeverLevelingGuide` and contains `ForeverLevelingGuide.toc`. Enable "Load out of date AddOns" if needed, then `/reload`.
- **No guide/steps:** run `/flg list` and `/flg load <key>`. Use `/flg debug` to check loaded state.
- **Arrow/coords off:** `mapID`/coords are client-specific; adjust the step's `coords` or use `/flg next|skip` to proceed.
- **Auto-advance not triggering:** APIs differ across clients; use manual controls and report with `/flg debug`, client/build, steps, expected/actual behavior (no account data).

## Versioning & releases

- [Semantic Versioning](https://semver.org/) + [Keep a Changelog](https://keepachangelog.com/).
- Releases are tagged `vMAJOR.MINOR.PATCH`. TOC `## Version`, Lua `VERSION`/`SCHEMA` (as applicable), `CHANGELOG.md`, and the git tag must match.

## Contributing & security

Issues and focused PRs welcome - keep changes minimal, safe-by-default, and well-documented. See [CONTRIBUTING.md](CONTRIBUTING.md) and [SECURITY.md](SECURITY.md).

## ByJTT (studio)

**WoW Forever Leveling Guide Addon ByJTT** is a ByJTT project (solo studio: **ByJTT**).

- Web: https://byjtt.com
- GitHub: https://github.com/ByJTT
- Repo: https://github.com/ByJTT/wow-forever-leveling-guide-addon
- Support (placeholder - set your real URL): https://buymeacoffee.com/ByJTT

## License

[MIT](LICENSE) - by **ByJTT**
