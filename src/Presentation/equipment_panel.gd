class_name EquipmentPanel
extends Control
signal closed
var _canvas:Control
var _balance:Label
var _state:Label
var _buy:Dictionary={}
var _equip:Dictionary={}
var _horses:HorsePanel
var _hats:HatPanel
func _ready()->void:
 MenuInputGuard.install(self)
 set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
 z_index=50
 var bg:=ColorRect.new();bg.color=Color("10252d");bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT);add_child(bg)
 _canvas=Control.new();_canvas.size=Vector2(1280,720);add_child(_canvas)
 _label(tr("UI_046"),Vector2(40,24),32)
 _label(tr("UI_047"),Vector2(40,75),21)
 _balance=_label("",Vector2(40,125),26)
 var back:=_button(tr("UI_009"),Vector2(1020,24),func():hide();closed.emit())
 back.size=Vector2(220,45)
 var ids=["whip_basic","whip_long"]
 for i in range(2):
  var id:String=ids[i];var item:Dictionary=EquipmentCatalog.ITEMS[id];var x:float=60+i*620
  _label(tr(item["name"]).to_upper(),Vector2(x,225),30)
  var detail:String=tr("UI_048") % [item["price"],item["reach"]]
  if id=="whip_basic":detail+=tr("UI_049")
  if item.has("requires"):detail+=tr("UI_050")
  _label(detail,Vector2(x,275),21)
  _buy[id]=_button("",Vector2(x,425),func():
   if not SaveData.buy_equipment(id):_state.text=tr("UI_051")
   refresh())
  _equip[id]=_button(tr("UI_059"),Vector2(x+240,425),func():
   SaveData.equip_item(id)
   refresh())
 _state=_label("",Vector2(40,510),24)
 var hats_button:=_button(tr("UI_052"),Vector2(840,125),func():
  if _hats==null:
   _hats=HatPanel.new();add_child(_hats)
  else:_hats.show();_hats.refresh())
 hats_button.size=Vector2(360,52)
 var horse_button:=_button(tr("UI_053"),Vector2(430,125),func():
  if _horses==null:
   _horses=HorsePanel.new();add_child(_horses)
  else:_horses.open_menu())
 horse_button.size=Vector2(360,52)
 var note:=_label(tr("UI_054"),Vector2(40,555),18)
 note.size=Vector2(735,135);note.autowrap_mode=TextServer.AUTOWRAP_WORD_SMART
 var finishes:=_button("Acabados especiales",Vector2(800,625),func():add_child(FinishShop168.new()))
 finishes.size=Vector2(430,52)
 var adorns:=_button("Adornos de oro y plata",Vector2(800,561),func():add_child(AdornShop169.new()))
 adorns.size=Vector2(430,52)
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
 _balance.text=tr("UI_055") % SaveData.equipment_points
 var state:EquipmentPoints=SaveData.equipment_state()
 for id in _buy:
  var item:Dictionary=EquipmentCatalog.ITEMS[id]
  _buy[id].text=tr("UI_062") if state.owned.has(id) else tr("UI_056")%item["price"]
  MenuInputGuard.set_button_disabled(_buy[id],not state.can_buy(id,EquipmentCatalog.ITEMS))
  var selected:bool=state.equipped.get("whip","")==id
  _equip[id].text=tr("UI_061") if selected else tr("UI_059")
  MenuInputGuard.set_button_disabled(_equip[id],selected or not state.owned.has(id))
 var selected:String=state.equipped.get("whip","")
 _state.text=tr("UI_057")+(tr(EquipmentCatalog.ITEMS[selected]["name"]) if EquipmentCatalog.ITEMS.has(selected) else tr("UI_058"))
