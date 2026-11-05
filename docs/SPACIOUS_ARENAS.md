# Spacious arenas and release collision correction
Based0.21.20, branchfix/spacious-corrals-release. No main merge.

## Reproduction and correction
Level18 screenshot showed two released/recaptured bulls in strip between upper corrals3/4. Old useful width about42px vs bull diameter48px. A15-position physical overlap/corner sweep reproduced105px single-frame recovery on release, because held bulls can overlap and wild bodies re-enable mutual collision. Correction registers exceptions only for already-overlapping pairs at release, keeps fences solid, separates through ordinary bounded steering, and restores peer collision at50px. No position assignment or teleport in correction. Tested restoration and physical recapture exit in widened side passage. Not a general invulnerability or permanently noncolliding herd.

## Geometry and camera
Levels1-14 unchanged. Levels15-20 (four or more corrals) grow progressively1.65to2.10per dimension. Corrals/gates/player/bulls/goal unchanged physical size. Corral centres spread, leaving at least128px between adjacent enclosures and usable perimeter routes. Current art/theme/hay/water/lasso preserved. Follow camera keeps character scale, constrained to arena. Border markers show offscreen closed latches, loose bulls, and goal. Recovery grid derives from real bounds rather than old fixed960x540arena.

Minimap shows rider/goal/corral state/viewport. Touch expands and pauses gameplay/music/timer; touching expanded map resumes, no lasso charge. Native screen input interception required because joysticks otherwise consume touches before Control input. Windowed native event test passes; not a finger-on-device test.

## Evidence and caveats
- Release sweep/restoration/recapture3tests10assertions.
- Geometry/bounds/out-of-old-grid/tow2tests165assertions.
- Real player latch and goal physical roundtrip18=8.7s out390s budget. Other bulls explicitly frozen: proves geometry/timing, not live herd difficulty.
- Courier4tests20assertions; master20budget expanded40to80s due longer route, not teleport/speed boost. All8latches physically visited.
- Minimap windowed2tests13assertions.
- Tow recovery2tests207assertions; door fairness2tests5assertions.
- Accelerated full run297tests293pass,4runner-specific failures. Same no-window bullet failure verified on unchanged0.21.18baseline earlier. Affected bullet/smoke/music groups pass50tests226assertions in real-window/real-clock mode. No single all-green full-run claim. Later minimap tests counted separately, do not add overlapping totals.
- Local software renderer18median32.7ms/p9538.3/draw336;20median33.5/p9588.9/draw388. NotAndroidFPS. Grid cost and spikes still require device validation.

Visual samples large18-review2,large18-map2-mini/expanded and map2video inspected and sent for user preview before APK. Actual gameplay balance, touch ergonomics and mobile performance remain provisional. No extra obstacles added merely to fill space. User requested maps and explicitly approved minimap; no permission to merge main.
