class_name EmblemPanel
extends Control
signal saved
var horse_id:String="original"
var config:Dictionary={}
var content:Control
var canvas:Control
var note:String=""
var dirty:bool=false
func _ready()->void:
 set_meta("back_closes",false);set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT);z_index=95
 var horse:Dictionary=SaveData.horse_collection.find(horse_id);config=horse.traits.get("emblem",HorseEmblem.DEFAULT).duplicate(true)
 var bg:=ColorRect.new();bg.color=Color("10252d");bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT);add_child(bg)
 canvas=Control.new();canvas.size=Vector2(1280,720);add_child(canvas);resized.connect(layout);layout();build()
func layout()->void:
 var k:float=minf(size.x/1280,size.y/720);canvas.scale=Vector2.ONE*k;canvas.position=(size-Vector2(1280,720)*k)/2
func label(text:String,pos:Vector2,font:int=22)->Label:
 var l:=Label.new();l.text=text;l.position=pos;l.add_theme_font_size_override("font_size",font);content.add_child(l);return l
func button(text:String,pos:Vector2,cb:Callable,width:int=260)->Button:
 var b:=Button.new();b.text=text;b.position=pos;b.size=Vector2(width,48);b.pressed.connect(cb);content.add_child(b);return b
func _refresh_portrait()->void:
 var pv:TextureRect=content.find_child("portrait_view",false,false)
 if pv==null:return
 var h2:Dictionary=SaveData.horse_collection.find(horse_id)
 var t2:Dictionary=h2.traits.duplicate(true);t2["emblem"]=config
 HorsePortrait.apply(pv,t2,SaveData.hat_color)

func pick(key:String,title:String,items:Array,pos:Vector2)->void:
 label(title,pos,21);var option:=OptionButton.new();option.position=pos+Vector2(0,30);option.size=Vector2(300,48)
 for item in items:option.add_item(tr(item))
 option.select(config[key]);content.add_child(option)
 option.item_selected.connect(func(i:int):config[key]=i;dirty=true;build.call_deferred())
func build()->void:
 if is_instance_valid(content):canvas.remove_child(content);content.queue_free()
 content=Control.new();canvas.add_child(content)
 label(tr("EMBLEM_TITLE"),Vector2(30,20),30);button(tr("UI_009"),Vector2(1010,20),request_close,240)
 var h:Dictionary=SaveData.horse_collection.find(horse_id)
 label(str(h.name),Vector2(35,80),25)
 var traits:Dictionary=h.traits.duplicate(true);traits["emblem"]=config
 var view:=TextureRect.new();view.name="portrait_view";view.position=Vector2(15,115);view.size=Vector2(520,530);view.expand_mode=TextureRect.EXPAND_IGNORE_SIZE;view.stretch_mode=TextureRect.STRETCH_KEEP_ASPECT_CENTERED;HorsePortrait.apply(view,traits,SaveData.hat_color);content.add_child(view)
 pick("shape",tr("EMBLEM_SHAPE"),["EMBLEM_CLASSIC","EMBLEM_ROUND","EMBLEM_FLAT"],Vector2(560,100))
 pick("division",tr("EMBLEM_DIVISION"),["EMBLEM_SINGLE","EMBLEM_SPLIT","EMBLEM_DIAGONAL"],Vector2(900,100))
 var symbols:Array=["EMBLEM_SUN","EMBLEM_SIERRA","EMBLEM_DIAMOND","EMBLEM_CROSS","EMBLEM_WAVE"]
 pick("left",tr("EMBLEM_SYMBOL_A"),symbols,Vector2(560,210));pick("right",tr("EMBLEM_SYMBOL_B"),symbols,Vector2(900,210))
 pick("color",tr("EMBLEM_COLOR"),["EMBLEM_TEAL","EMBLEM_COPPER","EMBLEM_BLUE","EMBLEM_LILAC","EMBLEM_GOLD"],Vector2(560,320))
 var swatch:=ColorRect.new();swatch.color=Color(HorseEmblem.COLORS[config.color]);swatch.position=Vector2(1050,445);swatch.size=Vector2(55,45);content.add_child(swatch)
 var badge:=TextureRect.new();badge.texture=HorseEmblem.mask(config);badge.modulate=Color(HorseEmblem.COLORS[config.color]);badge.position=Vector2(1120,430);badge.size=Vector2(96,96);badge.expand_mode=TextureRect.EXPAND_IGNORE_SIZE;content.add_child(badge)
 badge.mouse_filter=Control.MOUSE_FILTER_STOP
 badge.gui_input.connect(func(e:InputEvent):
  if e is InputEventMouseMotion and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
   config["symbol_dx"]=clampi(HorseEmblem.symbol_dx(config)+int(round(e.relative.x*100.0/96.0)),-HorseEmblem.SYMBOL_DX_RANGE,HorseEmblem.SYMBOL_DX_RANGE)
   config["symbol_dy"]=clampi(HorseEmblem.symbol_dy(config)+int(round(e.relative.y*100.0/96.0)),HorseEmblem.SYMBOL_DY_MIN,HorseEmblem.SYMBOL_DY_MAX)
   badge.texture=HorseEmblem.mask(config)
   _refresh_portrait()
   dirty=true)
 var adj:=label(tr("EMBLEM_SYMBOL_ADJ"),Vector2(1050,528),14)
 adj.clip_text=true;adj.size=Vector2(200,36);adj.autowrap_mode=TextServer.AUTOWRAP_WORD_SMART
 var sizepick:=HSlider.new();sizepick.position=Vector2(1050,568);sizepick.size=Vector2(190,22)
 sizepick.min_value=HorseEmblem.SYMBOL_SCALE_MIN;sizepick.max_value=HorseEmblem.SYMBOL_SCALE_MAX;sizepick.step=0.05
 sizepick.value=HorseEmblem.symbol_scale(config);content.add_child(sizepick)
 sizepick.value_changed.connect(func(v:float):
  config["symbol_scale"]=v
  badge.texture=HorseEmblem.mask(config)
  _refresh_portrait()
  dirty=true)
 label(tr("EMBLEM_LETTERS"),Vector2(900,320),21)
 var entry:=LineEdit.new();entry.auto_translate_mode=Node.AUTO_TRANSLATE_MODE_DISABLED
 entry.text=str(config.get("letters",""));entry.max_length=3;entry.placeholder_text=tr("EMBLEM_LETTERS_HINT")
 entry.position=Vector2(900,350);entry.size=Vector2(170,44);content.add_child(entry)
 entry.text_changed.connect(func(v:String):
  var up:=v.to_upper()
  if entry.text!=up:entry.text=up;entry.caret_column=up.length()
  config["letters"]=up
  _refresh_portrait()
  dirty=true)
 var fontpick:=OptionButton.new();fontpick.position=Vector2(1080,350);fontpick.size=Vector2(160,44)
 for f in ["EMBLEM_FONT_BLOCK","EMBLEM_FONT_ENGRAVED"]:fontpick.add_item(tr(f))
 fontpick.select(int(config.get("letters_font",0))%2);content.add_child(fontpick)
 fontpick.item_selected.connect(func(i:int):config["letters_font"]=i;dirty=true;build.call_deferred())
 var contrast:=label(tr("EMBLEM_CONTRAST"),Vector2(560,445),20)
 contrast.clip_text=true;contrast.size=Vector2(470,92);contrast.autowrap_mode=TextServer.AUTOWRAP_WORD_SMART
 var cosmetic:=label(tr("EMBLEM_COSMETIC"),Vector2(560,542),19)
 cosmetic.clip_text=true;cosmetic.size=Vector2(470,62);cosmetic.autowrap_mode=TextServer.AUTOWRAP_WORD_SMART
 button(tr("EMBLEM_SAVE"),Vector2(560,614),func():
  if SaveData.set_horse_emblem(horse_id,config):dirty=false;note=tr("EMBLEM_SAVED");saved.emit()
  else:note=tr("MARKET_FAILED")
  build.call_deferred(),300)
 button(tr("EMBLEM_REMOVE"),Vector2(900,614),func():
  var dialog:=ConfirmationDialog.new();dialog.dialog_text=tr("EMBLEM_REMOVE_ASK");add_child(dialog);dialog.confirmed.connect(func():
   if SaveData.set_horse_emblem(horse_id,{}):dirty=false;saved.emit();queue_free()
   else:note=tr("MARKET_FAILED");build.call_deferred()
   dialog.queue_free());dialog.canceled.connect(dialog.queue_free);dialog.popup_centered(),300)
 label(note if not note.is_empty() else tr("EMBLEM_DRAFT"),Vector2(560,676),20)
func request_close()->void:
 if not dirty:queue_free();return
 var dialog:=ConfirmationDialog.new();dialog.dialog_text=tr("EMBLEM_DISCARD");dialog.get_ok_button().text=tr("EMBLEM_DISCARD_YES");add_child(dialog);dialog.confirmed.connect(queue_free);dialog.canceled.connect(dialog.queue_free);dialog.popup_centered()
