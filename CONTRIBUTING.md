# Contributing - WoW Forever Leveling Guide Addon ByJTT

Thanks for helping improve **WoW Forever Leveling Guide Addon ByJTT**. Keep it **small, reliable, safe-by-default, and well-documented**.

## Ground rules

- **Safe-by-default / guidance only:** this addon is a UI/route helper. Do not add gameplay automation or protected/tainted secure actions.
- **Minimal:** no frameworks/libs unless clearly necessary and justified. Prefer simple Lua, small focused modules, no dead code.
- **Compatibility:** target WoW Forever (Interface 16001, 30300) with feature-detected API fallbacks where possible. Avoid assuming Retail-only APIs without guards.
- **Privacy:** no personal data, account data, tokens/secrets, hardcoded local absolute paths, or `WTF`/SavedVariables data in commits/PRs. Public branding links (byjtt.com, GitHub, repo, support placeholder) are OK.
- **Naming/branding:** keep "AddonName ByJTT" style in display name/TOC and document the in-game folder name (`ForeverLevelingGuide`). Keep repo/install naming clear per ByJTT org standards.
- **Release sync:** TOC `## Version`, Lua `VERSION`/`SCHEMA` (as applicable), `CHANGELOG.md`, and git tag must match (SemVer).

## Reporting issues

Please include:
- WoW client/variant (**WoW Forever**) and interface/build if known
- Addon version and state (`/flg debug` output)
- Expected vs actual behavior and steps to reproduce
- Lua errors (`/console scriptErrors 1`, then `/reload`) if any
- Guide key/step and route details (coords, `mapID`) when relevant
- No account data/local personal paths

## Pull requests

1. Branch from `main`. Keep PRs focused.
2. Test in game (WoW Forever): `/reload`, `/console scriptErrors 1`, `/flg list`, `/flg load <key>`, step navigation (next/prev/skip/reset), arrow, auto-advance behavior, and `/flg debug`.
3. Update `CHANGELOG.md` for user-visible changes.
4. For route contributions, prefer accurate `mapID`/coords, clear notes, and original/open route data.

## Local dev tips

```text
/flg help
/flg list
/flg load horde_01_10_durotar
/flg debug
/console scriptErrors 1
/flg  (show UI)
```
