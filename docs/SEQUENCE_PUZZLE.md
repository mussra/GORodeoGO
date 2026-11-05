#0.21.25: sequence consequences and persistent opener
Based0.21.24, no main merge. Logo correction is separate and NOT included pending aesthetic feedback.

## New intent, not a fixed numeric interpretation
User wants opening order to be a puzzle: smaller tempting herd releases larger, observing links suggests safer sequencing. Example4/6/3was illustrative, not exact specification. First reversible20uses2/3/5, same10and450s. Small1sends opener to large3; medium2independent. Compared3/4/5prototype briefly;12bulls not needed because catching/holding opener is a valid control choice, not something to prohibit by insisting one always escapes. No population increase.15-19unchanged this iteration; later sequence design should follow feedback, not retrofit all blindly.

Expanded map now showsNº(toros)and directional links before opening, making consequence inspectable. Smallmap/pause unchanged. Floor trail still contextual, avoids whole-network drawing load.

## Persistent opener
Capture pauses rather than erases the same bull's pending targets. Release resumes from actual position using physical collision-aware route. Retry failures0.35sperbull, not everyframe. Ordinary chase director excludes pending openers. Manual target opening retires task. Permanent secure delivery retires task too; this is a valid way to neutralise consequence, not a permanent cancellation by mere capture. No teleport, immunity, unavoidable release, or replacement bull spawned. Existing no-cascade-on-linked-arrival rule retained.

## Release speed
Released wild bull returns at ordinary flee_speed even if partially calm. Controller nerves and visual calm remain. No global speed increase, no resetting nerves to100. Courier already travels its ordinary speed.

## Evidence
Orders/control tests: small-first physically releases large, seven wild vs medium-first keeping others shut; holding opener prevents release without erasing task; release eventually opens target; small-last after target open creates no stale route; repeated capture/release3times, manual destination cleanup, secure-delivery cleanup. These show consequences and control, not a proven optimal full human solution or complete10bullrun.

Full final316tests309pass7fail: six acceleratedclock/nativeinput cases covered real-window/realtime54tests269asserts; one geometry test flags five preexisting11-14interactionproximities, prior physical approach repro1/8passes. Do not claim a single green full suite. Resource shutdown warnings persist. Live-herd pursuit/tow15-19passes within broad suite, with ordinary release speed now restored. NoAndroidFPS/touchfeelcertification.

Previewmap and directed opener capture/release movie inspected and delivered beforeAPK. Video uses scripted impacts, not human gesture evidence. Updated brand preview is outside this candidate pending approval.
