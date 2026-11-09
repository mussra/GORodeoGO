class_name HorsePicker
extends RefCounted
## Shared horse selector: every option has an image, selected horse has a preview.
static func thumbnail(h:Dictionary)->Texture2D:
 var foal:bool=h.get("stage","adult")=="foal"
 return HorseAppearance.texture(load("res://art/foal/base.png" if foal else "res://art/player/walk_diag_down/frame_00.png"),"foal" if foal else "walk_diag_down",0,h.traits)
static func preview(host:Control,h:Dictionary,pos:Vector2,extent:float)->TextureRect:
 var view:=TextureRect.new();view.name="HorsePreview";view.mouse_filter=Control.MOUSE_FILTER_IGNORE;view.expand_mode=TextureRect.EXPAND_IGNORE_SIZE;view.stretch_mode=TextureRect.STRETCH_KEEP_ASPECT_CENTERED;view.position=pos;view.size=Vector2.ONE*extent
 if not h.is_empty():
  if h.get("stage","adult")=="foal":view.texture=thumbnail(h)
  else:HorsePortrait.apply(view,h.traits,SaveData.hat_color)
 host.add_child(view);return view
static func create(host:Control,horses:Array,current:String,pos:Vector2,width:float,changed:Callable)->OptionButton:
 var pick:=OptionButton.new();pick.name="HorsePicker";pick.auto_translate_mode=Node.AUTO_TRANSLATE_MODE_DISABLED;pick.position=pos;pick.size=Vector2(width,64);pick.add_theme_constant_override("icon_max_width",56);pick.get_popup().add_theme_constant_override("icon_max_width",56);host.add_child(pick)
 for h in horses:
  pick.add_icon_item(thumbnail(h),h.name);pick.set_item_metadata(pick.item_count-1,h.id)
  if h.id==current:pick.select(pick.item_count-1)
 pick.item_selected.connect(func(i:int):changed.call(str(pick.get_item_metadata(i))))
 return pick
