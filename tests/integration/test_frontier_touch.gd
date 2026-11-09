extends GutTest
## Phone-like touch events for the world HUD (Ant 18:17: "sigo sin apuntar y
## sin clickar botones"). Requires a real display server (X11): with
## --headless the engine dispatches NO GUI input at all.
## Run: xvfb-run -a godot --path . -s addons/gut/gut_cmdln.gd "-gconfig=" -gtest=res://tests/integration/test_frontier_touch.gd -gexit

var _gui_hits: Array = []

func _silence_runner_ui() -> void:
	var stack: Array = [get_tree().root]
	while not stack.is_empty():
		var n: Node = stack.pop_back()
		if n is Control:
			(n as Control).mouse_filter = Control.MOUSE_FILTER_IGNORE
		for ch in n.get_children():
			stack.append(ch)

func _fresh_world() -> Node2D:
	_silence_runner_ui()
	SaveData.world_seed = 424242
	SaveData.world_discovered.clear()
	SaveData.world_tamed.clear()
	SaveData.world_missions.clear()
	SaveData.world_pigs.clear()
	SaveData.world_edits.clear()
	SaveData.horse_collection.seed_trial()
	SaveData.world_position = Vector2(0, 160)
	var world: Node2D = load("res://src/Presentation/frontier_world.tscn").instantiate()
	add_child_autofree(world)
	return world

func _touch(pos: Vector2, pressed: bool) -> void:
	var ev := InputEventScreenTouch.new()
	ev.index = 1
	ev.position = pos
	ev.pressed = pressed
	Input.parse_input_event(ev)

func _drag(pos: Vector2) -> void:
	var ev := InputEventScreenDrag.new()
	ev.index = 1
	ev.position = pos
	Input.parse_input_event(ev)

func _find_button(world: Node2D, key: String) -> Button:
	for b in world._hud.get_children():
		if b is Button and b.text == tr(key):
			return b
	return null

func test_tap_reaches_world_menu_then_map() -> void:
	var world := _fresh_world()
	await wait_process_frames(4)
	var btn := _find_button(world, "Menú")
	assert_not_null(btn, "single world menu button exists")
	_gui_hits.clear()
	btn.gui_input.connect(func(ev: InputEvent) -> void: _gui_hits.append(ev))
	var pos := btn.get_global_rect().get_center()
	_touch(pos, true)
	await wait_process_frames(3)
	_touch(pos, false)
	await wait_process_frames(3)
	assert_gt(_gui_hits.size(), 0, "tap events reach the Mapa button (not eaten by another layer)")
	await wait_process_frames(2)
	assert_not_null(world._navigation,"menu opens from HUD touch")
	var map_card:Button=world._navigation.canvas.get_node("Navigate_map")
	var sender:=GutInputSender.new(Input);sender.set_auto_flush_input(true)
	var point:Vector2=get_tree().root.get_final_transform()*map_card.get_global_rect().get_center()
	sender.mouse_motion(point);sender.mouse_left_button_down(point);await wait_process_frames(2)
	sender.mouse_left_button_up(point);await wait_process_frames(3);sender.release_all()
	assert_true(world._map_overlay.expanded,"Mapa card expands map")
	assert_false(get_tree().paused,"navigation restores gameplay")

func test_touch_aim_zone_charges_lasso() -> void:
	var world := _fresh_world()
	await wait_process_frames(4)
	_touch(Vector2(1000, 500), true)
	await wait_process_frames(4)
	assert_true(world.player.lasso._is_charging, "touch in the aim zone starts the charge")
	_drag(Vector2(1080, 480))
	await wait_process_frames(3)
	_touch(Vector2(1080, 480), false)
	await wait_process_frames(3)
	assert_true(world.player.lasso._lasso_in_flight, "drag release throws the rope")

func test_top_buttons_not_covered_by_joystick() -> void:
	var world := _fresh_world()
	await wait_process_frames(4)
	var aim: Control = null
	for c in world.get_children():
		if c is CanvasLayer:
			var j := c.get_node_or_null("AimJoystick")
			if j != null:
				aim = j
	assert_not_null(aim, "aim joystick exists")
	for key in ["Menú"]:
		var btn := _find_button(world, key)
		assert_false(aim.get_global_rect().intersects(btn.get_global_rect()), "%s button outside the aim joystick zone" % key)

func test_navigation_restores_pause_repeatedly_and_editor_tools_use_same_modal() -> void:
	var world := _fresh_world()
	await wait_process_frames(5)
	for cycle in range(3):
		world._open_navigation()
		await wait_process_frames(4)
		assert_true(get_tree().paused)
		var sheet:Control=world._navigation
		world._close_navigation();sheet.queue_free()
		await wait_process_frames(4)
		assert_false(get_tree().paused)
	world._toggle_edit();world._open_edit_tools()
	await wait_process_frames(5)
	var drawer:FilterDrawer=null
	for child in world._hud.get_children():
		if child is FilterDrawer:drawer=child
	assert_not_null(drawer)
	assert_false(drawer.show_clear)
	assert_eq(drawer.title,"Editor · herramientas")
	var pick:OptionButton=drawer.fields.get_child(0).get_child(1)
	assert_eq(pick.item_count,9,"tools have no meaningless Todos entry")
	drawer.changed.emit("tool","rock");assert_eq(world._edit_tool,"rock")
	drawer.queue_free();world._toggle_edit()
