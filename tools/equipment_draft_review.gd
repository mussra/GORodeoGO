extends SceneTree
var economy:=EquipmentPoints.new()
var status:Label
var balance_label:Label
var buy_basic:Button
var equip_basic:Button
var buy_long:Button
var equip_long:Button
func _initialize()->void:call_deferred("setup")
func label(parent:Node,text:String,pos:Vector2,size:Vector2,font:int)->Label:
 var l:=Label.new();l.text=text;l.position=pos;l.size=size;l.add_theme_font_size_override("font_size",font);parent.add_child(l);return l
func button(parent:Node,text:String,pos:Vector2,callback:Callable)->Button:
 var b:=Button.new();b.text=text;b.position=pos;b.size=Vector2(220,52);b.pressed.connect(callback);parent.add_child(b);return b
func setup()->void:
 var root_ui:=Control.new();root_ui.theme=RanchTheme.create();root.add_child(root_ui)
 var bg:=ColorRect.new();bg.color=Color("10252d");bg.size=Vector2(1280,720);root_ui.add_child(bg)
 label(root_ui,"EQUIPO · PROPUESTA PARA REVISAR",Vector2(40,24),Vector2(1200,45),32)
 label(root_ui,"Puntos por completar fases, también al repetir. Los niveles se abren por victoria, no se compran.",Vector2(40,75),Vector2(1200,40),20)
 balance_label=label(root_ui,"",Vector2(40,125),Vector2(1200,40),26)
 label(root_ui,"FUSTA",Vector2(60,225),Vector2(500,35),30)
 label(root_ui,"1.000 puntos · Habilita el regate\nTrazo máximo: 260 px\nNo aumenta la velocidad",Vector2(60,275),Vector2(500,130),23)
 buy_basic=button(root_ui,"CONSEGUIR · 1.000",Vector2(60,415),func():economy.buy("whip_basic",EquipmentCatalog.ITEMS);refresh())
 equip_basic=button(root_ui,"EQUIPAR",Vector2(300,415),func():economy.equip("whip_basic",EquipmentCatalog.ITEMS);refresh())
 label(root_ui,"FUSTA MEJORADA",Vector2(680,225),Vector2(540,35),30)
 label(root_ui,"2.000 puntos · Requiere la fusta\nTrazo máximo: 420 px\nSustituye la fusta equipada, no se suma",Vector2(680,275),Vector2(540,130),23)
 buy_long=button(root_ui,"CONSEGUIR · 2.000",Vector2(680,415),func():economy.buy("whip_long",EquipmentCatalog.ITEMS);refresh())
 equip_long=button(root_ui,"EQUIPAR",Vector2(920,415),func():economy.equip("whip_long",EquipmentCatalog.ITEMS);refresh())
 status=label(root_ui,"",Vector2(40,500),Vector2(1200,50),24)
 label(root_ui,"Ejemplos por victoria: nivel 1 → 10 · nivel 5 → 200 · nivel 10 → 1.000\nSaldo de muestra: primeras victorias 1-7 = 1.195. Curva y precios en revisión.\nSombreros, caballos y ropa: siguiente propuesta visual. El original siempre estará disponible.",Vector2(40,565),Vector2(1200,130),21)
 for level in range(1,8):economy.reward_completed_level(level,"sample-"+str(level),EquipmentCatalog.REWARDS)
 refresh()
 await create_timer(.5).timeout
 await RenderingServer.frame_post_draw
 root.get_texture().get_image().save_png("/downloads/gorodeo/equipment-draft-before.png")
 buy_basic.pressed.emit();equip_basic.pressed.emit()
 await create_timer(.3).timeout
 await RenderingServer.frame_post_draw
 root.get_texture().get_image().save_png("/downloads/gorodeo/equipment-draft-after.png")
 quit()
func refresh()->void:
 balance_label.text="SALDO DE EJEMPLO: %s PUNTOS"%economy.balance
 buy_basic.disabled=not economy.can_buy("whip_basic",EquipmentCatalog.ITEMS)
 buy_long.disabled=not economy.can_buy("whip_long",EquipmentCatalog.ITEMS)
 equip_basic.disabled=not economy.owned.has("whip_basic")
 equip_long.disabled=not economy.owned.has("whip_long")
 var selected:String=economy.equipped.get("whip","")
 status.text="EQUIPADO: "+(EquipmentCatalog.ITEMS[selected]["name"] if not selected.is_empty() else "Sin fusta · regate no disponible")
