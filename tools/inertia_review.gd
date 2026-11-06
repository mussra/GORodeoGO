extends SceneTree
func _initialize()->void:call_deferred("run")
func run()->void:
 var gs:Node=root.get_node("GameState");var save:Node=root.get_node("SaveData");save.begin_trial_session();gs.selected_level=5
 var level:Node=load("res://src/Presentation/level_0.tscn").instantiate();root.add_child(level)
 await physics_frame
 for b in level._active_bulls:b.set_physics_process(false);b.global_position=Vector2(1500,1500)
 var layer:=CanvasLayer.new();root.add_child(layer);var note:=Label.new();note.position=Vector2(30,110);note.add_theme_font_size_override("font_size",24);layer.add_child(note)
 var p:Node=level.player;p.global_position=Vector2(-240,-150)
 note.text="FIN DE REGATE · sin controles pierde velocidad hasta parar\nPrueba de motor, no ejecución Android"
 p.request_dodge_path(PackedVector2Array([Vector2.ZERO,Vector2(150,0)]))
 for i in range(110):await physics_frame
 assert(p.velocity.length()<1)
 note.text="GIRO OPUESTO · conserva tangente y cambia según manejabilidad"
 p._dodge_cooldown=0;p.request_dodge_path(PackedVector2Array([Vector2.ZERO,Vector2(150,0)]))
 while not p._dodge_path.is_empty():await physics_frame
 Input.action_press("move_left")
 for i in range(65):await physics_frame
 Input.action_release("move_left")
 for i in range(40):await physics_frame
 save.end_trial_session();quit()
