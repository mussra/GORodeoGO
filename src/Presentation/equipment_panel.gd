class_name EquipmentPanel
extends Control
signal closed
var _canvas:Control
var _balance:Label
var _state:Label
var _buy:Dictionary={}
var _equip:Dictionary={}
var _rows302:Dictionary={}
var _badges302:Dictionary={}
var _horses:HorsePanel
var _confirm:ConfirmationDialog
var _pending_purchase:String=""
var _hats:HatPanel
var _confirm_bars306:VBoxContainer
func _ready()->void:
 set_meta("background300","content")
 MenuInputGuard.install(self);set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT);z_index=50
 var bg:=ColorRect.new();bg.color=Color("10252d");bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT);add_child(bg)
 _canvas=Control.new();_canvas.size=Vector2(1280,720);add_child(_canvas)
 _label("EQUIPO",Vector2(40,22),30);_balance=_label("",Vector2(40,72),24)
 var note:=_label("Marca blanca: actual · verde: mejora · puntos, sin dinero real",Vector2(640,78),16);note.modulate=Color(1,1,1,.65)
 _card("Volver","back",Vector2(1130,15),Vector2(110,90),func():hide();closed.emit())
 _card("Caballeriza · cría","horse",Vector2(40,125),Vector2(270,145),func():
  if _horses==null:_horses=HorsePanel.new();add_child(_horses)
  else:_horses.open_menu())
 _card("Sombreros","hat",Vector2(350,125),Vector2(270,145),func():
  if _hats==null:_hats=HatPanel.new();add_child(_hats)
  else:_hats.show();_hats.refresh())
 _card("Adornos","adorn",Vector2(660,125),Vector2(270,145),func():add_child(AdornShop169.new()))
 _card("Acabados","finish",Vector2(970,125),Vector2(270,145),func():add_child(FinishShop168.new()))
 var scroll:=ScrollContainer.new();scroll.position=Vector2(40,292);scroll.size=Vector2(1200,352);scroll.horizontal_scroll_mode=ScrollContainer.SCROLL_MODE_DISABLED;_canvas.add_child(scroll)
 scroll.name="EquipmentList257";scroll.vertical_scroll_mode=ScrollContainer.SCROLL_MODE_SHOW_ALWAYS;scroll.get_v_scroll_bar().custom_minimum_size.x=24
 var list:=VBoxContainer.new();list.size_flags_horizontal=Control.SIZE_EXPAND_FILL;list.add_theme_constant_override("separation",8);scroll.add_child(list)
 for id in EquipmentCatalog.ORDER:
  if not EquipmentCatalog.ITEMS.has(id):continue
  list.add_child(_item_row(id))
 _confirm=ConfirmationDialog.new();_confirm.title="Juanito · confirmar equipo";_confirm.ok_button_text="Fabricar";_confirm.cancel_button_text="Cancelar";add_child(_confirm);_confirm.confirmed.connect(func():
  var ok:bool=SaveData.buy_equipment(_pending_purchase);refresh()
  if not ok:_state.text="No se pudo comprar ni guardar; no se han gastado puntos")
 _state=_label("",Vector2(40,652),21);_state.size=Vector2(1200,60);_state.autowrap_mode=TextServer.AUTOWRAP_WORD_SMART
 _label("Herraduras: pendiente de terreno difícil · Alforjas: pendiente de inventario limitado",Vector2(40,693),15)
 resized.connect(_layout);_layout();refresh()
func _item_row(id:String)->Panel:
 var item:Dictionary=EquipmentCatalog.ITEMS[id]
 var panel:=Panel.new();panel.custom_minimum_size=Vector2(1170,124);DetailCard179.style_panel(panel);ButtonSkin272.panel(panel)
 var icon:=EquipmentIcon229.new();icon.kind=("long" if str(item.slot)=="lasso" else "whip" if str(item.get("icon","whip"))=="long" else str(item.get("icon","whip")));icon.position=Vector2(14,14);icon.size=Vector2(96,96);panel.add_child(icon)
 _row_label(panel,str(item.name),Vector2(126,15),20)
 _row_label(panel,_effect_text(id),Vector2(126,42),17)
 var specs:Array=EquipmentAttributes306.specs(id)
 var height:float=120.+specs.size()*39.
 panel.custom_minimum_size.y=height
 var bars:=EquipmentAttributes306.create(panel,id,650.);bars.position=Vector2(126,76);bars.size.x=650.
 var price_text:String=("Mejora: +%d puntos"%int(item.price)) if item.has("requires") else ("%d puntos"%int(item.price))
 _row_label(panel,price_text,Vector2(126,height-34),17)
 _rows302[id]=panel
 var badge:=Label.new();badge.position=Vector2(530,height-34);badge.size=Vector2(255,25);badge.horizontal_alignment=HORIZONTAL_ALIGNMENT_RIGHT;badge.add_theme_font_size_override("font_size",16);badge.mouse_filter=Control.MOUSE_FILTER_IGNORE;panel.add_child(badge);_badges302[id]=badge
 _buy[id]=_row_card(panel,"Conseguir","buy",Vector2(800,20),Vector2(170,84),func():
  _confirm_purchase(id))
 _equip[id]=_row_card(panel,"Equipar","equip",Vector2(985,20),Vector2(170,84),func():
  if item.get("cosmetic",false) and SaveData.equipment_equipped.get(item.slot,"")==id:SaveData.unequip_cosmetic243(item.slot)
  else:SaveData.equip_item(id)
  refresh())
 return panel
func _row_label(panel:Panel,text:String,pos:Vector2,font:int)->Label:
 var label:=Label.new();label.text=text;label.position=pos;label.size=Vector2(660,30);label.clip_text=true;label.tooltip_text=text;label.add_theme_font_size_override("font_size",font);panel.add_child(label);return label
func _row_card(panel:Panel,caption:String,kind:String,pos:Vector2,extent:Vector2,callback:Callable)->Button:
 var button:=Button.new();button.position=pos;button.size=extent;button.tooltip_text=caption;button.set_meta("entry229",kind);button.pressed.connect(callback);panel.add_child(button);QuestButtonStyle.apply(button)
 for state in ["normal","hover","pressed","disabled","focus"]:
  button.add_theme_stylebox_override(state,RanchTheme.box(Color("1b3d49") if state in ["normal","disabled"] else Color("285a68"),Color("478b9a"),12))
 var icon:=EquipmentIcon229.new();icon.kind=kind;icon.size=Vector2.ONE*minf(60.,extent.y-32.);icon.position=Vector2(6,(extent.y-icon.size.y)*.5);button.add_child(icon)
 var label:=Label.new();label.name="Caption229";label.text=caption;label.position=Vector2(4,extent.y-37);label.size=Vector2(extent.x-8,25);label.horizontal_alignment=HORIZONTAL_ALIGNMENT_CENTER;label.add_theme_font_size_override("font_size",17);label.mouse_filter=Control.MOUSE_FILTER_IGNORE;button.add_child(label)
 ButtonSkin272.apply(button,kind=="buy")
 return button
func _effect_text(id:String)->String:
 var item:Dictionary=EquipmentCatalog.ITEMS[id]
 if item.get("blocked",false):return str(item.get("blocked_reason","Pendiente"))
 if str(item.slot)=="scare_whip":return "Solo ruido, sin daño. Aleja a los animales afectados."
 if item.has("small_lasso_range"):return "Facilita capturar cerdos y cabras; toros sin cambios"
 if item.has("reach"):return "Regate: señal sin golpes ni daño; no da más velocidad"
 if item.get("cosmetic",false):return "Solo apariencia, sin ventaja de juego"
 return "Propiedades de equipo · barras de menor a mejor"
func _upgrade_diff_text(id:String)->String:
 return "Marca blanca: actual · dorado: objeto · verde: mejora" if not EquipmentAttributes306.specs(id).is_empty() else ""

func _label(text:String,pos:Vector2,font:int)->Label:
 var label:=Label.new();label.text=text;label.position=pos;label.add_theme_font_size_override("font_size",font);_canvas.add_child(label);return label
func _card(caption:String,kind:String,pos:Vector2,extent:Vector2,callback:Callable)->Button:
 var button:=Button.new();button.position=pos;button.size=extent;button.tooltip_text=caption;button.set_meta("entry229",kind);button.pressed.connect(callback);_canvas.add_child(button);QuestButtonStyle.apply(button)
 for state in ["normal","hover","pressed","disabled","focus"]:
  button.add_theme_stylebox_override(state,RanchTheme.box(Color("1b3d49") if state in ["normal","disabled"] else Color("285a68"),Color("478b9a"),12))
 var icon:=EquipmentIcon229.new();icon.kind=kind;icon.size=Vector2.ONE*minf(90.,extent.y-34.);icon.position=Vector2((extent.x-icon.size.x)*.5,5);button.add_child(icon)
 var label:=Label.new();label.name="Caption229";label.text=caption;label.position=Vector2(4,extent.y-39);label.size=Vector2(extent.x-8,27);label.horizontal_alignment=HORIZONTAL_ALIGNMENT_CENTER;label.add_theme_font_size_override("font_size",18);label.mouse_filter=Control.MOUSE_FILTER_IGNORE;button.add_child(label)
 ButtonSkin272.apply(button,kind=="buy")
 return button
func _layout()->void:
 if _canvas==null:return
 var k:float=minf(size.x/1280,size.y/720);_canvas.scale=Vector2.ONE*k;_canvas.position=(size-Vector2(1280,720)*k)/2
func refresh()->void:
 if _balance==null:return
 _balance.text=tr("UI_055")%SaveData.equipment_points
 var state:EquipmentPoints=SaveData.equipment_state()
 for id in _buy:
  var item:Dictionary=EquipmentCatalog.ITEMS[id]
  var slot:String=str(item.get("slot",""))
  var owned:bool=state.owned.has(id)
  _buy[id].get_node("Caption229").text="Pendiente" if item.get("blocked",false) else ("Conseguido" if owned else ("Mejorar" if item.has("requires") else "Conseguir"))
  var can_buy302:bool=state.can_buy(id,EquipmentCatalog.ITEMS)
  MenuInputGuard.set_button_disabled(_buy[id],not can_buy302)
  _buy[id].modulate=Color.WHITE if can_buy302 else Color(1,1,1,.45)
  var selected:bool=state.equipped.get(slot,"")==id
  _equip[id].get_node("Caption229").text=("Quitar" if item.get("cosmetic",false) else tr("UI_061")) if selected else tr("UI_059")
  var can_equip302:bool=owned and (not selected or item.get("cosmetic",false))
  MenuInputGuard.set_button_disabled(_equip[id],not can_equip302)
  # Business state is not the temporary input lock while the dialog is closing.
  _equip[id].modulate=Color.WHITE if owned else Color(1,1,1,.45)
  _equip[id].add_theme_stylebox_override("disabled",ButtonSkin272.style("pressed" if selected else "disabled"))
  _equip[id].get_node("Caption229").text=("✓ EQUIPADO" if selected else "EQUIPAR") if not item.get("cosmetic",false) else ("QUITAR" if selected else "EQUIPAR")
  _badges302[id].text="✓ EQUIPADO" if selected else ("SIN EQUIPAR" if owned else "NO CONSEGUIDO")
  _badges302[id].add_theme_color_override("font_color",Color("ffe09a") if selected else Color("fff1d2") if owned else Color("9caaa9"))
  var face302:=ButtonSkin272.style("normal").duplicate() as StyleBoxTexture
  face302.modulate_color=Color("ffe3a0") if selected else Color.WHITE
  _rows302[id].add_theme_stylebox_override("panel",face302)
  var old_bars:Node=_rows302[id].get_node_or_null("Attributes306")
  if old_bars!=null:_rows302[id].remove_child(old_bars);old_bars.free()
  var bars:=EquipmentAttributes306.create(_rows302[id],id,650.);bars.position=Vector2(126,76);bars.size.x=650.
 var selected_whip:String=state.equipped.get("whip","")
 _state.text="FUSTA DE REGATE: "+(tr(EquipmentCatalog.ITEMS[selected_whip]["name"]) if EquipmentCatalog.ITEMS.has(selected_whip) else tr("UI_058"))

func _confirm_purchase(id:String)->void:
 if not SaveData.equipment_state().can_buy(id,EquipmentCatalog.ITEMS):return
 _pending_purchase=id
 var item:Dictionary=EquipmentCatalog.ITEMS[id]
 var basic:String=str(item.get("requires",""))
 var total:int=int(item.price)+(int(EquipmentCatalog.ITEMS[basic].price) if not basic.is_empty() else 0)
 _confirm.dialog_text=""
 if is_instance_valid(_confirm_bars306):_confirm_bars306.free()
 _confirm_bars306=VBoxContainer.new();_confirm_bars306.custom_minimum_size=Vector2(650,0);_confirm_bars306.add_theme_constant_override("separation",10);_confirm.add_child(_confirm_bars306)
 var heading:=Label.new();heading.custom_minimum_size.x=650.;heading.text=str(item.name)+"\n"+_effect_text(id);heading.autowrap_mode=TextServer.AUTOWRAP_WORD_SMART;_confirm_bars306.add_child(heading)
 EquipmentAttributes306.create(_confirm_bars306,id,650.)
 var legend:=Label.new();legend.text=_upgrade_diff_text(id);_confirm_bars306.add_child(legend)
 var price:=Label.new();price.custom_minimum_size.x=650.;price.text="Coste ahora: %d puntos · total básico y mejora: %d puntos\nSaldo después: %d puntos\nCompra única. Equipar después es gratis. Sin dinero real."%[int(item.price),total,SaveData.equipment_points-int(item.price)];price.autowrap_mode=TextServer.AUTOWRAP_WORD_SMART;_confirm_bars306.add_child(price)
 _confirm.popup_centered(Vector2i(730,260+EquipmentAttributes306.specs(id).size()*42))
