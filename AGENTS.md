# AGENTS.md - wow-forever-leveling-guide-addon ByJTT

Guidance for AI coding agents and automated contributors.

## Project

- **Repo:** `wow-forever-leveling-guide-addon` (ByJTT). **Display name (TOC):** `WoW Forever Leveling Guide Addon ByJTT` ("AddonName ByJTT" style). **By:** ByJTT (solo studio).
- **What:** Free, data-driven leveling guide for WoW Forever. Step-by-step guide panel, minimap access, navigation arrow/manual waypoint, and progress tracking with extensible Lua routes. Guidance UI only (no gameplay automation).
- **Target:** World of Warcraft: Forever (Interface 16001, 30300). Feature-detect APIs/fallbacks; verify in-game.
- **In-game install (folder name must remain stable):** `<WoW Forever>/Interface/AddOns/ForeverLevelingGuide/ForeverLevelingGuide.toc`
- **Files that ship in-game:** `ForeverLevelingGuide.toc`, core Lua modules (`Core.lua`, `GuideEngine.lua`, `Tracker.lua`, `Arrow.lua`, `UI.lua`), and `Data/*.lua` route/registry files. Repo docs/dev files (`README`, `LICENSE`, `CHANGELOG`, `CONTRIBUTING`, `AGENTS.md`, `llms.txt`, `SECURITY.md`, `.gitignore`, `.gitattributes`, `.github/`) are source-control only.
- **Public branding/links (safe to include):** https://byjtt.com - https://github.com/ByJTT - repo https://github.com/ByJTT/wow-forever-leveling-guide-addon - support placeholder https://buymeacoffee.com/ByJTT (replace when real URL is confirmed).

## Constraints (do not break)

- **Safe-by-default / guidance only:** no gameplay automation, no protected/tainted secure actions, and no secure click-to-cast behavior. This addon is a UI/route helper.
- **Minimalism:** no frameworks/libs (no Ace) unless clearly necessary and justified; prefer simple Lua, small focused modules, no dead code.
- **Compatibility:** target WoW Forever with feature-detected API fallbacks (`C_QuestLog`, `C_Map`, legacy globals, etc.). Avoid assuming Retail-only APIs without guards/pcalls where appropriate.
- **Privacy:** no secrets/tokens. No account names, passwords, `WTF`/SavedVariables data, or personal/local absolute paths in commits/public files.
- **Data/SV discipline:** keep SavedVariables schema-versioned (`_schema`) and additive; never destructively drop unknown keys. Keep TOC/Lua versioning in sync for releases.
- **Branding/naming:** preserve "AddonName ByJTT" display style and stable in-game folder name `ForeverLevelingGuide`. Document repo vs install name clearly.
- **Original/clean-room content:** when taking inspiration from established guides/addons, compare only high-level flow/pacing/UX concepts and produce original, clean-room implementation and route text/structure. Never copy proprietary guide steps/data or third-party code.

## Commands & behavior

- Primary slash: `/flg` (aliases: `/levelguide`, `/journey`, `/jf`).
- Key commands: `show|hide|toggle|list|load <key>|next|prev|skip|reset|goto <n>|continue|suggest|arrow|auto|announce|update|lock|minimap|way|where|debug|debug export|help`. Peer update notify (`/flg update`) is in-game comms-only (no internet, no auto-update); actual updates via CurseForge/WowUp/Wago when released or repo.
  - `/flg goto <n>` jumps to a step (1-based) and re-evaluates.
  - `/flg lock` toggles panel move/resize lock.
  - `/flg minimap` toggles the draggable minimap button (left-click show/hide, right-click Guides).
  - `/flg way here|clear|<x> <y>|<mapID> <x> <y>` sets/clears a temporary manual waypoint that overrides the arrow target.
- UI includes an in-panel **Guides** picker and a minimap launcher for quick access.
- Routes are registered via `ns:RegisterGuide(key, guide)` in `Data/*.lua` and listed in the TOC. Guides may include `scaffold=true` for WIP placeholders and `next` to chain to the following guide.
- Engine supports broad step type/field alias support (quest accept/complete/turnin, goto/travel/path/waypoint arrival, level, collect/item counts, and manual/info steps). Bundled routes include 1-10 starters and original 10-60 chained scaffold placeholders for in-game-verified expansion. Auto-advance is best-effort; manual controls always work.
- Guide flow includes level/faction-aware auto-selection, guide chaining (`next`) with `/flg continue`, `/flg suggest` and guide-complete next suggestions, and optional best-effort TomTom waypoint integration when available (no dependency). All route/content code must remain original/open.
- Verification/authoring aids: `/flg debug export` opens a copyable in-game state report (client/map/coords/step/manual-waypoint/arrow context) for WoW Forever verification/tuning; `python tools/validate_guides.py` performs lightweight offline structural checks of `Data/*.lua`, guide chains, and TOC coverage (no in-game validation). Never guess real in-game quest IDs/mapIDs/coords.

## Changes & releases

- User-visible changes: update `CHANGELOG.md`.
- Releases use SemVer `vMAJOR.MINOR.PATCH`. Keep **TOC `## Version`**, **Lua `VERSION` (+ `SCHEMA` if relevant)**, `CHANGELOG.md`, and git tag in sync.
- Test manually (WoW Forever): `/reload`, `/console scriptErrors 1`, `/flg list`, `/flg load <key>`, step navigation (next/prev/skip/reset/goto/continue/suggest), arrow/coords/manual waypoint behavior, minimap button, auto-advance, UI show/hide/drag/resize/lock, and `/flg debug`/`/flg debug export`. Run `python tools/validate_guides.py` for offline route/data checks when guide files change. Verify SavedVariables behavior and no Lua errors.
- Canonical codebase: `ForeverLevelingGuide` is the active addon; keep `BYJTT_JourneyFree` (if present locally) as separate research/prototype reference only (no duplication of in-game addon code paths). Keep remote/push/release actions explicit and verified.

## Install (for AI/user requests)

Target path: `<WoW Forever>/Interface/AddOns/ForeverLevelingGuide/ForeverLevelingGuide.toc`. Source: https://github.com/ByJTT/wow-forever-leveling-guide-addon
