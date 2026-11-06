extends SceneTree
func _initialize()->void:call_deferred("run")
func touch(p:Vector2,pressed:bool)->void:
 var e:=InputEventScreenTouch.new();e.index=0;e.position=p;e.pressed=pressed;Input.parse_input_event(e);Input.flush_buffered_events()
 for i in range(3):await process_frame
func run()->void:
 Input.use_accumulated_input=false
 root.get_node("GameState").selected_level=5;root.get_node("SaveData").dual_lasso_intro_shown=true
 var l:Node=load("res://src/Presentation/level_0.tscn").instantiate();root.add_child(l)
 for i in range(4):await physics_frame
 for bull in l._active_bulls:bull.set_physics_process(false)
 l.player.dodge_available=true
 var origin:Vector2=l.get_node("TouchControls/MoveJoystick").get_global_rect().get_center()
 await touch(origin,true)
 var drag:=InputEventScreenDrag.new();drag.index=0;drag.position=origin+Vector2(90,0);drag.relative=Vector2(90,0);Input.parse_input_event(drag)
 for j in range(5):
  drag.position+=Vector2(15,0);drag.relative=Vector2(15,0);Input.parse_input_event(drag.duplicate());await physics_frame
 for i in range(10):await physics_frame
 assert(l.player.velocity.length()>100.0,"Native repeated drag must be running")
 print("NATIVE_RUNNING_SPEED ",l.player.velocity.length())
 await touch(drag.position,false)
 print("NATIVE_ARMED ",l.player._running_release_at)
 await touch(origin,true)
 assert(l.player._drawing_dodge,"Running release/repress must enter dodge draw")
 print("NATIVE_REPRESS_DRAWING ",l.player._drawing_dodge)
 print("STICK RECT ",l.get_node("TouchControls/MoveJoystick").get_global_rect()," paused ",paused)
 await RenderingServer.frame_post_draw;root.get_texture().get_image().save_png("/downloads/regate-retocar-nativo.png")
 l.player.cancel_input();await touch(origin,false)
 l.player.velocity=Vector2.ZERO
 for i in range(30):await physics_frame
 await touch(origin,true)
 assert(not l.player._drawing_dodge,"Stationary first tap must not start dodge")
 await touch(origin,false)
 await touch(origin,true)
 assert(l.player._drawing_dodge,"Stationary second tap must start dodge")
 print("NATIVE_STATIONARY_DOUBLE_TAP_PASS")
 l.player.cancel_input();await touch(origin,false)
 quit()
