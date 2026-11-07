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

func test_tap_reaches_map_button() -> void:
	var world := _fresh_world()
	await wait_process_frames(4)
	var btn := _find_button(world, "WORLD_MAP")
	assert_not_null(btn, "map button exists")
	_gui_hits.clear()
	btn.gui_input.connect(func(ev: InputEvent) -> void: _gui_hits.append(ev))
	var pos := btn.get_global_rect().get_center()
	_touch(pos, true)
	await wait_process_frames(3)
	_touch(pos, false)
	await wait_process_frames(3)
	assert_gt(_gui_hits.size(), 0, "tap events reach the Mapa button (not eaten by another layer)")
	await wait_process_frames(2)
	assert_true(world._map_overlay.visible, "tapping Mapa opens the map")

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
	for key in ["WORLD_MAP", "WORLD_EDIT", "WORLD_HOME", "WORLD_MENU"]:
		var btn := _find_button(world, key)
		assert_false(aim.get_global_rect().intersects(btn.get_global_rect()), "%s button outside the aim joystick zone" % key)
