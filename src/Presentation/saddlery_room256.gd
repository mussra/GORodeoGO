class_name SaddleryRoom256
extends BuildingRoom262
var equipment:EquipmentPanel
func _ready():
 room_id264="home:saddler";npc_name="Juanito";npc_path="res://art/breeding256/juanito.png"
 layer=124;process_mode=Node.PROCESS_MODE_ALWAYS
 var root:=Control.new();root.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT);add_child(root);MenuInputGuard.install(root)
 var bg:=ColorRect.new();bg.color=Color("102a30");bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT);root.add_child(bg)
 canvas=Control.new();canvas.size=Vector2(1280,720);root.add_child(canvas);get_viewport().size_changed.connect(_fit);_fit()
 image("res://art/breeding256/saddlery-interior.png",Vector2(117,32),Vector2(1046,590))
 image("res://art/breeding256/juanito.png",Vector2(880,210),Vector2(190,295))
 var title:=Label.new();title.text="JUANITO · GUARNICIONERO";title.position=Vector2(36,13);title.add_theme_font_size_override("font_size",26);canvas.add_child(title)
 var note:=Label.new();note.text="Fustas, sillas y complementos · puntos del juego";note.position=Vector2(235,615);note.add_theme_font_size_override("font_size",21);canvas.add_child(note)
 button("Hablar y ver equipo",Vector2(620,656),Vector2(370,54),open_equipment)
 button("Salir al rancho",Vector2(210,656),Vector2(370,54),finish)
 message=_label("Si te interesa algo, habla con Juanito.",Vector2(40,588),Vector2(1200,36),20)
 reserved_ui264=[Rect2(0,588,1280,132)]
 found_names264={"workbench":"un retal de cuero de la mesa"}
 add_search_site264("workbench",Rect2(330,264,100,60),"leather_offcut","owner")
 add_search_site264("rug",Rect2(620,400,110,80))
func image(path_:String,at:Vector2,extent:Vector2):
 var v:=TextureRect.new();v.texture=load(path_);v.position=at;v.size=extent;v.expand_mode=TextureRect.EXPAND_IGNORE_SIZE;v.stretch_mode=TextureRect.STRETCH_KEEP_ASPECT_CENTERED;v.mouse_filter=Control.MOUSE_FILTER_IGNORE;canvas.add_child(v);v.size=extent
func button(text_:String,at:Vector2,extent:Vector2,action:Callable):
 var b:=Button.new();b.text=text_;b.position=at;b.size=extent;QuestButtonStyle.apply(b);canvas.add_child(b);b.pressed.connect(action)
func open_equipment():
 if is_instance_valid(equipment):equipment.show();return
 equipment=EquipmentPanel.new();canvas.add_child(equipment)
 equipment.closed.connect(func():equipment.hide())
func _fit():
 var extent:=get_viewport().get_visible_rect().size;var k:float=minf(extent.x/1280.,extent.y/720.)
 canvas.scale=Vector2.ONE*k;canvas.position=(extent-Vector2(1280,720)*k)*.5
func finish():super.finish()
func _unhandled_input(event:InputEvent):
 if is_instance_valid(exit_dialog264):super._unhandled_input(event);return
 if event.is_action_pressed("ui_cancel"):
  if is_instance_valid(equipment) and equipment.visible:equipment.hide()
  else:finish()
  get_viewport().set_input_as_handled()
