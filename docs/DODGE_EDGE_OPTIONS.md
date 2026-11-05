# Regate screen-edge comparison,5Nov11:21
Local branchfix/dodge-screen-edge based0.21.21. Not released, not main. User requested fix left edge then proposed continuation when finger stationary and asked advice vs alternatives. Parent has recommendation, choice open. Do not treat early prototype as approved.

Current freehand accumulates screen displacement from second movement tap; left-side start naturally has little leftward room. Existing floating movement joystick does not solve freehand positional range.

Prototype here: accumulate virtual delta and extend only when pointer is in28pxphysical edge and latest motion points outward. Move inward stops extension without snapping virtual origin back. Still260/420max and2real-second drawing limit, release executes shared preview. One symmetric unit test4assertions passes, no native touch sample yet. Prototype needs dwell/visible cue and stronger safety validation before use. Do not export as finished.

Recommendation to main: preserve direct freehand, use edge-only extension with deliberate short dwell and visible cue. Finger stationary centrally should remain drawing pause. User proposal stationary-anywhere is useful for long straight but converts distance to time, can extend accidentally while thinking, complicates Z/circles. If chosen, last direction rather than initial direction, minimum movement+dwell and visible cue. Joystick velocity alternative solves edge but changes gesture vocabulary. Bigger sensitivity amplifies drift; new button consumes space. No universal comfort claim.

Inspected sources:
https://docs.unity3d.com/Packages/com.unity.inputsystem%406.7/manual/create-on-screen-stick-control.html describes static/relative/dynamicorigin sticks.
https://developer.apple.com/videos/play/wwdc2024/10085/ recommends broad input areas, safe areas, visible feedback and physical device testing. Neither specifies this custom dodge or proves preferred design.

Await parent/user choice; preserve maps/minimap approved system. NoAPK/main effects.
