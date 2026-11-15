# Handoff - WoW Forever Leveling Guide Addon ByJTT

> Last updated: 2026-11-14 (autopilot: Blizzard-native QOL/unification polish — settings panel, welcome/onboarding, reset/recovery, grouped help/chat voice, icon/standard docs; validated; no in-game verification)

## Current state

- **Addon:** `WoW Forever Leveling Guide Addon ByJTT` (repo: `wow-forever-leveling-guide-addon`, in-game folder: `ForeverLevelingGuide`)
- **Target:** World of Warcraft: Forever (Interface 16001, 30300). Guidance UI only (no gameplay automation, no protected/secure actions).
- **Version/SV:** TOC `## Version 0.2.0`, Lua `ns.VERSION = "0.2.0"`, `ns.SCHEMA = 1`, SavedVariables `ForeverLevelingGuideDB` (additive schema; includes minimap settings, manual waypoint, and onboarding/welcome state flags).
- **Git:** `master` tracks `origin/master` (`https://github.com/ByJTT/wow-forever-leveling-guide-addon.git`). This pass is being committed/pushed (see git log); prior v0.2.0 core features and polish commits are already in history.
- **Canonical addon decision:** `ForeverLevelingGuide` is the active/canonical codebase. `C:\Users\jorda\BYJTT_JourneyFree` (no git, older prototype/research with `_research/journey_4.00.06` notes) is **research/prototype reference only** (archived notice there) - not the shipping addon and not to be duplicated into in-game addon code paths.
- **Shared standard:** `BYJTT_WOW_ADDON_STANDARD.md` added (repo-only, ignored by `.pkgmeta`) as the living ByJTT UX/quality/release convention guide.

## What is implemented

- **Core foundation:** schema-validated per-character/profile SavedVariables, guide registry (`ns:RegisterGuide`), slash commands `/flg` (+ aliases), auto-select/suggest/continue flow, diagnostics/debug output, and best-effort peer update notifications (in-game addon comms, no internet/no auto-update; toggle `/flg update`).
- **Engine/tracker/UI/arrow:** step viewer with progress and Prev/Next/Skip/Reset/Guides controls, movable/resizable/lockable panel (with tooltips), best-effort auto-advance for quest/item/level/arrival steps, broad type/field alias support, coordinate normalization and arrival detection, best-effort navigation arrow sync and optional TomTom waypoint integration when available.
- **Navigation & accessibility UX:** draggable **minimap button** (left-click show/hide, right-click Guides, saved angle/hide, `/flg minimap`), `/flg lock`, `/flg goto <n>` (jump to step and re-evaluate), and `/flg way` **manual waypoint** override (`here|clear|<x> <y>|<mapID> <x> <y>`) that temporarily drives the arrow (shown as `[Way]`) and is persisted per character.
- **Guide flow:** level/faction-aware selection, scaffold labeling, guide-complete suggestions, `/flg suggest`, explicit guide chaining via `next`, and `/flg continue` (loads chained next or best suggested guide). End-of-guide Next/`/flg next` can continue into next/suggested guide when available.
- **Settings, onboarding, and recovery (Blizzard-native, all skill levels):**
  - `/flg config` (`/flg options|settings`) opens an in-game settings UI via Blizzard Settings/InterfaceOptions when available, with a **standalone movable fallback** when not.
  - Settings include toggles for navigation arrow, auto-advance, chat announcements, minimap button, panel lock, and peer update notifications, plus quick actions (Open Guides, Show Welcome, Reset Window, Reset Settings, Debug Export) and About/support links.
  - Short, re-openable **Welcome/onboarding guide** (`/flg onboarding|welcome`) explains the happy path, controls, and scaffold/WIP note; offered on first run.
  - **Recovery commands:** `/flg resetui` (window position/size), `/flg resetdefaults` (addon settings to defaults, keeps guide progress and window layout). `/flg reset` remains guide-progress reset for the current character/guide.
- **Help/voice consistency:** grouped, plain-language `/flg help` (How to use / Basic / Navigation & options / Advanced) and consistent ByJTT chat prefix/branding (`ByJTT Leveling Guide`), with clear unknown-command guidance.
- **Verification/authoring aids:**
  - **In-game debug export:** `/flg debug export` builds a copyable full report (client/build, player/map/zone/coords, guide/step state, manual waypoint, arrow/target, step satisfaction/arrival context, minimap/update-notify state) via a UI export dialog (or stored in memory if UI unavailable).
  - **Offline guide validator:** `python tools/validate_guides.py [project_root]` performs lightweight structural checks on `Data/*.lua` and TOC coverage (guide registration/duplicates, chain integrity, faction/level sanity, step type/field/coord shape hints, missing TOC/data files). No in-game validation and no guessed real quest IDs/mapIDs/coords. Latest run: **0 errors, 0 warnings, 0 info**.
- **Bundled routes (original/open, clean-room):**
  - Starters (1-10 samples): `horde_01_10_durotar`, `alliance_01_10_elwynn` (chain to 10-20 scaffolds).
  - 10-60 scaffolds (WIP, `scaffold=true`, chained 10-20 -> 20-30 -> 30-40 -> 40-50 -> 50-60):
    - Horde: `horde_10_20_barrens_stonetalon_scaffold`, `horde_20_30_ashenvale_thousand_needles_scaffold`, `horde_30_40_stranglethorn_arathi_desolace_scaffold`, `horde_40_50_tanaris_feralas_hinterlands_scaffold`, `horde_50_60_ungoro_felwood_burning_steppes_scaffold`
    - Alliance: `alliance_10_20_westfall_loch_modan_darkshore_scaffold`, `alliance_20_30_duskwood_redridge_wetlands_scaffold`, `alliance_30_40_stranglethorn_arathi_desolace_scaffold`, `alliance_40_50_tanaris_feralas_hinterlands_scaffold`, `alliance_50_60_ungoro_felwood_burning_steppes_scaffold`
- **Route refinement approach:** bracket/zone progression, hub sequencing, checkpoints, train breaks, optional dungeon notes, and transitions were compared at a high level to established leveling-guide flow for pacing/order. **No real in-game data/tuning was performed.** All step text and structure are original/clean-room; quest IDs/mapIDs/coords are intentionally not asserted for scaffolds and must be verified/tuned on WoW Forever.

## Files of note

- Core: `ForeverLevelingGuide.toc`, `Core.lua`, `GuideEngine.lua`, `Tracker.lua`, `Arrow.lua`, `UI.lua`
- Data: `Data/Guides.lua`, `Data/Horde_01_10_Durotar.lua`, `Data/Alliance_01_10_Elwynn.lua`, `Data/Scaffolds_Horde.lua`, `Data/Scaffolds_Alliance.lua`
- Tools/docs/meta: `tools/validate_guides.py`, `README.md`, `CHANGELOG.md`, `AGENTS.md`, `llms.txt`, `CONTRIBUTING.md`, `SECURITY.md`, `LICENSE`, `BYJTT_WOW_ADDON_STANDARD.md`, `.pkgmeta`, `.gitignore`, `.gitattributes`, `.luarc.json`, this `HANDOFF.md`

## Recent autopilot changes (2026-11-13 to 2026-11-14)

- Refined/chained 1-60 routes, Continue/next-guide flow and UI polish, and docs updates (commits `9107ff3`, `fc8f0c1`).
- Added `/flg debug export`, richer debug/location/step context, offline `tools/validate_guides.py`, and verification/route-policy docs (commit `0807b59`).
- Normalized scaffold line endings for consistency (commit `9e48826`).
- **v0.2.0 UX/navigation polish:** minimap button (`/flg minimap`), manual waypoint (`/flg way`), `/flg goto <n>`, `/flg lock`, UI tooltips, version bump to 0.2.0, docs sync (commit `c9bc970`, pushed).
- **Post-v0.2.0 UI/status polish:** progress %, clearer waypoint indicators/status, `/flg where` improvements (commit `b173598`, pushed).
- **Peer update notifier + docs:** best-effort in-game peer version notifications (shared ByJTT prefix, group/raid/instance/guild), `/flg update` toggle, debug/export visibility, docs updates (commit `f280145`, pushed). No internet, no auto-update.
- **CurseForge/packager prep:** `.pkgmeta` and docs refresh (commit `8ae116e`, pushed).
- **2026-11-14 QOL/unification polish (this pass):** added Blizzard Settings/InterfaceOptions panel with standalone fallback (`/flg config`), first-run/re-openable Welcome/onboarding (`/flg onboarding`), `/flg resetui` and `/flg resetdefaults` recovery commands, grouped plain-language `/flg help` and consistent chat prefix/branding, TOC `## IconTexture`, `BYJTT_WOW_ADDON_STANDARD.md`, and synchronized README/CHANGELOG/AGENTS/llms/CONTRIBUTING/HANDOFF. Validator: 0 errors/warnings/info. No in-game verification performed.

## Git/remotes/push status (ecosystem)

- **ForeverBuffReminder** (`C:\Users\jorda\ForeverBuffReminder`, `main`): in sync with `origin/main` (https://github.com/ByJTT/wow-forever-buff-reminder-addon.git).
- **ForeverFishing** (`C:\Users\jorda\ForeverFishing`, `main`): in sync with `origin/main` (https://github.com/ByJTT/wow-forever-fishing-addon.git).
- **ForeverLevelingGuide** (`C:\Users\jorda\ForeverLevelingGuide`, `master`): tracks `origin/master` (https://github.com/ByJTT/wow-forever-leveling-guide-addon.git).
- **BYJTT_JourneyFree** (`C:\Users\jorda\BYJTT_JourneyFree`, no git): archived prototype/research reference only; `ForeverLevelingGuide` is canonical.

## Open items / next steps

1. **In-game verification on WoW Forever (required before release-quality tuning):** `/reload`, `/console scriptErrors 1`, `/flg config`/settings (Blizzard + fallback), onboarding, `/flg debug` and `/flg debug export`, guide loading/list/picker/continue/suggest, step navigation (next/prev/skip/reset/goto/resetui/resetdefaults), auto-advance, arrow/coords/manual waypoint/minimap/TomTom-optional behavior, SavedVariables persistence, peer update notifier behavior (`/flg update`, group/raid/instance/guild addon comms across clients/builds), and UI drag/resize/lock/show-hide across sessions. Capture exports for mismatches.
2. **Route verification and expansion:** validate bundled starter quest IDs/coords on WoW Forever; expand scaffolds into verified, step-by-step routes with confirmed quest IDs, `mapID`s, coordinates, NPCs, breadcrumbs, and branching/race/class alternatives as needed. Keep all content original/open and clean-room (compare only high-level pacing/zone flow to established guides). Do not guess real in-game IDs/coords.
3. **Client/API compatibility checks:** confirm quest log/map/item/player APIs and event behavior on the WoW Forever client; adjust fallbacks if any calls differ (feature-detect/pcall).
4. **Polish:** further accessibility/readability passes, optional guide packs, and community contribution workflow for routes. Consider more validator rules as real route data matures (when safely inferable).
5. **Release prep (when verified):** replace Buy Me a Coffee placeholder URL with the real one if/when available, bump/tag/release (SemVer) with TOC/Lua/CHANGELOG in sync, and publish to CurseForge/WowUp/Wago as appropriate (packaging/metadata ready). In-game peer notifier complements addon managers but does not replace them.
6. **Repo hygiene:** keep `BYJTT_JourneyFree` archived/research-only; do not copy proprietary third-party guide text/code into this addon.

## Notes for contributors/agents

- Keep changes **guidance-only** and safe-by-default (no automation/protected actions). Preserve addon folder name `ForeverLevelingGuide` and "AddonName ByJTT" branding style.
- Prefer minimal, dependency-free Lua; feature-detect APIs with fallbacks; keep SavedVariables additive and schema-versioned.
- When refining routes "relative to established guides," compare only high-level pacing/zone flow and write original, clean-room step text/structure. Do not copy proprietary guide steps or code. Do not guess real in-game quest IDs/mapIDs/coords.
- Use `python tools/validate_guides.py` for offline data checks and `/flg debug export` for in-game state capture during verification.
- After user-visible changes, update `CHANGELOG.md`. Do not commit secrets, account data, or local personal paths.
