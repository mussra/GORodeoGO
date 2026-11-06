# Android menu touch incident0.21.32

Ant reported all menu buttons unresponsive on actual phone6Nov07:02. Reproduced with native ScreenTouch events through real menu: EQUIPO/LEVELSfalse; mouse event EQUIPOtrue. Project disabled emulate_mouse_from_touch, so regular Control buttons lacked mouse events on touch devices. Prior validation emitted signals or only tested specific scenes, not full startup touch journey. This was insufficient.

Fix branch based on0.21.32, excluding unapproved adult menu gallop. Enable mouse emulation from touch. Minimap already processes native touch; emulated mouse caused second toggle, so ignore only DEVICE_ID_EMULATION in its GUI mouse handler. Keep native touch path and real mouse path.

Real startup through logo, native ScreenTouch at control global centers: EQUIPO, BACK, LEVELS, close, PLAY→level, PAUSE/CONTINUE, return menu, EXIT process all pass. No pressed signal emission.22focused tests128assertions pass after minimap fix. Godot/GUTdev compatibility helper errors still exist, not global suite clean.

Android APK validation remains BLOCKED: no connected physical device; installed emulator/API35x86_64, but refuses startup for insufficient RAM even768MB without hardware acceleration. No claim of phone repair or APK tested on Android. Preserve progress, do not uninstall. No replacement APK delivered yet. Foal artwork rejected; redesign is separate visual review task, not folded into hotfix.
