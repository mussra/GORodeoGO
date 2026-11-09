# Portrait light legs

`art/portraits/adult_light_legs_mask.png` is an independent red-channel mask
for pattern 4 in the HD portrait. `HorsePortrait` binds it to the portrait shader.
Its coverage is confined to the coat material; the source's cream stockings
and hooves remain source artwork. Other pattern IDs never sample this mask.
World animation masks and the CPU pattern implementation are not changed.

The offline editor adds this mask as `portrait-light-legs`, kind `socks`.
Generate from the previous downloaded editor release:

    python3 tools/cosmetics/build_light_legs_editor.py previous-editor.html output-editor.html

Existing asset IDs, baseline and browser storage keys stay intact. A returned
JSON's strokes need applying to this PNG, then a fresh APK export. The editor
never updates an installed APK. The initial mask follows separate curved,
feathered contours for all four legs rather than one common horizontal row.

`tools/qa_socks_2744.tscn` renders pattern 4 with Liso and Moteado controls.
Set `SOCK_CAPTURE` to an output PNG path. Visual checks complement unit tests.
