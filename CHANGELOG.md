# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- **Original open route scaffolds (1-60 foundation):** added bundled Horde and Alliance scaffold guides for 10-20, 20-30, 30-40, 40-50, and 50-60 brackets (WIP placeholders, marked `scaffold=true`) with structured, original step-by-step skeletons (hubs, checkpoints, training, circuits, optional groups, transitions) to provide a clean, extensible structure for in-game-verified route authoring on WoW Forever.
- **Guide chaining & continue flow:** added `next` guide links across bundled starter/scaffold routes (1-10 -> 10-20 -> ... -> 60), `GetNextGuideKey` resolution (faction-aware, case-insensitive), and `/flg continue` to load the next/suggested guide; guide-complete suggestions now prefer the chained next route. At end-of-guide, the panel Next button and `/flg next` can continue into the next/suggested guide when available.
- **Guide picker UI:** added an in-panel **Guides** button and lightweight guide selector for quickly loading available routes.
- **Guide suggestions & smarter selection:** added `/flg suggest` (and guide-complete next suggestions in UI/chat) plus level/faction-aware auto-selection that prefers in-range, non-scaffold routes when available.
- **Arrow integration & optional waypoint:** navigation arrow now initializes/syncs with profile state and follows the current step's coordinates (best-effort, client/API dependent), hiding when unavailable/complete. Optional best-effort TomTom waypoint integration for the current step target when TomTom is installed (no dependency), with reduced waypoint churn when targets are unchanged.
- **In-game debug export:** added `/flg debug export` and a copyable debug report dialog (client/build, player/map/zone/coords, guide/step/arrow state, step satisfaction/arrival context) to accelerate WoW Forever verification and tuning.
- **Offline guide validator:** added `tools/validate_guides.py` for lightweight structural checks of bundled route data, guide chain integrity, TOC/data coverage, and common authoring issues before in-game testing (no in-game validation).

### Changed
- **Scaffold route refinement (relative to established guides):** refined 10-60 Horde/Alliance scaffolds with bracket progression compared at a high level to established leveling-guide flow (pacing, zone/hub order, checkpoints, train breaks, optional dungeons, and transitions) while keeping all step text/structure original/clean-room. Scaffolds remain WIP placeholders pending WoW Forever verification (no real in-game data/tuning in this pass).
- **Step engine (clean-room, simplified/expanded):** broader step type and field alias support (e.g. accept/pickup, complete/objectives, turnin, goto/travel/move/fly/discover/path/waypoint, level/grind, collect/item/get/buy, note/info, train, vendor/repair, hearth/sethearth/inn, use/kill/class/profession), safer quest/log and item-count checks with API fallbacks, and clearer manual vs auto-advance behavior.
- **Step navigation:** `PrevStep` now clears completion/skipped state for the target step and later steps so users can review/re-do from that point, then re-evaluates naturally (auto-completes again only if conditions are still satisfied). Guide loading also accepts case-insensitive keys for convenience.
- **Travel/arrival tracking:** improved coordinate normalization and arrival detection (configurable `radius`, best-effort same-map checks), additional event/ticker evaluation (including bag updates) for more reliable auto-advance across clients.
- **UI/status polish:** richer step rendering (type labels, quest/item/level/NPC/zone/coords/notes/tips), scaffold labeling in list/picker/subtitle, improved no-guide/empty/complete states and hints (including chained "next guide" suggestions and `/flg continue`), and clearer diagnostics/debug/status output (player/faction/next/suggested guide).
- **Debug diagnostics:** `/flg debug` now includes richer location/step-state context and supports `/flg debug export` for a copyable full report; help text updated accordingly.
- **Arrow/navigation:** target sync now respects panel/arrow visibility and uses clearer step labels/zones with safer fallback messaging.
- **Foundation hardening:** schema-validated per-character SavedVariables with recovery/migrations safety, validated guide registration/lookup, safer method-call patterns, and more resilient in-game behavior on WoW Forever clients. All engine and bundled route content remains original/open.

## [0.1.0] - 2026-11-12 (local foundation, not yet tagged/released)

### Added
- Initial release of **WoW Forever Leveling Guide Addon ByJTT** (free, open, data-driven leveling guide for WoW Forever).
- Step-by-step guide panel with progress, Prev/Next/Skip/Reset controls, movable/resizable/lockable UI.
- Navigation arrow pointing to step coordinates (best-effort, client/API dependent).
- Best-effort auto-advance for quest accept/complete/turn-in, level-ups, and `goto` arrival (manual controls always available).
- Per-character saved progress via `ForeverLevelingGuideDB` (schema-versioned, with invalid-guide recovery).
- Extensible Lua guide format (`Data/` + `ns:RegisterGuide(...)`) with basic validation.
- Bundled free starter routes: `horde_01_10_durotar` and `alliance_01_10_elwynn` (1-10 samples).
- Slash commands: `/flg` with aliases `/levelguide`, `/journey`, `/jf` (including `list`, `load`, `arrow`, `auto`, `announce`, `where`, `debug`, `help`).
- ByJTT-standard docs: README, AGENTS, llms.txt, CONTRIBUTING, SECURITY, LICENSE.

### Notes
- Bundled routes are starter samples; full 1-60+ coverage and per-client (WoW Forever) map/coordinate tuning are planned.
