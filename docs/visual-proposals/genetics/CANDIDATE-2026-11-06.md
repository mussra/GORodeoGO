# Genetics candidate, 2026-11-06

Working branch only. No merge into main or Android release in this change.

- Moteado retains deterministic separated positions with mixed size and rotation.
- Five appended pattern IDs: hearts, stars, triangles, diamonds, zebra. Old IDs 0..4 unchanged.
- Eyes 20 and 21 add rainbow and galaxy within existing iris masks. Old IDs 0..19 unchanged.
- Galaxy finish colors coat and mane within existing masks. Rider and tack remain unchanged.
- Trait inheritance includes explicit parent choice for finish. Galaxy overrides the underlying coat/pattern appearance; rarity and acquisition rules remain unspecified.
- Isolated trial adds eyes and finish controls. Leaving it restores the real collection; no trial progress is saved.
- 31 focused tests, 41,634 assertions pass: genetics, collection/names, isolated trial, mask isolation and points migration. Additional control-signal check passes.
- Engine previews checked at 1280x720: adult/foal/gameplay, all five animation directions, trial menu and breeding menu. Not a physical Android test or mobile performance benchmark.
- Saves from 2.0 are accepted. New pattern/eye IDs are not compatible with opening the candidate save in the older 2.0 build. Trial-only selection avoids persisting those IDs.

Review tools in tools/: moteado_natural_review.gd, genetic_patterns_review.gd, special_eyes_review.gd, galaxy_motion_review.gd, candidate_trial_menu_review.gd, candidate_breeding_menu_review.gd, candidate_controls_check.gd.

## Safe return to 2.0

The candidate uses `user://save-genetics-v3.dat`. If that file is absent, it reads the existing `user://save.dat` once as its starting state, then writes only the new path. The 2.0 file is never overwritten by this candidate. Reinstalling/opening 2.0 can therefore resume the last 2.0 state. Progress earned in the candidate does not flow back to 2.0. Do not uninstall/clear app data before returning, because Android can remove both private files. This is a namespace split, not a two-way downgrade migration. An existing but unreadable new file does not silently load the older save.

Persistence tests use isolated fixture paths and verify the 2.0 file remains byte-for-byte identical after saving new IDs. No real user save is migrated or deleted as part of preparing this change.

## Airborne upper edge correction

The diagonal hat exclusion no longer clips the horse forehead at a fixed row during raised frames. Its limit follows the already-present body bob. Actual hat pixels are independently excluded using the reviewed original/blue-hat difference, so moving the cutoff cannot recolor the hat. No source mask or animation displacement changed. 32 focused tests, 74,529 assertions pass, including every diagonal frame and every known hat pixel. Updated five-direction engine movie inspected; physical Android remains untested.
