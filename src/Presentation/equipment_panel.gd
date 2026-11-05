class_name EquipmentPanel
extends Control
signal closed
var _canvas:Control
var _balance:Label
var _state:Label
var _buy:Dictionary={}
var _equip:Dictionary={}
func _ready()->void:
 set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
 z_index=50
 var bg:=ColorRect.new();bg.color=Color("10252d");bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT);add_child(bg)
 _canvas=Control.new();_canvas.size=Vector2(1280,720);add_child(_canvas)
 _label("EQUIPO · VERSIÓN DE PRUEBA",Vector2(40,24),32)
 _label("Gana puntos al completar niveles, también al repetir. Avanzar da más puntos.",Vector2(40,75),21)
 _balance=_label("",Vector2(40,125),26)
 var back:=_button("VOLVER",Vector2(1020,24),func():hide();closed.emit())
 back.size=Vector2(220,45)
 var ids=["whip_basic","whip_long"]
 for i in range(2):
  var id:String=ids[i];var item:Dictionary=EquipmentCatalog.ITEMS[id];var x:float=60+i*620
  _label(item["name"].to_upper(),Vector2(x,225),30)
  var detail:String="%d puntos\nTrazo máximo: %d px\nNo aumenta la velocidad" % [item["price"],item["reach"]]
  if id=="whip_basic":detail+="\nHabilita el regate"
  if item.has("requires"):detail+="\nRequiere la fusta básica"
  _label(detail,Vector2(x,275),21)
  _buy[id]=_button("",Vector2(x,425),func():
   if not SaveData.buy_equipment(id):_state.text="No se pudo conseguir: comprueba saldo o guardado"
   refresh())
  _equip[id]=_button("EQUIPAR",Vector2(x+240,425),func():
   SaveData.equip_item(id)
   refresh())
 _state=_label("",Vector2(40,510),24)
 _label("Recompensas y precios provisionales para probar el equilibrio. Sin dinero real.\nNivel 1: 10 puntos · Nivel 5: 200 · Nivel 10: 1.000\nSombreros, caballos y ropa todavía no están incluidos. Conservas tu vaquero y caballo.",Vector2(40,580),20)
 resized.connect(_layout);_layout();refresh()
func _label(text:String,pos:Vector2,font:int)->Label:
 var l:=Label.new();l.text=text;l.position=pos;l.add_theme_font_size_override("font_size",font);_canvas.add_child(l);return l
func _button(text:String,pos:Vector2,callback:Callable)->Button:
 var b:=Button.new();b.text=text;b.position=pos;b.size=Vector2(220,52);b.pressed.connect(callback);_canvas.add_child(b);return b
func _layout()->void:
 if _canvas==null:return
 var k:float=minf(size.x/1280,size.y/720)
 _canvas.scale=Vector2.ONE*k;_canvas.position=(size-Vector2(1280,720)*k)/2
func refresh()->void:
 if _balance==null:return
 _balance.text="SALDO: %d PUNTOS" % SaveData.equipment_points
 var state:=SaveData.equipment_state()
 for id in _buy:
  var item:Dictionary=EquipmentCatalog.ITEMS[id]
  _buy[id].text="CONSEGUIDA" if state.owned.has(id) else "CONSEGUIR · %d"%item["price"]
  _buy[id].disabled=not state.can_buy(id,EquipmentCatalog.ITEMS)
  var selected:bool=state.equipped.get("whip","")==id
  _equip[id].text="EQUIPADA" if selected else "EQUIPAR"
  _equip[id].disabled=selected or not state.owned.has(id)
 var selected:String=state.equipped.get("whip","")
 _state.text="EQUIPADO: "+(EquipmentCatalog.ITEMS[selected]["name"] if EquipmentCatalog.ITEMS.has(selected) else "Sin fusta · consigue y equipa una para regatear")
