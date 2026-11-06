extends SceneTree
func _initialize()->void:call_deferred("run")
func tap(c:Control)->void:
 var pos:Vector2=c.get_global_rect().get_center()
 for down in [true,false]:
  var e:=InputEventScreenTouch.new();e.index=0;e.position=pos;e.pressed=down
  Input.parse_input_event(e);await process_frame;await process_frame
func find_button(n:Node,text:String)->Button:
 if n is Button and n.text==text:return n
 for child in n.get_children():
  var b:=find_button(child,text)
  if b!=null:return b
 return null
func run()->void:
 root.get_node("GameState").brand_intro_played=false
 change_scene_to_file("res://src/Presentation/main_menu.tscn");await create_timer(4.3).timeout
 var menu:Node=current_scene
 print("REAL_INPUT_START menu=",menu.scene_file_path," emulate_mouse=",Input.emulate_mouse_from_touch)
 await tap(menu._equipment_button);assert(menu._equipment_panel.visible);print("PASS native EQUIPO")
 await tap(find_button(menu._equipment_panel,"VOLVER"));assert(not menu._equipment_panel.visible);print("PASS native VOLVER")
 await tap(menu._missions);assert(menu._drawer.visible);print("PASS native NIVELES")
 await tap(find_button(menu._drawer,"VOLVER"));assert(not menu._drawer.visible)
 await tap(menu._play);await create_timer(.5).timeout
 assert(current_scene.scene_file_path=="res://src/Presentation/level_0.tscn");print("PASS native JUGAR and scene transition")
 var level:Node=current_scene
 await tap(level.hud._pause_button);assert(paused);print("PASS native PAUSA")
 await tap(find_button(level.hud._pause_panel,"Continuar"));assert(not paused);print("PASS native CONTINUAR")
 level._on_quit_requested();await create_timer(.7).timeout
 menu=current_scene;assert(menu.scene_file_path=="res://src/Presentation/main_menu.tscn")
 await create_timer(1.0).timeout
 print("ABOUT_TO_TEST_SALIR_BY_NATIVE_TOUCH")
 await tap(menu.quit_button)
 await create_timer(.2).timeout
 print("FAIL SALIR did not exit");quit(1)
