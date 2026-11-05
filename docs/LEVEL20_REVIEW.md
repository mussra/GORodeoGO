# In-progress correction5Nov07:51-07:56
Branch fix/level20-performance, based validated0.21.18 d824465 now main. NOT published or main merged.

Measured local software-render baseline: level1median27ms/158draw calls, level20median80ms/4258draw calls. Rebuilding/overdrawing thousands of route hoofprints was one identified load, not proof of sole Android cause. Static batch intermediate46ms/291draw calls. New focused cartoon dirt trail prototype31ms/289draw calls. Local no-vsync harness, not AndroidFPS or controlled device benchmark. Final artwork needs visual validation.

Paths: wide cartoon dirt/shoulder trail, only nearest linked closed latch or active courier next leg, source/destination wooden signs. Avoids stacking complete network. Concept could hide some branches until approached; report this judgment to main/user, not claiming all dependencies visible at once. Runtime static draw commands rebuilt only when displayed leg changes. Underlying route membership/messenger kept.

Door rush reproduced at11: standing at actual latch and opening stuns player within35frames. Prototype adds0.75s visible release warning before first bull, retains1.25s stagger; no invulnerability. Test passes warning window, stepping aside avoids initial rush, later contact still stuns. Not yet full visual/interaction regression certified.

Lasso: added LassoRope with curved braided-looking rope and visible ellipse loop, origin follows rider each render; flight0.8s vs1.0baseline (progress upgrade multiplier unchanged). No radius inflation: capture58px matches current visual58px. Near miss complaint may include target movement during old long flight or sprite perceived geometry; do not claim resolved merely by flight reduction. Need moving-bull/landing tests and visual hit/miss feedback. Rope design/movement sample still outstanding. Cancel/pause/regression tests pending broader run.

Preserve drafts. Pending requests: performance20, fair door release, cartoon legible paths, lasso feel/capture/rope/mobileorigin. Maps branch separate, not integrated. Main requested sample before APK and no premature partial complete release. No new APK/version yet.

## Follow-up08:04
Visuals inspected: corrections-review2.mp4, lasso-flight-review.png, door-warning-review.png. Parent received files. Ground target/radius remains visible during flight; air loop is intentionally separate from landing disc. Static inside57.9/outside58.1px cases and real flight moving from/to radius tested; no silent aim magnetism or larger radius. Four lasso tests12assertions. Actual latch hold followed by normal keyboard movement escapes warning, two door tests5assertions.

Warning delay exposed a courier deadlock: penned bull behind closed gate occupied destination latch centre. Previous8px approach demanded unreachable exact point. Same40px latch area as rider now accepted; physical grid approach chooses reachable clear point in that area, without skipping whole route or teleporting. Courier4tests20assertions pass, tow recovery2tests207assertions pass. Main aware.

Final same localsoftware-render harness median level1=27.0ms/158drawcalls,20=30.5ms/295drawcalls,p9520=92.3ms. Baseline20=80.5ms/4258drawcalls. Still no AndroidFPS guarantee; spikes remain.

Full accelerated fixed-fps run289tests4468assertions:285pass,4fail in real-clock/audio-sensitive groups (bullet freehand,tap spacing,music2). Earlier standalone real-clock smoke44/197 and music2/15 pass. Bullet group under investigation; do not call full regression green. Full real-clock attempt hit120s execution timeout before completion. Path style user's decision still pending, do not publish as approved.

Bullet input failure localized to no-window runner: same failure on unchanged validated d824465 baseline, while actual1280x720 window passes4tests14assertions. Use window for native touch routing. Thus full accelerated run's4failures are runner-sensitive, with each affected group passing suitable standalone mode. No claim of one all-green full run.

Separate20-mode investigation: bull AI/physics active median process30.8ms, physics0.72ms; with bull physics frozen process31.2ms, physics0.36ms. No evidence to justify cutting herd count. Renderer dominates this local software run; separate p95 values noisy and should not be compared as device claims. Parent should retain device caveat.

Final focused trail test1/5 passes: only nearest linked (not just nearest plain latch), stable first selected courier when another starts, cleanup after manual opening. Skip queued-for-free already-open latch objects immediately to prevent one-frame stale paths. Lasso windowed real-time group4/12 also passes. No Android device test. Source remains review branch only, no maps merge or release.
