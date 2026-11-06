# Genetics candidate, 2026-11-06

Working branch only. No merge into main or Android release in this change.

- Moteado retains deterministic separated positions with mixed size and rotation.
- Five appended pattern IDs: hearts, stars, triangles, diamonds, zebra. Old IDs 0..4 unchanged.
- Eyes 20 and 21 add rainbow and galaxy within existing iris masks. Old IDs 0..19 unchanged.
- Galaxy finish colors coat and mane within existing masks. Rider and tack remain unchanged.
- Trait inheritance includes explicit parent choice for finish. Galaxy overrides the underlying coat/pattern appearance; rarity and acquisition rules remain unspecified.
- Isolated trial adds eyes and finish controls. Leaving it restores the real collection; no trial progress is saved.
- 30 focused tests, 41,624 assertions pass: genetics, collection/names, isolated trial, mask isolation and points migration. Additional control-signal check passes.
- Engine previews checked at 1280x720: adult/foal/gameplay, all five animation directions, trial menu and breeding menu. Not a physical Android test or mobile performance benchmark.
- Saves from 2.0 are accepted. New pattern/eye IDs are not compatible with opening the candidate save in the older 2.0 build. Trial-only selection avoids persisting those IDs.

Review tools in tools/: moteado_natural_review.gd, genetic_patterns_review.gd, special_eyes_review.gd, galaxy_motion_review.gd, candidate_trial_menu_review.gd, candidate_breeding_menu_review.gd, candidate_controls_check.gd.
