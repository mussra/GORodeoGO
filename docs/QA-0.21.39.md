# Rancho Prueba 0.21.39

Requested APK checkpoint, not a final art sign-off. Separate branch, no merge to main.

Included:
- Soft foal rainbow palette for adult gameplay sprites and selected horse portraits.
- Adult tail/sock mask separation and organic foal rump-tail boundary.
- Repeated random pairs in isolated trial, including after breeding; real collection and save preserved.
- Last selected horse and hat shown on menu return and after a new process starts.
- Hidden-face HD adult in menu, horse collection and hat previews. Source art preserved.
- Equipped whip named in text. No invented whip illustration.
- Compact corral latch separation correction for levels 11-14 only, retaining groups and gates.

Checks: 40 directed tests / 26,220 assertions pass. ScreenTouch map/double-tap tests run graphically. Repeated Add2 touch input after breeding, long-list scroll and save-byte restoration pass. Two independent processes verify selected horse, hat and functional whip state. Geometry latch opening rendered and tested at levels 11-14; capture/tow delivery tests also pass.

Caveats: HD portrait masks remain a partial visual trial. Fine edge remnants around fringe, bridle, hat and socks may remain. No claim of complete pixel cleanup. Whip is text-only in portrait view. List rebuilding still emits can_process warnings and some review scripts report ObjectDB exit leaks. Not a clean global suite, not tested on physical Android. Desktop touch tests do not certify phone performance or touch sizing. No new gallop, powers, genetics, maps or balance rules.

Android: com.example.rancho.review; versionCode 249; versionName 0.21.39. Same signing certificate as 0.21.38, alignment checked at 16KB. Update without uninstalling to retain data.
