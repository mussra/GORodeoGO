extends SceneTree
func _initialize()->void:call_deferred("run")
func run()->void:
 var gs:Node=root.get_node("GameState");gs.selected_level=5;root.get_node("SaveData").dual_lasso_intro_shown=true
 var l:Node=load("res://src/Presentation/level_0.tscn").instantiate();root.add_child(l);await physics_frame
 for v in [l.get_node("TouchControls/MoveJoystick"),l.aim_joystick]:
  for p in v.get_property_list():
   if "mode" in p.name or "visible" in p.name:print(v.name," ",p.name," ",v.get(p.name)," ",p.hint_string)
 await create_timer(.2).timeout;await RenderingServer.frame_post_draw;root.get_texture().get_image().save_png("/downloads/joystick-released.png")
 for i in range(2):
  var e:=InputEventScreenTouch.new();e.index=i;e.position=Vector2(240+800*i,560);e.pressed=true;Input.parse_input_event(e)
 await create_timer(.15).timeout;await RenderingServer.frame_post_draw;root.get_texture().get_image().save_png("/downloads/joystick-pressed.png")
 for i in range(2):
  var e:=InputEventScreenTouch.new();e.index=i;e.position=Vector2(240+800*i,560);e.pressed=false;Input.parse_input_event(e)
 await create_timer(.15).timeout;await RenderingServer.frame_post_draw;root.get_texture().get_image().save_png("/downloads/joystick-after-release.png");quit()
