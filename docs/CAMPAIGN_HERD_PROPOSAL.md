# Campaign pressure review, after0.21.23
Working design, not active catalog changes or final balance approval.

## What to preserve
Ten bulls ceiling in existing scenes, dual capture,450slevel20and existing per-level clocks until measured. Big arenas, minimap, edge dodge and current art. Latches remain physical, courier catchable, contacts stun/drop. More challenge through concurrent threats, not accidental path blockage or simply adding bulls.

## Audit
-11:3bulls/1gate. Intro with no links, leaves1after pair capture. Keep.
-12:2/3, no links. The pair is an intentional easy choice in first branching lesson; isolated escape remains, acceptable only as introduction.
-13:3/4, no links. Both releases leave a third threat. Keep basic grouping.
-14:3/3/3, no links. All openings leave threat. Keep grouping; measure actual play next.
-15/16:3/2/2/3. A source3loses1courier and leaves a capturable pair. Normal pairs can be cleared alone. Needs grouping.
-17:fivepairs. Sourcepair loses1courier, all otherpairs clearable. Needs grouping.
-18/19:sixcorrals2/2/2/2/1/1. Every linked source undermanned. Needs grouping.
-20 corrected0.21.23:4/3/3with master courier. First candidate, awaiting human feedback.

## Constraint that changes the design
A source needs at least4bulls to leave one wild companion after a courier and two captures. A normal group needs3. With10bulls, at most three meaningful groups fit, and only one of these can send a courier (4+3+3). Two groups can have5each and both send couriers. Three independent linked sources would require at least12bulls. Thus keep10and stop using door count as difficulty dial. Multiple couriers need deliberate two-source levels rather than fabricated extra links on groups of3.

## Small, testable next progression
15:two groups4/6, one-way link. Teaches split attention to courier plus companions, not four small isolated releases.
16:three groups4/3/3, one source opens two destinations. Introduces a fork.
17:two groups5/5, reciprocal links. Either opening starts a cross-map errand; other four companions remain. Teaches bidirectional risk without requiring more bulls.
18:three groups4/3/3, source opens only one destination, third remains independent. Choice between chain and independent risk. No claim that three groups is automatically harder than two.
19:three groups4/3/3, master opens both. Keep a distinct terrain/approach arrangement from20 only after testing actual interception/tow routes, otherwise it is a duplicate, not progression.
20:current candidate3groups4/3/3master. Need human feedback before declaring it harder than19. Potential differentiator: routes/approach positions, not faster bulls or extra timers by default.

## Current evidence and remaining work
Early latch/goal warning repro: levels11-14 rider can move from goal centre to northern latch, wait and open it. Physical position(-300,-88), latch(-320,-75). Interaction circles overlap but do not block movement. No reason for incidental geometry edits now. Test1/8passed.

New candidate20directed live-herd tests pass, but not human balance certification. Need comparable input-driven opening/capture/tow attempts on15-19, reproducible routes and threat time; keep all bulls live. Inspect complete-map and playing-scale visuals. Changes remain reversible before publishing another release. Do not call all campaign design finished merely because20is shipped.

## Implemented second candidate0.21.24
The five variants15-19above are now integrated as a reversible candidate.19mirrors approaches horizontally; no new walls.11-14unchanged.20preserves0.21.23. Same10bulls, clocks, rules, map scales, minimap, dodge and destination styling. No claim these five levels now form a perfectly monotonic human difficulty curve: lessons and risk choices are distinct, need user feedback.

Physical courier routes with live herd15→19complete in4.97/9.42/6.62/5.45/10.65s. Membership invariant sources4+normal3+passes all. Catalog/courier/corrals/geometry37tests606asserts before adding comparative attempts; after pair tests38/661.

Input-driven live-herd capture/evasion/tow test uses no bull teleport/frozen physics/forced nerves/invulnerability. Only initial rider setup, release trigger and scripted in-range lasso impacts. Normal input, existing dodge, actual capture/calming/contact/goal. One bull delivered per15→19in15.75/11.15/11.12/8.18/13.13s after3/2/2/2/2stuns. Recapture after contact is necessary. Does not prove all10completion, human aiming, touch comfort or final balance.30fpsvideo19takes17.23swith2stunsand1physicaldelivery; variation not hidden.

Full accelerated309tests302pass7fail. One test exposes5existing11-14interaction-proximity warnings, not blocked geometry (physical approach repro1test8asserts passes). Six clock/native-input failures covered separately by real-window/real-clock54tests269asserts. No single all-green/full-campaign-playthrough claim. Test updates remove obsolete6/8door indices and check actual arena bounds rather than old unscaled layout metadata. Shared resource warnings at shutdown persist.

Previews: overall15-19layout and real19live-herd tow video inspected and delivered beforeAPK. Android performance and human balancing still await feedback. No main merge. Follow-up should respond to actual play patterns, not hide unknowns behind more population or automatically reduce timers.
