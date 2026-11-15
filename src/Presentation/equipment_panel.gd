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
 MenuInputGuard.install(self);set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT);z_index=50
 var bg:=ColorRect.new();bg.color=Color("10252d");bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT);add_child(bg)
 _canvas=Control.new();_canvas.size=Vector2(1280,720);add_child(_canvas)
 _label("EQUIPO",Vector2(40,22),30);_balance=_label("",Vector2(40,72),24)
 _card("Volver","back",Vector2(1130,15),Vector2(110,90),func():hide();closed.emit())
 _card("Caballeriza · cría","horse",Vector2(40,125),Vector2(270,145),func():
  if _horses==null:_horses=HorsePanel.new();add_child(_horses)
  else:_horses.open_menu())
 _card("Sombreros","hat",Vector2(350,125),Vector2(270,145),func():
  if _hats==null:_hats=HatPanel.new();add_child(_hats)
  else:_hats.show();_hats.refresh())
 _card("Adornos","adorn",Vector2(660,125),Vector2(270,145),func():add_child(AdornShop169.new()))
 _card("Acabados","finish",Vector2(970,125),Vector2(270,145),func():add_child(FinishShop168.new()))
 for i in 2:
  var id:String=["whip_basic","whip_long"][i];var item:Dictionary=EquipmentCatalog.ITEMS[id];var x:float=40+i*620
  var panel:=Panel.new();panel.position=Vector2(x,300);panel.size=Vector2(580,250);DetailCard179.style_panel(panel);_canvas.add_child(panel)
  var icon:=EquipmentIcon229.new();icon.kind="whip" if i==0 else "long";icon.position=Vector2(x+20,320);icon.size=Vector2(110,110);_canvas.add_child(icon)
  var title:=_label("Fusta" if i==0 else "Fusta mejorada",Vector2(x+10,442),18);title.size=Vector2(135,60);title.horizontal_alignment=HORIZONTAL_ALIGNMENT_CENTER;title.autowrap_mode=TextServer.AUTOWRAP_WORD_SMART
  _label("%s puntos"%item.price,Vector2(x+155,318),24)
  _label("Trazo: %s px"%int(item.reach),Vector2(x+155,356),21)
  _label("Habilita el regate · sin más velocidad" if i==0 else "Requiere la fusta básica · sin más velocidad",Vector2(x+155,393),17)
  _buy[id]=_card("Conseguir","buy",Vector2(x+155,450),Vector2(185,82),func():
   if not SaveData.buy_equipment(id):_state.text=tr("UI_051")
   refresh())
  _equip[id]=_card("Equipar","equip",Vector2(x+365,450),Vector2(185,82),func():SaveData.equip_item(id);refresh())
 _state=_label("",Vector2(40,582),21);_state.size=Vector2(1200,60);_state.autowrap_mode=TextServer.AUTOWRAP_WORD_SMART
 _label("Precios provisionales · puntos del juego, sin dinero real",Vector2(40,663),17)
 resized.connect(_layout);_layout();refresh()
func _label(text:String,pos:Vector2,font:int)->Label:
 var label:=Label.new();label.text=text;label.position=pos;label.add_theme_font_size_override("font_size",font);_canvas.add_child(label);return label
func _card(caption:String,kind:String,pos:Vector2,extent:Vector2,callback:Callable)->Button:
 var button:=Button.new();button.position=pos;button.size=extent;button.tooltip_text=caption;button.set_meta("entry229",kind);button.pressed.connect(callback);_canvas.add_child(button);QuestButtonStyle.apply(button)
 for state in ["normal","hover","pressed","disabled","focus"]:
  button.add_theme_stylebox_override(state,RanchTheme.box(Color("1b3d49") if state in ["normal","disabled"] else Color("285a68"),Color("478b9a"),12))
 var icon:=EquipmentIcon229.new();icon.kind=kind;icon.size=Vector2.ONE*minf(90.,extent.y-34.);icon.position=Vector2((extent.x-icon.size.x)*.5,5);button.add_child(icon)
 var label:=Label.new();label.name="Caption229";label.text=caption;label.position=Vector2(4,extent.y-30);label.size=Vector2(extent.x-8,27);label.horizontal_alignment=HORIZONTAL_ALIGNMENT_CENTER;label.add_theme_font_size_override("font_size",18);label.mouse_filter=Control.MOUSE_FILTER_IGNORE;button.add_child(label)
 return button
func _layout()->void:
 if _canvas==null:return
 var k:float=minf(size.x/1280,size.y/720);_canvas.scale=Vector2.ONE*k;_canvas.position=(size-Vector2(1280,720)*k)/2
func refresh()->void:
 if _balance==null:return
 _balance.text=tr("UI_055")%SaveData.equipment_points
 var state:EquipmentPoints=SaveData.equipment_state()
 for id in _buy:
  _buy[id].get_node("Caption229").text="Conseguido" if state.owned.has(id) else "Conseguir"
  MenuInputGuard.set_button_disabled(_buy[id],not state.can_buy(id,EquipmentCatalog.ITEMS))
  _buy[id].modulate=Color(1,1,1,.45) if _buy[id].disabled else Color.WHITE
  var selected:bool=state.equipped.get("whip","")==id
  _equip[id].get_node("Caption229").text=tr("UI_061") if selected else tr("UI_059")
  MenuInputGuard.set_button_disabled(_equip[id],selected or not state.owned.has(id))
  _equip[id].modulate=Color(1,1,1,.45) if _equip[id].disabled else Color.WHITE
 var selected:String=state.equipped.get("whip","")
 _state.text=tr("UI_057")+(tr(EquipmentCatalog.ITEMS[selected]["name"]) if EquipmentCatalog.ITEMS.has(selected) else tr("UI_058"))
