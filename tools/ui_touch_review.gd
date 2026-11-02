extends SceneTree
## Real viewport input verification without the GUT overlay consuming GUI events.
var level: Node
var output_dir: String = "/downloads/gorodeo/ui-review"
func _initialize() -> void:
	DirAccess.make_dir_recursive_absolute(output_dir)
	call_deferred("run")
func tap(control: Control) -> void:
	var point: Vector2 = control.get_global_rect().get_center()
	for pressed: bool in [true, false]:
		var event := InputEventScreenTouch.new()
		event.index = 0
		event.position = point
		event.pressed = pressed
		root.push_input(event)
		await process_frame
func shot(filename: String) -> void:
	await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png(output_dir.path_join(filename))
func run() -> void:
	root.get_node("GameState").selected_level = 1
	level = load("res://src/Presentation/level_0.tscn").instantiate()
	root.add_child(level)
	await process_frame
	await process_frame
	await tap(level.hud._pause_button)
	print("PAUSE_TOUCH ", paused)
	await shot("pause-touch.png")
	if paused:
		var resume: Button
		for node in level.hud._pause_panel.get_children():
			if node is Button and node.text == "Continuar": resume = node
		await tap(resume)
		print("RESUME_TOUCH ", not paused)
	level.pause_game()
	var escape := InputEventKey.new()
	escape.keycode = KEY_ESCAPE
	escape.pressed = true
	root.push_input(escape)
	await process_frame
	print("ESCAPE_RESUMES ", not paused)
	if paused: level.resume_game()
	level._trigger_lose("Prueba táctil del panel final")
	await process_frame
	await shot("lose-touch.png")
	var quit_received: Array = []
	level.hud.quit_requested.disconnect(level._on_quit_requested)
	level.hud.quit_requested.connect(func(): quit_received.append(true))
	await tap(level.hud.quit_button)
	print("END_MENU_TOUCH ", not quit_received.is_empty())
	# Reuse the HUD-only win display, without writing progression or loading scenes.
	level.hud.show_win()
	await process_frame
	var next_received: Array = []
	level.hud.next_requested.disconnect(level._on_next_requested)
	level.hud.next_requested.connect(func(): next_received.append(true))
	await shot("win-touch.png")
	await tap(level.hud._next_button)
	print("NEXT_TOUCH ", not next_received.is_empty())
	level.queue_free()
	await process_frame
	await process_frame
	quit()
