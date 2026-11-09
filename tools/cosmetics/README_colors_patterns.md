# Lower legs and genetic maps (2.7.45)

- Optional traits `legs` and `spots` use the existing 20-entry coat palette.
  Missing or -1 means original behavior. No migration changes an old horse.
- `HorseCollection.preview` inherits each channel from the selected parent.
  Existing trait IDs stay stable; Jirafa is 10 and Vaca is 11. Cebra remains 9.
- Background is the existing `coat` trait. The spot color can be selected
  independently. Maps in `art/patterns/` are shared by the CPU recolorer and
  portrait shader. They are periodic maps, not extra copies per animation.
- Lower-leg ownership is separate from coat/hair. The source cream is replaced
  using the selected color and source luminance, without changing source alpha.
  Hooves stay brown. The portrait and foal have traced ownership; pixel-art
  masks are built from each actual animation frame, excluding hair and hooves.
- `build_lower_legs_masks.py` and `build_genetic_pattern_maps.py` regenerate
  masks/maps. Regeneration should always be followed by visual inspection.
- `SaveData.set_horse_legs` and `set_horse_pattern_color` persist atomically and
  roll back on save failure. Mustang chooses coat Castaño, black mane, Liso,
  black lower legs and normal finish. Normal horses can be customized in Ficha.
- Existing world and level sprites both use HorseAppearance, including wild
  horses and foals. Appearance results are cached by source and full traits;
  no pixel loops run every frame.
- `qa_colors_2745.tscn`, `qa_colors_ui_2745.tscn` and
  `qa_legs_directions_2745.tscn` generate runtime visual checks. Environment
  `PATTERN_VARIANTS=1` renders extra giraffe/cow color combinations.
- The offline editor release also includes the lower-leg portrait mask.
  Returned JSON/PNG needs applying to the PNG and a fresh APK export.
