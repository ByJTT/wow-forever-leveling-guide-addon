## Summary

## Testing (WoW Forever, in game)
- [ ] `/reload` (Lua errors on: `/console scriptErrors 1`)
- [ ] `/flg` opens/toggles the guide panel; drag/resize/lock and position persistence work
- [ ] `/flg list` and `/flg load <key>` work; correct guide/steps shown
- [ ] Prev/Next/Skip/Reset behave correctly; progress persists per character (`ForeverLevelingGuideDB`)
- [ ] Arrow/auto-advance/announce toggles work as expected; `/flg where` and `/flg debug` output reviewed
- [ ] Quest/level/`goto` step handling behaves reasonably for the client (best-effort)
- [ ] No Lua errors during normal use or guide switching

## Safety & foundation
- [ ] No protected/automation behavior added; guidance-only and safe-by-default
- [ ] No secrets, account data, or local personal paths
- [ ] `CHANGELOG.md` updated (if user-visible); TOC `## Version` + Lua `VERSION`/schema aligned for releases
- [ ] Branding/links correct (ByJTT / byjtt.com / GitHub / support placeholder as applicable)
