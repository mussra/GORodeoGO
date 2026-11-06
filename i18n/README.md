# Localization foundation

Godot 4.7-dev1, native TranslationServer and gettext catalogs bundled offline.
`ui.es.po` and `ui.en.po` are runtime catalogs, including native plurals. `ui.csv` is the editing sheet for singular messages; keep it in sync with PO when adding text. `key-map.json` records the source phrase for each initial key.

Automatic uses device language es/en with Spanish fallback. Settings offers auto/es/en and stores the selection atomically in a separate language.cfg. Horse names entered by the player are not translated.

Coverage: main menu, level chooser, settings, HUD/pause/hints/results/double-lasso notice, equipment, hats, trial selectors and stable collection/breeding/profile/atlas/family. Trait descriptions and generated atlas candidates follow the language; saved horse names stay unchanged. Level-world text (map, water/hay, bull activity, edge indicators, drawing cue and trial messages) is also extracted. Player-authored names and the Rancho title are intentionally unchanged. Platform errors and developer diagnostics are not player-facing localization.

Native API references checked against the running 4.7-dev1 binary:
https://docs.godotengine.org/en/latest/tutorials/i18n/internationalizing_games.html
https://docs.godotengine.org/en/latest/classes/class_translationserver.html
https://docs.godotengine.org/en/latest/classes/class_translation.html

Tests verify locale fallback, persisted selection, failed-save rollback, both catalogs and native singular/plural selection. Menu/settings and all eight equipment/stable/hats/trial views rendered and visually inspected in Spanish and English. Placeholder parity checked across catalogs. No physical Android language test yet.
