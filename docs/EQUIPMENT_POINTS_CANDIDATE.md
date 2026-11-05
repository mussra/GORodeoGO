# Equipment points candidate, not released

User5Nov20:15requested repeatable level-completion rewards, strongly increasing with difficulty, and optional cosmetic/functional gear. Examples1=10,5=200,10=1000,whip1000are illustrative.20:20Okapproved one-time credit for deducible first victories in old progress, excluding unknown historical repeat wins.

Current code is foundation, not a delivered economy. EquipmentPoints accepts reward/catalog data, awards unique result IDs (repeats with distinct results count), spends points once and equips separately, with original items free. EquipmentCatalog is an explicitly candidate20-level curve and two whip options. These numbers are NOT applied to live victories, save loading or player stats. Fusta-at-level10 prototype was removed. The prior shipped baseline still has old long-regate upgrade until the points integration replaces it. No new APK with that contradiction will be shipped.

SaveData format2stores points, owned IDs, equipped slots and one-time legacy marker while preserving prior max-level/intro. apply_legacy_points_credit requires a complete supplied table, saves atomically and rolls back if persistence fails. Loading alone cannot credit a guessed balance. QA uses isolated save paths, not the real profile.18tests93assertions cover wallet/inventory/migration/save after final run.

Draft review screen is separate under tools/equipment_draft_review.gd, not reachable in normal menu. Uses sample first victories1-7=1195, basic whip1000and improved whip2000, 260/420world pixels from existing reach. Buy/equip operations demonstrated with sample balance. No money, no external checkout. Other gear remains a visual/design proposal, not invented finished art.

Pending: confirm candidate balance for a test release, wire completion receipts/rewards, acquisition/equip UI, player ability selection and replacement of old direct-level gates. Preserve ordinary game rules and no stacking of preexisting speed bonus without an explicit balance decision. No main merge/store publication.
