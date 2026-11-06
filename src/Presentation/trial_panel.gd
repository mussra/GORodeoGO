extends Control
var canvas:Control
var note:Label
var level_pick:OptionButton
var picks:Array[OptionButton]=[]
func _ready()->void:
 set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT);z_index=100
 var bg:=ColorRect.new();bg.color=Color("10252d");bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT);add_child(bg)
 canvas=Control.new();canvas.size=Vector2(1280,720);add_child(canvas);resized.connect(layout);layout()
 label("ENSAYO AISLADO · NADA SE GUARDA",Vector2(35,20),32)
 label("Al volver al menú o reiniciar recuperas tu estado real. Sin compras, premios ni logros.",Vector2(35,70),23)
 label("Adultos: los tuyos y 2 padres prestados. Potrillos reales siguen sin trabajar.\nAspectos temporales: rasgos existentes, no nuevas adquisiciones ni 600 diseños auditados.",Vector2(35,110),22)
 button("CABALLOS / COPIA TEMPORAL",Vector2(35,185),func():var p=load("res://src/Presentation/horse_panel.gd").new();add_child(p),550)
 button("SOMBREROS / COPIA TEMPORAL",Vector2(620,185),func():var p=load("res://src/Presentation/hat_panel.gd").new();add_child(p),600)
 label("ASPECTO PRESTADO · atributos BASE (260 / 900 / 0,60 / 1,00)",Vector2(35,255),23)
 var names:Array=[HorseCollection.COATS,HorseCollection.PATTERNS,HorseCollection.MANES]
 for i in range(3):
  var pick:=OptionButton.new();pick.position=Vector2(35+i*395,300);pick.size=Vector2(365,48);canvas.add_child(pick)
  for value in names[i]:pick.add_item(value)
  picks.append(pick)
 button("USAR ASPECTO TEMPORAL",Vector2(35,365),func():SaveData.preview_trial_traits(picks[0].selected,picks[1].selected,picks[2].selected);refresh(),550)
 var whip:=OptionButton.new();whip.position=Vector2(620,365);whip.size=Vector2(600,48);canvas.add_child(whip)
 for id in ["whip_basic","whip_long"]:whip.add_item(EquipmentCatalog.ITEMS[id].name+" PRESTADA · %d px"%EquipmentCatalog.ITEMS[id].reach)
 whip.item_selected.connect(func(i):SaveData.equip_item("whip_basic" if i==0 else "whip_long");refresh())
 note=label("",Vector2(35,440),22);refresh()
 label("Todas las mejoras existentes activas. Galaxy/materiales/rareza final no implementados.",Vector2(35,505),21)
 level_pick=OptionButton.new();level_pick.position=Vector2(35,555);level_pick.size=Vector2(270,48);canvas.add_child(level_pick)
 for i in range(1,LevelCatalog.MAX_LEVEL+1):level_pick.add_item("Nivel %02d · ENSAYO"%i)
 button("JUGAR ENSAYO",Vector2(340,555),func():GameState.selected_level=level_pick.selected+1;get_tree().change_scene_to_file("res://src/Presentation/level_0.tscn"),400)
 button("SALIR Y RESTAURAR ESTADO REAL",Vector2(35,635),func():SaveData.end_trial_session();get_tree().reload_current_scene(),1180)
func layout()->void:
 var k:float=minf(size.x/1280,size.y/720);canvas.scale=Vector2.ONE*k;canvas.position=(size-Vector2(1280,720)*k)/2
func label(text:String,pos:Vector2,font:int)->Label:
 var l:=Label.new();l.text=text;l.position=pos;l.add_theme_font_size_override("font_size",font);canvas.add_child(l);return l
func button(text:String,pos:Vector2,cb:Callable,w:float)->void:
 var b:=Button.new();b.text=text;b.position=pos;b.size=Vector2(w,48);b.pressed.connect(cb);canvas.add_child(b)
func refresh()->void:
 if note!=null:note.text="Seleccionado: "+SaveData.horse_collection.find(SaveData.horse_collection.selected).name+"\nEquipo temporal: "+EquipmentCatalog.ITEMS[SaveData.equipment_equipped.whip].name

func _process(_delta:float)->void:refresh()
func _notification(what:int)->void:
 if what==NOTIFICATION_WM_GO_BACK_REQUEST:
  SaveData.end_trial_session();get_tree().reload_current_scene()
