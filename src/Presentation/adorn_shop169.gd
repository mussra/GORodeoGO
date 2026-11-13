class_name AdornShop169
extends Control
var canvas:Control
var balance:Label
var status:Label
var details:Array[Label]=[]
var buys:Array[Button]=[]
var equips:Array[Button]=[]
var previews:Array[TextureRect]=[]
var slots:Array[String]=["both","legs","boots"]
func _ready():
 MenuInputGuard.install(self);set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT);z_index=70
 var bg:=ColorRect.new();bg.color=Color("10252d");bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT);add_child(bg)
 canvas=Control.new();canvas.size=Vector2(1280,720);add_child(canvas)
 _label("ADORNOS DE ORO Y PLATA",Vector2(35,18),30)
 balance=_label("",Vector2(35,67),20);balance.size=Vector2(1200,56)
 _button("Volver",Vector2(1060,18),Vector2(180,44),queue_free)
 for i in 2:
  var metal:String=["silver","gold"][i];var x:float=40.+i*625.
  _label("Plata" if metal=="silver" else "Oro",Vector2(x,120),27)
  var preview:=TextureRect.new();preview.position=Vector2(x,154);preview.size=Vector2(275,275);canvas.add_child(preview);previews.append(preview)
  var detail:=_label("",Vector2(x+280,175),20);detail.size=Vector2(275,225);details.append(detail)
  buys.append(_button("",Vector2(x,435),Vector2(560,48),func():
   status.text="Ya puedes usar este metal en patas y botas." if SaveData.buy_adorn169(metal) else "Todavía falta camino para conseguirlo, o no se pudo guardar."
   refresh()))
  for j in 3:
   var slot:String=slots[j]
   equips.append(_button("",Vector2(x,493+j*48),Vector2(560,42),func():
    status.text="Adornos equipados." if SaveData.equip_adorn169(SaveData.horse_collection.selected,slot,metal) else "No se pudo equipar."
    refresh()))
 status=_label("",Vector2(35,642),18);status.size=Vector2(720,70)
 _button("Quitar patas",Vector2(775,655),Vector2(215,43),func():_remove("legs"))
 _button("Quitar botas",Vector2(1010,655),Vector2(230,43),func():_remove("boots"))
 resized.connect(_layout);_layout();refresh()
func _remove(slot:String):
 status.text="Adorno retirado." if SaveData.equip_adorn169(SaveData.horse_collection.selected,slot,"") else "No se pudo quitar."
 refresh()
func _label(text_:String,pos:Vector2,font:int)->Label:
 var l:=Label.new();l.autowrap_mode=TextServer.AUTOWRAP_WORD_SMART;l.size=Vector2(900,80);l.text=text_;l.position=pos;l.add_theme_font_size_override("font_size",font);canvas.add_child(l);TextFit181.fixed(l,l.size,font,18,3);return l
func _button(text_:String,pos:Vector2,size_:Vector2,callback:Callable)->Button:
 var b:=Button.new();b.text=text_;b.position=pos;b.size=size_;b.pressed.connect(callback);canvas.add_child(b);return b
func _layout():
 if canvas==null:return
 var k:float=minf(size.x/1280.,size.y/720.);canvas.scale=Vector2.ONE*k;canvas.position=(size-Vector2(1280,720)*k)/2.
func refresh():
 var horse:Dictionary=SaveData.horse_collection.find(SaveData.horse_collection.selected)
 balance.text="%d puntos · %d cerdos · %d cabras · %d encargos cobrados\n%s · Patas: %s · Botas: %s"%[SaveData.equipment_points,SaveData.world_pig_captures.size(),SaveData.world_goat_captures.size(),SaveData.repeat_contract165.completed,horse.get("name",""),HorseAdorn169.NAMES[HorseAdorn169.IDS.find(HorseAdorn169.metal(horse,"legs"))],HorseAdorn169.NAMES[HorseAdorn169.IDS.find(HorseAdorn169.metal(horse,"boots"))]]
 for i in 2:
  var metal:String=["silver","gold"][i];var id:String="adorn_"+metal;var item:Dictionary=ProgressionEconomy165.EXTRAS[id];var owned:bool=SaveData.equipment_owned.has(id)
  var preview:Dictionary=horse.duplicate(true);preview.leg_adorn169=metal;preview.boot_adorn169=metal;HorsePortrait.apply_horse(previews[i],preview,SaveData.hat_color)
  details[i].text="%d puntos\n%d cerdos · %d cabras\n%d encargos cobrados\n\nCompra única para patas y botas. Los logros no se gastan."%[item.price,item.pigs,item.goats,item.contracts]
  buys[i].text="YA CONSEGUIDO" if owned else "Comprar · %d puntos"%item.price
  buys[i].disabled=owned or not ProgressionEconomy165.missing(id,SaveData.equipment_points,SaveData.world_pig_captures.size(),SaveData.world_goat_captures.size(),int(SaveData.repeat_contract165.completed)).is_empty() or SaveData.trial_session_active
  for j in 3:
   var equipped:bool=(HorseAdorn169.metal(horse,"legs")==metal and HorseAdorn169.metal(horse,"boots")==metal) if j==0 else HorseAdorn169.metal(horse,slots[j])==metal
   equips[i*3+j].text=("EQUIPADO · " if equipped else "Equipar · ")+["Patas y botas","Solo patas","Solo botas"][j]
   equips[i*3+j].disabled=not owned or equipped or not SaveData.horse_collection.is_adult(str(horse.get("id",""))) or SaveData.trial_session_active
func _unhandled_input(event:InputEvent):
 if event.is_action_pressed("ui_cancel"):queue_free();get_viewport().set_input_as_handled()
