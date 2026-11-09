extends Control
var canvas:Control
var note:Label
var level_pick:OptionButton
var picks:Array[OptionButton]=[]
func _ready()->void:
 MenuInputGuard.install(self)
 set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT);z_index=100
 var bg:=ColorRect.new();bg.color=Color("10252d");bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT);add_child(bg)
 canvas=Control.new();canvas.size=Vector2(1280,720);add_child(canvas);resized.connect(layout);layout()
 label(tr("DEBUG_TITLE"),Vector2(35,20),32)
 label(tr("DEBUG_SEPARATE"),Vector2(35,70),23)
 label(tr("DEBUG_KEEP"),Vector2(35,110),22)
 button(tr("DEBUG_HORSES"),Vector2(35,185),func():var p=load("res://src/Presentation/horse_panel.gd").new();add_child(p),550)
 button(tr("DEBUG_HATS"),Vector2(620,185),func():var p=load("res://src/Presentation/hat_panel.gd").new();add_child(p),600)
 label(tr("DEBUG_APPEARANCE"),Vector2(35,255),23)
 var names:Array=[HorseCollection.COATS,HorseCollection.PATTERNS,HorseCollection.MANES]
 for i in range(3):
  var pick:=OptionButton.new();pick.position=Vector2(35+i*395,300);pick.size=Vector2(365,48);canvas.add_child(pick)
  for value in names[i]:pick.add_item(tr(value))
  picks.append(pick)
 var eye_pick:=OptionButton.new();eye_pick.position=Vector2(35,360);eye_pick.size=Vector2(270,48);canvas.add_child(eye_pick)
 for value in HorseCollection.EYES:eye_pick.add_item(tr("UI_140")+tr(value))
 eye_pick.selected=10
 var finish_pick:=OptionButton.new();finish_pick.position=Vector2(320,360);finish_pick.size=Vector2(270,48);canvas.add_child(finish_pick);finish_pick.add_item(tr("UI_141"));finish_pick.add_item(tr("UI_142"))
 button(tr("DEBUG_USE_LOOK"),Vector2(35,420),func():SaveData.preview_trial_traits(picks[0].selected,picks[1].selected,picks[2].selected,eye_pick.selected,"galaxy" if finish_pick.selected==1 else "normal");refresh(),550)
 var whip:=OptionButton.new();whip.position=Vector2(620,365);whip.size=Vector2(600,48);canvas.add_child(whip)
 for id in ["whip_basic","whip_long"]:whip.add_item(tr(EquipmentCatalog.ITEMS[id].name)+tr("UI_144")%EquipmentCatalog.ITEMS[id].reach)
 whip.item_selected.connect(func(i):SaveData.equip_item("whip_basic" if i==0 else "whip_long");refresh())
 note=label("",Vector2(35,475),22);refresh()
 label(tr("UI_145"),Vector2(35,530),21)
 level_pick=OptionButton.new();level_pick.position=Vector2(35,570);level_pick.size=Vector2(270,48);canvas.add_child(level_pick)
 for i in range(1,LevelCatalog.MAX_LEVEL+1):level_pick.add_item(tr("UI_146")%i)
 button(tr("DEBUG_PLAY"),Vector2(340,570),func():GameState.selected_level=level_pick.selected+1;get_tree().change_scene_to_file("res://src/Presentation/level_0.tscn"),400)
 button(tr("DEBUG_RETURN"),Vector2(35,635),func():get_tree().reload_current_scene(),1180)
func layout()->void:
 var k:float=minf(size.x/1280,size.y/720);canvas.scale=Vector2.ONE*k;canvas.position=(size-Vector2(1280,720)*k)/2
func label(text:String,pos:Vector2,font:int)->Label:
 var l:=Label.new();l.text=text;l.position=pos;l.add_theme_font_size_override("font_size",font);canvas.add_child(l);return l
func button(text:String,pos:Vector2,cb:Callable,w:float)->void:
 var b:=Button.new();b.text=text;b.position=pos;b.size=Vector2(w,48);b.pressed.connect(cb);canvas.add_child(b)
func refresh()->void:
 if note!=null:note.text=tr("UI_149")+SaveData.horse_collection.find(SaveData.horse_collection.selected).name+tr("UI_150")+tr(EquipmentCatalog.ITEMS.get(SaveData.equipment_equipped.get("whip",""),{}).get("name","UI_058"))

func _process(_delta:float)->void:refresh()
