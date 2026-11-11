class_name HorsePicker
extends RefCounted
## Shared horse selector: every option has an image, selected horse has a preview.
static func thumbnail(h:Dictionary)->Texture2D:
 var foal:bool=h.get("stage","adult")=="foal"
 return HorseAppearance.texture(load("res://art/foal/base.png"),"foal",0,h.traits) if foal else PixelLabTrial.pose_texture("rider","diag_down",0,h.traits,h)
static func preview(host:Control,h:Dictionary,pos:Vector2,extent:float)->TextureRect:
 var view:=TextureRect.new();view.name="HorsePreview";view.mouse_filter=Control.MOUSE_FILTER_IGNORE;view.expand_mode=TextureRect.EXPAND_IGNORE_SIZE;view.stretch_mode=TextureRect.STRETCH_KEEP_ASPECT_CENTERED;view.position=pos;view.size=Vector2.ONE*extent
 if not h.is_empty():
  HorsePortrait.apply_horse(view,h,SaveData.hat_color)
 host.add_child(view);return view
static func create(host:Control,horses:Array,current:String,pos:Vector2,width:float,changed:Callable)->OptionButton:
 var pick:=OptionButton.new();pick.name="HorsePicker";pick.fit_to_longest_item=false;pick.clip_text=true;pick.auto_translate_mode=Node.AUTO_TRANSLATE_MODE_DISABLED;pick.position=pos;pick.size=Vector2(width-164,64);pick.add_theme_constant_override("icon_max_width",56);pick.get_popup().add_theme_constant_override("icon_max_width",56);host.add_child(pick)
 for h in horses:
  pick.add_icon_item(thumbnail(h),h.name);pick.set_item_metadata(pick.item_count-1,h.id)
  if h.id==current:pick.select(pick.item_count-1)
 var pager=ItemPager.create(host,pos+Vector2(width-156,4),156,maxi(0,pick.selected),horses.size(),func(i:int):pick.select(i);changed.call(str(pick.get_item_metadata(i))))
 pick.item_selected.connect(func(i:int):pager.set_state(i,horses.size());changed.call(str(pick.get_item_metadata(i))))
 return pick
