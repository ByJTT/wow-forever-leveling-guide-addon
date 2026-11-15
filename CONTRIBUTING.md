# Contributing - WoW Forever Leveling Guide Addon ByJTT

Thanks for helping improve **WoW Forever Leveling Guide Addon ByJTT**. Keep it **small, reliable, safe-by-default, and well-documented**.

## Ground rules

- **Safe-by-default / guidance only:** this addon is a UI/route helper. Do not add gameplay automation or protected/tainted secure actions.
- **Minimal:** no frameworks/libs unless clearly necessary and justified. Prefer simple Lua, small focused modules, no dead code.
- **Compatibility:** target WoW Forever (Interface 16001, 30300) with feature-detected API fallbacks where possible. Avoid assuming Retail-only APIs without guards.
- **Privacy:** no personal data, account data, tokens/secrets, hardcoded local absolute paths, or `WTF`/SavedVariables data in commits/PRs. Public branding links (byjtt.com, GitHub, repo, support placeholder) are OK.
- **Original/clean-room:** compare only high-level flow/pacing/UX concepts from established guides/addons when needed and keep all route text/structure/code original. Do not copy proprietary guide content or third-party code.
- **Naming/branding:** keep "AddonName ByJTT" style in display name/TOC and document the in-game folder name (`ForeverLevelingGuide`). Keep repo/install naming clear per ByJTT org standards.
- **Release sync:** TOC `## Version`, Lua `VERSION`/`SCHEMA` (as applicable), `CHANGELOG.md`, and git tag must match (SemVer).

## Reporting issues

Please include:
- WoW client/variant (**WoW Forever**) and interface/build if known
- Addon version and state (`/flg debug` or `/flg debug export` output)
- Expected vs actual behavior and steps to reproduce
- Lua errors (`/console scriptErrors 1`, then `/reload`) if any
- Guide key/step and route details (coords, `mapID`, manual waypoint if relevant) when applicable
- No account data/local personal paths

## Pull requests

1. Branch from `main`/`master` as appropriate. Keep PRs focused.
2. Test in game (WoW Forever): `/reload`, `/console scriptErrors 1`, `/flg list`, `/flg load <key>`, step navigation (next/prev/skip/reset/goto/continue/suggest), settings panel (`/flg config`), onboarding (`/flg onboarding`), arrow/manual waypoint, minimap button, panel lock/resetui/resetdefaults, auto-advance behavior, and `/flg debug`/`/flg debug export`.
3. Run offline checks when route/data files change: `python tools/validate_guides.py`.
4. Update `CHANGELOG.md` for user-visible changes.
5. Follow `BYJTT_WOW_ADDON_STANDARD.md` for UX/consistency (help/voice, settings, accessibility, update messaging). For route contributions, prefer accurate `mapID`/coords, clear notes, and original/open route data (no guessed real in-game IDs/coords without verification).

## Local dev tips

```text
/flg help
/flg config
/flg onboarding
/flg list
/flg load horde_01_10_durotar
/flg goto 1
/flg way here
/flg minimap
/flg debug
/flg debug export
/console scriptErrors 1
/flg  (show UI)

python tools/validate_guides.py
```
