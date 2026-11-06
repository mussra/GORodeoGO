# Draft preservation

Version 5 uses device-local File state key rancho-mask-draft.v1, compact-v1 strokes.
14,500-byte total draft ceiling keeps both state values and explicit owner sends below their 16 KiB payload limits. Additional strokes that exceed it are rejected visibly rather than silently lost. Same browser and account are required; browser data clearing can remove it. Preview state is memory-only and owner-send is hidden there.

The direct owner button sends type rancho.mask-draft, baseline 2.0, format compact-v1, changes [[assetId, [[material, radius, points], ...]], ...]. Decode against bundled assets; each asset contains the baseline hash. Validate materials, dimensions, values and expected IDs before use. These strokes express correction intent, not instructions to copy rough edges literally. Do not auto-apply to the game.

Controlled tests verified saved->page reconstruction->restored strokes, native JSON generation, erase stroke, PNG display and owner-send payload. This was a controlled state/wake transport, not a successful live owner send or Android physical test. Real preview correctly reports that storage is not persistent. Owner-account reload and app-switch testing remains required before treating loss prevention as verified.

The prior download anchors were unavailable in the hosted viewer. Version 5 does not claim downloads: it shows PNG/JSON and offers an explicit owner send.
