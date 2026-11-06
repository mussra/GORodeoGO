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
 var view:=TextureRect.new();view.position=Vector2(15,115);view.size=Vector2(520,530);view.expand_mode=TextureRect.EXPAND_IGNORE_SIZE;view.stretch_mode=TextureRect.STRETCH_KEEP_ASPECT_CENTERED;HorsePortrait.apply(view,traits,SaveData.hat_color);content.add_child(view)
 pick("shape",tr("EMBLEM_SHAPE"),["EMBLEM_CLASSIC","EMBLEM_ROUND","EMBLEM_FLAT"],Vector2(560,100))
 pick("division",tr("EMBLEM_DIVISION"),["EMBLEM_SINGLE","EMBLEM_SPLIT","EMBLEM_DIAGONAL"],Vector2(900,100))
 var symbols:Array=["EMBLEM_SUN","EMBLEM_SIERRA","EMBLEM_DIAMOND","EMBLEM_CROSS","EMBLEM_WAVE"]
 pick("left",tr("EMBLEM_SYMBOL_A"),symbols,Vector2(560,210));pick("right",tr("EMBLEM_SYMBOL_B"),symbols,Vector2(900,210))
 pick("color",tr("EMBLEM_COLOR"),["EMBLEM_TEAL","EMBLEM_COPPER","EMBLEM_BLUE","EMBLEM_LILAC","EMBLEM_GOLD"],Vector2(560,320))
 var swatch:=ColorRect.new();swatch.color=Color(HorseEmblem.COLORS[config.color]);swatch.position=Vector2(920,350);swatch.size=Vector2(55,45);content.add_child(swatch)
 var badge:=TextureRect.new();badge.texture=HorseEmblem.mask(config);badge.modulate=Color(HorseEmblem.COLORS[config.color]);badge.position=Vector2(1030,330);badge.size=Vector2(90,90);badge.expand_mode=TextureRect.EXPAND_IGNORE_SIZE;content.add_child(badge)
 label(tr("EMBLEM_CONTRAST"),Vector2(560,445),20);label(tr("EMBLEM_COSMETIC"),Vector2(560,485),19)
 button(tr("EMBLEM_SAVE"),Vector2(560,550),func():
  if SaveData.set_horse_emblem(horse_id,config):dirty=false;note=tr("EMBLEM_SAVED");saved.emit()
  else:note=tr("MARKET_FAILED")
  build.call_deferred(),300)
 button(tr("EMBLEM_REMOVE"),Vector2(900,550),func():
  var dialog:=ConfirmationDialog.new();dialog.dialog_text=tr("EMBLEM_REMOVE_ASK");add_child(dialog);dialog.confirmed.connect(func():
   if SaveData.set_horse_emblem(horse_id,{}):dirty=false;saved.emit();queue_free()
   else:note=tr("MARKET_FAILED");build.call_deferred()
   dialog.queue_free());dialog.canceled.connect(dialog.queue_free);dialog.popup_centered(),300)
 label(note if not note.is_empty() else tr("EMBLEM_DRAFT"),Vector2(560,625),20)
func request_close()->void:
 if not dirty:queue_free();return
 var dialog:=ConfirmationDialog.new();dialog.dialog_text=tr("EMBLEM_DISCARD");dialog.get_ok_button().text=tr("EMBLEM_DISCARD_YES");add_child(dialog);dialog.confirmed.connect(queue_free);dialog.canceled.connect(dialog.queue_free);dialog.popup_centered()
