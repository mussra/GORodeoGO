class_name FinishShop168
extends Control
var canvas:Control
var balance:Label
var status:Label
var details:Array[Label]=[]
var buys:Array[Button]=[]
var equips:Array[Button]=[]
var previews:Array[TextureRect]=[]
func _ready():
 MenuInputGuard.install(self);set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT);z_index=70
 var bg:=ColorRect.new();bg.color=Color("10252d");bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT);add_child(bg)
 canvas=Control.new();canvas.size=Vector2(1280,720);add_child(canvas)
 _label("ACABADOS ESPECIALES",Vector2(35,20),30)
 balance=_label("",Vector2(35,70),21)
 var back:=_button("Volver",Vector2(1060,20),Vector2(180,48),queue_free)
 for i in 3:
  var style:String=SpecialFinish145.IDS[i];var x:float=30.+i*420.
  _label(SpecialFinish145.NAMES[i],Vector2(x,120),25)
  var preview:=TextureRect.new();preview.position=Vector2(x,152);preview.size=Vector2(380,250);canvas.add_child(preview);previews.append(preview)
  var detail:=_label("",Vector2(x,405),19);detail.size=Vector2(380,115);details.append(detail)
  buys.append(_button("",Vector2(x,527),Vector2(380,52),func():
   status.text="Ya tienes este acabado." if SaveData.buy_finish168(style) else "Todavía falta camino para conseguirlo, o no se pudo guardar."
   refresh()))
  equips.append(_button("",Vector2(x,589),Vector2(380,48),func():
   status.text="Acabado equipado en tu caballo." if SaveData.equip_finish168(SaveData.horse_collection.selected,style) else "No se pudo equipar."
   refresh()))
 status=_label("",Vector2(35,650),20);status.size=Vector2(805,62)
 _button("Quitar acabado",Vector2(880,655),Vector2(360,45),func():SaveData.equip_finish168(SaveData.horse_collection.selected,"");refresh())
 resized.connect(_layout);_layout();refresh()
func _label(text_:String,pos:Vector2,font:int)->Label:
 var l:=Label.new();l.autowrap_mode=TextServer.AUTOWRAP_WORD_SMART;l.size=Vector2(900,100);l.text=text_;l.position=pos;l.add_theme_font_size_override("font_size",font);canvas.add_child(l);TextFit181.fixed(l,l.size,font,18,3);return l
func _button(text_:String,pos:Vector2,size_:Vector2,callback:Callable)->Button:
 var b:=Button.new();b.text=text_;b.position=pos;b.size=size_;b.pressed.connect(callback);canvas.add_child(b);return b
func _layout():
 if canvas==null:return
 var k:float=minf(size.x/1280.,size.y/720.);canvas.scale=Vector2.ONE*k;canvas.position=(size-Vector2(1280,720)*k)/2.
func refresh():
 var horse:Dictionary=SaveData.horse_collection.find(SaveData.horse_collection.selected)
 balance.text="%d puntos · %d cerdos · %d cabras · %d encargos cobrados · %s"%[SaveData.equipment_points,SaveData.world_pig_captures.size(),SaveData.world_goat_captures.size(),SaveData.repeat_contract165.completed,horse.get("name","")]
 for i in 3:
  var style:String=SpecialFinish145.IDS[i];var id:String="finish_"+style;var item:Dictionary=ProgressionEconomy165.EXTRAS[id];var owned:bool=SaveData.equipment_owned.has(id);var equipped:bool=HorseFinish168.style(horse)==style
  var preview:Dictionary=horse.duplicate(true);preview.special_finish168=style;HorsePortrait.apply_horse(previews[i],preview,SaveData.hat_color)
  details[i].text="%d puntos\n%d cerdos · %d cabras\n%d encargos cobrados\nLos logros no se gastan."%[item.price,item.pigs,item.goats,item.contracts]
  var missing:=ProgressionEconomy165.missing(id,SaveData.equipment_points,SaveData.world_pig_captures.size(),SaveData.world_goat_captures.size(),int(SaveData.repeat_contract165.completed))
  buys[i].text="YA CONSEGUIDO" if owned else "Comprar · %d puntos"%item.price
  buys[i].disabled=owned or not missing.is_empty() or SaveData.trial_session_active
  equips[i].text="EQUIPADO" if equipped else "Equipar en este caballo"
  equips[i].disabled=not owned or equipped or not SaveData.horse_collection.is_adult(str(horse.get("id",""))) or SaveData.trial_session_active
func _unhandled_input(event:InputEvent):
 if event.is_action_pressed("ui_cancel"):queue_free();get_viewport().set_input_as_handled()
