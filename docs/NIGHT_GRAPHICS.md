# Overnight graphics iteration, 4-5 November 2026

Separate experimental branch `improve/night-graphics`, based on delivered 0.21.16. Main and scrolling-map prototype are not merged.

## Current changes
- HD cowboy and horse on the futurist menu. A mesh-based continuous idle moves the upper silhouette with anchored hooves. This is a breathing/neck idle, not a newly drawn walking cycle.
- Gait experiment: six original key poses plus six single-source warped intermediate poses per direction, at twice the frame rate to preserve cycle duration. An earlier blended optical-flow experiment was rejected because it doubled hooves. This retained experiment still needs device review and does not establish anatomically perfect footwork.
- Dodge preview and trace use a light ribbon, short sparks and glow rather than the former simple line.
- Drawing a dodge slows world time to 0.24x for at most two real seconds. Releasing, cancelling, pausing, losing focus, leaving the player scene and game end restore normal time. Music remains unpitched.
- Long dodge is a free progress upgrade after completing level10, increasing the drawn path cap from260 to420world pixels. Provisional tuning, not demonstrated balance.
- Linked corrals show worn tracks/hoofprints. A released bull carries a small key marker and physically travels to the target latch before opening it. Master routes visit all configured targets without recursively triggering those targets' own links.
- Capture interrupts the courier job. Remaining latches can always be opened by the rider manually, so interruption does not lock progression.
- Head-on herd blockage causes a small inward sidestep, with ordinary collision physics retained. No teleport and no collision immunity.

## Verification limits
Godot/Linux renders and automated physics checks do not verify Android touch feel, device performance, anatomical quality or game balance. Native Android testing remains necessary. Original art is preserved by git history; 0.21.16 remains the stable fallback.

## Checkpoint 23:04 CET
273 tests / 4153 assertions pass in split runs (unit180; core integration50; remaining integration31; physical corrals6; courier3; bullet time3). Split runs avoid the single-command120second limit. Warnings: seven deprecated GUT calls and two leaked ObjectDB instances on some scene tests. No script/parser errors in the rendered iteration.

Visual inspection: menu silhouette and text at1280x720, third movie, bright Z preview, ground-track placement above the stations, enlarged gait poses. The mesh idle has tiny upper-body motion; no claim of a full new HD walking animation. New single-source intermediate gait poses are a retained experiment, with no doubled hoof blend visible in inspected crops. Full native-device frame-by-frame review remains outstanding.

## Checkpoint 23:53 CET
- The old futurist and cartoon labels only selected different menus, both loaded the same beige arena. The overnight branch now carries that futurist palette through the gameplay floor, corral steelwork, latches, stations and HUD. Cowboy/horse/bull identities and collision geometry remain unchanged.
- Ground hoofprints are more visible against the muted blue floor; the actual route stays above/below stations.
- Added y-sorted foreground corral rail to improve fence occlusion, rather than treating a collision pass as a visual pass.
- A new event test passes touches through the native joystick into the player, tests drawing at0.24x and restores1x on lift.4bullet-time tests14assertions pass in windowed Linux rendering; this is not Android-device verification.
- Interior-to-gate alignment prevents a courier starting off-centre from cutting diagonally into a wall. That fix exposed a new master-route blockage; the previous sidestep heuristic was insufficient. A local collision-aware grid detour now walks around actual walls/herd bodies, keeping normal collision masks and no teleport.4courier tests20assertions pass, including master route and simultaneous couriers/manual target retirement. The physics-query detour is only rebuilt on stalled progress, but Android cost remains unmeasured.
- Physical-corral regression tests were rerun separately because a batched82s+41s run exceeded the120s command budget.

## Checkpoint 01:46 CET - candidate0.21.17
Final16:9 movie and rail occlusion inspected.20:9 menu/gameplay inspected in previous pass. Local collision-query object reused to avoid thousands of allocations on a detour; no changed collision masks. Master and simultaneous courier tests rerun after this optimization,4/20pass. No real Android performance measurement is available.

Candidate APK: com.example.rancho.review, version0.21.17/code227, signed with the saved stable46bdcb... certificate used in0.21.15/16.16KB alignment verifies. APK contains HD art and imported gait assets. Android-device install/play still untested, no device connected.

## Final follow-through 04:49 CET
Four additional boundary tests /13 assertions pass against the released gameplay source:420px actual long-path cap, recharge cannot be bypassed, stun interrupts the path, stun during drawing restores1x, bullet time does not pitch music, pause/unpause restores both time and music independently. Total279tests/4173assertions across bounded runs. New tests/documentation only, no post-release gameplay edit.

One local stalled-route detour measured1.941ms on this Linux environment (27path points). This is a single sample, not a worst-case bound or an Android performance claim. Real phone performance/touch feel and player balance remain untested.

Rechecked live release: public prerelease0.21.17 retains oneFuturistAPK36,035,647bytes. Remote main remains7336ebb; published branch5d0974b. The local final test commit does not change the APK's gameplay. Final menu idle comparison inspected: upper silhouette moves subtly without moving planted hooves; this remains a limited idle rather than a new articulated HD walking cycle. Final trace screenshot inspected against the futurist arena. The game sprites remain the established stylized cowboy/horse/bulls, not replacements matching the more realistic HD menu.
