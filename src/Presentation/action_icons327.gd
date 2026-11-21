class_name ActionIcons327
extends RefCounted
## Approved image may replace both icons without duplicating their controls.
const ATLAS_PATH327="res://art/action_buttons327.png"
static func texture327(cell:int)->Texture2D:
 if not ResourceLoader.exists(ATLAS_PATH327):return null
 var source:Texture2D=load(ATLAS_PATH327)
 if source.get_width()!=1024 or source.get_height()!=512:return null
 var atlas:=AtlasTexture.new();atlas.atlas=source;atlas.region=Rect2(cell*512,0,512,512);return atlas
static func attach327(button:Button,cell:int)->void:
 var icon:=texture327(cell)
 if icon==null:return
 var old=button.get_node_or_null("WhipArt271")
 if old!=null:old.hide()
 var art:=TextureRect.new();art.name="ActionArt327";art.expand_mode=TextureRect.EXPAND_IGNORE_SIZE;art.texture=icon;art.position=Vector2(12,2);art.size=Vector2(88,76);art.stretch_mode=TextureRect.STRETCH_KEEP_ASPECT_CENTERED;art.mouse_filter=Control.MOUSE_FILTER_IGNORE;button.add_child(art)
 var label:=Label.new();label.name="ActionLabel327";label.position=Vector2(2,78);label.size=Vector2(108,28);label.horizontal_alignment=HORIZONTAL_ALIGNMENT_CENTER;label.add_theme_font_size_override("font_size",13);label.add_theme_color_override("font_color",Color("30200d"));label.mouse_filter=Control.MOUSE_FILTER_IGNORE;button.add_child(label)
