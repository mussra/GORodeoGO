extends SceneTree
var note:Label
func _initialize()->void:call_deferred("run")
func run()->void:
 root.get_node("SaveData").dual_lasso_intro_shown=true
 root.get_node("GameState").selected_level=5
 var level=load("res://src/Presentation/level_0.tscn").instantiate();root.add_child(level);await physics_frame
 for b in level._active_bulls:b.set_physics_process(false);b.global_position=Vector2(1500,1500)
 var layer:=CanvasLayer.new();layer.layer=100;root.add_child(layer)
 var bg:=ColorRect.new();bg.color=Color(0,0,0,.9);bg.position=Vector2(12,65);bg.size=Vector2(1256,86);layer.add_child(bg)
 note=Label.new();note.position=Vector2(28,75);note.add_theme_font_size_override("font_size",22);layer.add_child(note)
 var p:Node=level.player;p.global_position=Vector2(-150,100)
 var b:Node=level._active_bulls[0];b.global_position=Vector2(-240,100);b.try_capture(b.global_position);b.set_physics_process(true)
 note.text="ENSAYO: regate y doble lazo disponibles sin alterar avance\nToros ajenos congelados para mostrar recuperación"
 await create_timer(.6).timeout
 Input.action_press("move_right");await create_timer(1.6).timeout;Input.action_release("move_right")
 p.global_position=Vector2(440,140);p.velocity=Vector2.ZERO;b.global_position=Vector2(370,140);b._tow_path.clear()
 note.text="BORDE: toro con colisión real tras el jinete\nRecupera hacia posición reciente, no reproduce toda la cola antigua"
 Input.action_press("move_right");await create_timer(.75).timeout;Input.action_release("move_right")
 Input.action_press("move_up");await create_timer(.84).timeout;Input.action_release("move_up")
 Input.action_press("move_left");await create_timer(1.15).timeout;Input.action_release("move_left")
 await create_timer(1.2).timeout
 root.get_texture().get_image().save_png("/downloads/gameplay-edge-recovered.png")
 note.text="DOBLE LAZO: segundo gesto empieza aún durante vuelo del primero\nSe conserva la pulsación y puede lanzar al aterrizar el primer lazo"
 b.controller.force_escape();b.set_physics_process(false);b.global_position=Vector2(150,0);p.cancel_all_actions();p.global_position=Vector2.ZERO;level._update_nerves_hud()
 p._on_aim_pressed();p._on_aim_released(Vector2(150.0/p.max_throw_distance,0));p._on_aim_pressed();await create_timer(p.lasso_travel_time+.05).timeout
 assert(p._is_charging)
 var second:Node=level._active_bulls[1];second.global_position=Vector2(0,150)
 p._on_aim_released(Vector2(0,150.0/p.max_throw_distance));await create_timer(p.lasso_travel_time+.1).timeout
 assert(second.controller.is_held());assert(p._active_capture_count==2)
 await create_timer(.8).timeout
 b.controller.use_tranquilizer();assert(b.controller.return_to_pen());second.controller.use_tranquilizer();assert(second.controller.return_to_pen())
 assert(b.controller.current_state()==BullState.State.SAFE);assert(second.controller.current_state()==BullState.State.SAFE)
 note.text="TOROS SEGUROS: estado SAFE sin exclamación de perseguidor\nPrueba controlada en motor, no validación en Android"
 await create_timer(1.5).timeout
 root.get_texture().get_image().save_png("/downloads/gameplay-safe-no-alert.png")
 print("GAMEPLAY_FIXES_VIDEO_ASSERTIONS_PASSED")
 quit()
