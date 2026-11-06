extends SceneTree
func _initialize()->void:call_deferred("run")
func run()->void:
 var gs:Node=root.get_node("GameState");gs.selected_level=5;root.get_node("SaveData").dual_lasso_intro_shown=true
 var l:Node=load("res://src/Presentation/level_0.tscn").instantiate();root.add_child(l);await physics_frame
 for b in l._active_bulls:b.set_physics_process(false)
 for i in range(2):
  var e:=InputEventScreenTouch.new();e.index=i;e.position=Vector2(240+800*i,560);e.pressed=true;Input.parse_input_event(e)
 for i in range(5):await process_frame
 root.get_texture().get_image().save_png("/downloads/joysticks-integrados.png");quit()
