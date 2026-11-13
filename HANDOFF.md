# Handoff - WoW Forever Leveling Guide Addon ByJTT

> Last updated: 2026-11-13 (autopilot follow-up: debug export, offline validator, docs, git hygiene; no in-game verification performed)

## Current state

- **Addon:** `WoW Forever Leveling Guide Addon ByJTT` (repo: `wow-forever-leveling-guide-addon`, in-game folder: `ForeverLevelingGuide`)
- **Target:** World of Warcraft: Forever (Interface 16001, 30300). Guidance UI only (no gameplay automation, no protected/secure actions).
- **Version/SV:** TOC `## Version 0.1.0`, Lua `ns.VERSION = "0.1.0"`, `ns.SCHEMA = 1`, SavedVariables `ForeverLevelingGuideDB`.
- **Git:** local repo on `master` (no remote configured in this workspace). Prior commits on this branch: `cc16956`, `9107ff3`, `fc8f0c1`. This follow-up adds uncommitted working-tree changes (debug export, validator, docs/handoff, minor guide-data polish as needed).
- **Canonical addon decision:** `ForeverLevelingGuide` is the active/canonical codebase. `C:\Users\jorda\BYJTT_JourneyFree` (no git, older prototype/research with `_research/Journey-4.00.06` notes, last modified earlier 2026-11-12) should be treated as **separate research/prototype reference only** (no duplication of in-game addon code paths). Prefer archiving or leaving it untouched unless explicitly merging ideas; do not treat it as the shipping addon.

## What is implemented

- **Core foundation:** schema-validated per-character/profile SavedVariables, guide registry (`ns:RegisterGuide`), slash commands `/flg` (+ aliases), auto-select/suggest/continue flow, diagnostics/debug output.
- **Engine/tracker/UI/arrow:** step viewer with progress and Prev/Next/Skip/Reset/Guides controls, movable/resizable/lockable panel, best-effort auto-advance for quest/item/level/arrival steps, broad type/field alias support, coordinate normalization and arrival detection, best-effort navigation arrow sync and optional TomTom waypoint integration when available.
- **Guide flow:** level/faction-aware selection, scaffold labeling, guide-complete suggestions, `/flg suggest`, explicit guide chaining via `next`, and `/flg continue` (loads chained next or best suggested guide). End-of-guide Next/`/flg next` can continue into next/suggested guide when available.
- **Verification/authoring aids (new):**
  - **In-game debug export:** `/flg debug export` builds a copyable full report (client/build, player/map/zone/coords, guide/step state, arrow/target, step satisfaction/arrival context) via a UI export dialog (or stored in memory if UI unavailable) to accelerate WoW Forever verification/tuning. `/flg debug` now shows richer location/step context and points to export.
  - **Offline guide validator:** `python tools/validate_guides.py [project_root]` performs lightweight structural checks on `Data/*.lua` and TOC coverage (guide registration/duplicates, chain integrity, faction/level sanity, step type/field/coord shape hints, missing TOC/data files). No in-game validation and no guessed real quest IDs/mapIDs/coords.
- **Bundled routes (original/open):**
  - Starters (1-10 samples): `horde_01_10_durotar`, `alliance_01_10_elwynn` (chain to 10-20 scaffolds).
  - 10-60 scaffolds (WIP, `scaffold=true`, chained 10-20 -> 20-30 -> 30-40 -> 40-50 -> 50-60):
    - Horde: `horde_10_20_barrens_stonetalon_scaffold`, `horde_20_30_ashenvale_thousand_needles_scaffold`, `horde_30_40_stranglethorn_arathi_desolace_scaffold`, `horde_40_50_tanaris_feralas_hinterlands_scaffold`, `horde_50_60_ungoro_felwood_burning_steppes_scaffold`
    - Alliance: `alliance_10_20_westfall_loch_modan_darkshore_scaffold`, `alliance_20_30_duskwood_redridge_wetlands_scaffold`, `alliance_30_40_stranglethorn_arathi_desolace_scaffold`, `alliance_40_50_tanaris_feralas_hinterlands_scaffold`, `alliance_50_60_ungoro_felwood_burning_steppes_scaffold`
- **Scaffold refinement approach:** bracket/zone progression, hub sequencing, checkpoints, train breaks, optional dungeon notes, and transitions were compared at a high level to established leveling-guide flow for pacing/order. **No real in-game data/tuning was performed.** All step text and structure are original/clean-room; quest IDs/mapIDs/coords are intentionally not asserted for scaffolds and must be verified/tuned on WoW Forever.

## Files of note

- Core: `ForeverLevelingGuide.toc`, `Core.lua`, `GuideEngine.lua`, `Tracker.lua`, `Arrow.lua`, `UI.lua`
- Data: `Data/Guides.lua`, `Data/Horde_01_10_Durotar.lua`, `Data/Alliance_01_10_Elwynn.lua`, `Data/Scaffolds_Horde.lua`, `Data/Scaffolds_Alliance.lua`
- Tools/docs/meta: `tools/validate_guides.py`, `README.md`, `CHANGELOG.md`, `AGENTS.md`, `llms.txt`, `CONTRIBUTING.md`, `SECURITY.md`, `LICENSE`, `.gitignore`, `.gitattributes`, `.luarc.json`, this `HANDOFF.md`

## Recent autopilot changes (2026-11-13)

- Earlier this pass: refined/chained 1-60 routes, Continue/next-guide flow and UI polish, and docs updates (commits `9107ff3`, `fc8f0c1`).
- Follow-up (current working tree): added `/flg debug export` (copyable in-game report + UI dialog) and richer debug/location/step context in `Core.lua`/`UI.lua`; added offline `tools/validate_guides.py` and ran it (passes with expected scaffold info: some travel steps intentionally lack coords); updated `README.md`, `CHANGELOG.md`, `AGENTS.md`, `llms.txt`, and this handoff to document verification tooling, route/originality policy, and canonical/repo state.

## Git/remotes/push status (ecosystem)

- **ForeverBuffReminder** (`C:\Users\jorda\ForeverBuffReminder`, `main`): committed and pushed `.luarc.json` (`b7d1c68`) plus prior local polish commit (`75805ab`) to `origin/main` (https://github.com/ByJTT/wow-forever-buff-reminder-addon.git). Working tree clean.
- **ForeverFishing** (`C:\Users\jorda\ForeverFishing`, `main`): committed and pushed `.luarc.json` (`bcd7f03`) plus prior local hardening commit (`da0fd86`) to `origin/main` (https://github.com/ByJTT/wow-forever-fishing-addon.git). Working tree clean.
- **ForeverLevelingGuide** (`C:\Users\jorda\ForeverLevelingGuide`, `master`): **no git remote configured**. Local commits exist; current follow-up changes are uncommitted and not pushed.

### Suggested remote/push plan for `ForeverLevelingGuide` (not executed)
1. Create/confirm the canonical GitHub repo (expected: `https://github.com/ByJTT/wow-forever-leveling-guide-addon.git`).
2. Add remote and verify: `git remote add origin https://github.com/ByJTT/wow-forever-leveling-guide-addon.git` (or `git remote set-url origin ...` if needed), then `git remote -v`.
3. Commit this follow-up in logical chunks (e.g. debug export + validator + docs/handoff). Keep commit messages clear and include co-author trailer as per repo conventions.
4. Push explicitly: `git push -u origin master` (or rename branch to `main` first if you want alignment with other repos: `git branch -m master main && git push -u origin main`). Do this only after confirming remote/branch policy.
5. Do **not** copy in-game addon folders into git in a way that commits local `WTF`/SavedVariables/account data; keep `.gitignore` effective.

## Open items / next steps

1. **In-game verification on WoW Forever (required before release-quality tuning):** `/reload`, `/console scriptErrors 1`, `/flg debug` and `/flg debug export`, guide loading/list/picker, step navigation (next/prev/skip/reset/continue/suggest), auto-advance, arrow/coords/TomTom-optional behavior, SavedVariables persistence, and UI drag/resize/lock/show-hide across sessions. Capture exports for mismatches.
2. **Route verification and expansion:** validate bundled starter quest IDs/coords on WoW Forever; expand scaffolds into verified, step-by-step routes with confirmed quest IDs, `mapID`s, coordinates, NPCs, breadcrumbs, and branching/race/class alternatives as needed. Keep all content original/open and clean-room (compare only high-level pacing/zone flow to established guides).
3. **Client/API compatibility checks:** confirm quest log/map/item/player APIs and event behavior on the WoW Forever client; adjust fallbacks if any calls differ.
4. **Polish:** optional minimap/button entrypoint or settings discoverability if desired, accessibility/readability passes, additional optional guide packs, and community contribution workflow for routes. Consider adding more validator rules as real route data matures (when safely inferable).
5. **Release prep (when verified):** replace Buy Me a Coffee placeholder URL with the real one if/when available, bump version/SemVer and TOC/Lua/CHANGELOG in sync, tag/release, configure git remote and push.
6. **Repo hygiene:** commit/push `ForeverLevelingGuide` follow-up once remote is set; keep `BYJTT_JourneyFree` archived/research-only.

## Notes for contributors/agents

- Keep changes **guidance-only** and safe-by-default (no automation/protected actions). Preserve addon folder name `ForeverLevelingGuide` and "AddonName ByJTT" branding style.
- Prefer minimal, dependency-free Lua; feature-detect APIs with fallbacks; keep SavedVariables additive and schema-versioned.
- When refining routes "relative to established guides," compare only high-level pacing/zone flow and write original, clean-room step text/structure. Do not copy proprietary guide steps or code. Do not guess real in-game quest IDs/mapIDs/coords.
- Use `python tools/validate_guides.py` for offline data checks and `/flg debug export` for in-game state capture during verification.
- After user-visible changes, update `CHANGELOG.md`. Do not commit secrets, account data, or local personal paths.
