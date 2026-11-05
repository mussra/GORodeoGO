# Dodge handoff and sequential selection candidate

Request5Nov20:12: continue running after dodge, current joystick preferred, otherwise the last dodge direction. Keep levels sequential and saved wins.

The old freeform path eased to25px/s and set velocity to zero at its endpoint. New path eases no lower than ordinary running speed. On completion it hands off to normal run velocity, honoring the two-capture penalty. If the stick is released from tracing, the final segment direction continues; the next normal joystick gesture takes over, and its release stops normally. Stun/pause/cancel stop continuation. Collision still ends the trace and does not force a run through a fence. No immunity added.

Menu no longer bypasses level locks in debug. Selection handler checks the same rule. No save reset or changes to save format.

35 focused tests239 assertions in a windowed engine run: upgrades/progression/save/menu/dodge/bullet-time/native edge touch. Includes handoff delta inputs30/60/120but move_and_slide still uses the engine physics tick in that unit test; not a full rendering/performance certification at those frame rates. Native touch review video uses actual input events and real player scene, fixed-time movie with frozen bulls to isolate handoff. Not Android hardware or evasive play validation.

A direct fusta-at-level10 prototype was superseded before publication by the user's points proposal20:15. It is not included. Equipment economy is pending reward/price design and migration decision. No release or new APK yet.
