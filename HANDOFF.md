# Handoff - WoW Forever Leveling Guide Addon ByJTT

> Last updated: 2026-11-13 (autopilot pass, relative guide refinement; no in-game verification performed)

## Current state

- **Addon:** `WoW Forever Leveling Guide Addon ByJTT` (repo: `wow-forever-leveling-guide-addon`, in-game folder: `ForeverLevelingGuide`)
- **Target:** World of Warcraft: Forever (Interface 16001, 30300). Guidance UI only (no gameplay automation, no protected/secure actions).
- **Version/SV:** TOC `## Version 0.1.0`, Lua `ns.VERSION = "0.1.0"`, `ns.SCHEMA = 1`, SavedVariables `ForeverLevelingGuideDB`.
- **Git:** local repo on `master`, initial commit `cc16956` plus uncommitted working-tree changes (foundation expansion, guide flow, scaffold refinement, docs). No remote configured in this workspace.

## What is implemented

- **Core foundation:** schema-validated per-character/profile SavedVariables, guide registry (`ns:RegisterGuide`), slash commands `/flg` (+ aliases), auto-select/suggest/continue flow, diagnostics/debug output.
- **Engine/tracker/UI/arrow:** step viewer with progress and Prev/Next/Skip/Reset/Guides controls, movable/resizable/lockable panel, best-effort auto-advance for quest/item/level/arrival steps, broad type/field alias support, coordinate normalization and arrival detection, best-effort navigation arrow sync and optional TomTom waypoint integration when available.
- **Guide flow:** level/faction-aware selection, scaffold labeling, guide-complete suggestions, `/flg suggest`, explicit guide chaining via `next`, and `/flg continue` (loads chained next or best suggested guide).
- **Bundled routes (original/open):**
  - Starters (1-10 samples): `horde_01_10_durotar`, `alliance_01_10_elwynn` (now chain to 10-20 scaffolds).
  - 10-60 scaffolds (WIP, `scaffold=true`, chained 10-20 -> 20-30 -> 30-40 -> 40-50 -> 50-60):
    - Horde: `horde_10_20_barrens_stonetalon_scaffold`, `horde_20_30_ashenvale_thousand_needles_scaffold`, `horde_30_40_stranglethorn_arathi_desolace_scaffold`, `horde_40_50_tanaris_feralas_hinterlands_scaffold`, `horde_50_60_ungoro_felwood_burning_steppes_scaffold`
    - Alliance: `alliance_10_20_westfall_loch_modan_darkshore_scaffold`, `alliance_20_30_duskwood_redridge_wetlands_scaffold`, `alliance_30_40_stranglethorn_arathi_desolace_scaffold`, `alliance_40_50_tanaris_feralas_hinterlands_scaffold`, `alliance_50_60_ungoro_felwood_burning_steppes_scaffold`
- **Scaffold refinement approach (this pass):** bracket/zone progression, hub sequencing, checkpoints, train breaks, optional dungeon notes, and transitions were compared at a high level to established leveling-guide flow for pacing/order. **No real in-game data/tuning was performed.** All step text and structure are original/clean-room; quest IDs/mapIDs/coords are intentionally not asserted for scaffolds and must be verified/tuned on WoW Forever.

## Files of note

- Core: `ForeverLevelingGuide.toc`, `Core.lua`, `GuideEngine.lua`, `Tracker.lua`, `Arrow.lua`, `UI.lua`
- Data: `Data/Guides.lua`, `Data/Horde_01_10_Durotar.lua`, `Data/Alliance_01_10_Elwynn.lua`, `Data/Scaffolds_Horde.lua`, `Data/Scaffolds_Alliance.lua`
- Docs/meta: `README.md`, `CHANGELOG.md`, `AGENTS.md`, `llms.txt`, `CONTRIBUTING.md`, `SECURITY.md`, `LICENSE`, `.gitignore`, `.gitattributes`, `.luarc.json`, this `HANDOFF.md`

## Recent autopilot changes (2026-11-13)

- Refined 10-60 Horde/Alliance scaffold routes for clearer bracket flow (relative to established guide pacing/zone order), added structured checkpoints/train/goto/transition steps, and chained scaffolds with `next`.
- Linked starter 1-10 routes to 10-20 scaffolds and updated completion guidance to use `/flg continue`.
- Added/kept guide-chain support in core/UI flow (`GetNextGuideKey`, `/flg continue`, next-guide suggestions in debug/UI/complete states), ensured manual next/skip completion announces/suggests the next guide at end-of-guide, and made end-of-guide Next/`/flg next` continue into the next/suggested guide when available (UI Continue button + engine behavior).
- Updated `README.md`, `CHANGELOG.md`, `AGENTS.md`, and `llms.txt` to document chaining/continue and the relative-comparison, original/clean-room scaffold policy.
- Added `.luarc.json` for WoW Lua diagnostics/globals.

## Open items / next steps

1. **In-game verification on WoW Forever (required before release-quality tuning):** `/reload`, `/console scriptErrors 1`, `/flg debug`, guide loading/list/picker, step navigation (next/prev/skip/reset), auto-advance, arrow/coords behavior, `/flg continue`/suggest chains, SavedVariables persistence, and UI drag/resize/lock/show-hide across sessions.
2. **Route verification and expansion:** validate bundled starter quest IDs/coords on WoW Forever; expand scaffolds into verified, step-by-step routes with confirmed quest IDs, `mapID`s, coordinates, NPCs, and branching/race/class alternatives as needed. Keep all content original/open.
3. **Client/API compatibility checks:** confirm quest log/map/item/player APIs and event behavior on the WoW Forever client; adjust fallbacks if any calls differ.
4. **Polish:** optional minimap/button entrypoint or settings discoverability if desired, accessibility/readability passes, additional optional guide packs, and community contribution workflow for routes.
5. **Release prep (when verified):** replace Buy Me a Coffee placeholder URL with the real one if/when available, bump version/SemVer and TOC/Lua/CHANGELOG in sync, tag/release, and configure git remote/push if intended.

## Notes for contributors/agents

- Keep changes **guidance-only** and safe-by-default (no automation/protected actions). Preserve addon folder name `ForeverLevelingGuide` and "AddonName ByJTT" branding style.
- Prefer minimal, dependency-free Lua; feature-detect APIs with fallbacks; keep SavedVariables additive and schema-versioned.
- When refining routes "relative to established guides," compare only high-level pacing/zone flow and write original, clean-room step text/structure. Do not copy proprietary guide steps or code.
- After user-visible changes, update `CHANGELOG.md`. Do not commit secrets, account data, or local personal paths.
