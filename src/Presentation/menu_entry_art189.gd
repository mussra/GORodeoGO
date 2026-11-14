class_name MenuEntryArt189
extends RefCounted
## Ant supplied art, shared by navigation cards and main menu buttons.
static var cache:Dictionary={}
const PATHS={"atlas":"res://art/ui/menu_entries189/atlas.png","frontier":"res://art/ui/menu_entries189/frontier.png","levels":"res://art/ui/menu_entries189/levels.png"}
static func texture(kind:String)->Texture2D:
 if not PATHS.has(kind) or not ResourceLoader.exists(PATHS[kind]):return null
 if not cache.has(kind):cache[kind]=load(PATHS[kind])
 return cache[kind]
static func apply(button:Button,kind:String)->void:
 button.set_meta("entry_art189",kind)
 button.expand_icon=true
 button.add_theme_constant_override("icon_max_width",44)
 button.add_theme_constant_override("h_separation",14)
 button.icon=texture(kind)
