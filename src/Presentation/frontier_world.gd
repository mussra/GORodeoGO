extends Node2D
## Frontera: bounded open-world test (Ant, 7-nov-2026). Seeded chunks stream around
## the rider; herds are found missions, the ranch board assigns one encargo at a
## time; taming adds the horse to the cuadra. No online, no purchases, no dismount.

const PlayerScript := preload("res://src/Presentation/world_player.gd")
const WildHorseScript := preload("res://src/Presentation/wild_horse.gd")
const DecorScript := preload("res://src/Presentation/world_decor.gd")
const RanchScript := preload("res://src/Presentation/world_ranch.gd")
const PigScript := preload("res://src/Presentation/wild_pig.gd")
const TrailScript := preload("res://src/Presentation/frontier_trail.gd")

const BOARD_POS := Vector2(145, -20)
const HOME_POS := Vector2(0, 160)
const SAVE_EVERY := 4.0
const ARROWS: Array[String] = ["↑", "↗", "→", "↘", "↓", "↙", "←", "↖"]

var player: CharacterBody2D
var _chunks: Dictionary = {}
var _hud: CanvasLayer
var _gait_label: Label
var _missions_label: Label
var _toast_label: Label
var _toast_left: float = 0.0
var _map_overlay: Control
var _board_button: Button
var _board_panel: Control
var _save_timer: float = 0.0
var _last_gait: int = -1
var _pigs_label: Label
var _edit_mode: bool = false
var _stamina: Dictionary = {}
var _gauges: Dictionary = {}
var _pant: AudioStream = load("res://art/audio/pant.wav")
var _edit_tool: String = "tree"
var _edit_panel: Control
var _hoof_player: AudioStreamPlayer
var _step_timer: float = 0.0
var _step_alt: bool = false
var _clop_a: AudioStream = load("res://art/audio/hoof_a.wav")
var _clop_b: AudioStream = load("res://art/audio/hoof_b.wav")

func _ready() -> void:
	SaveData.ensure_world_seed()
	var base := ColorRect.new()
	base.color = Color("2e5d33")
	base.size = Vector2(262144, 262144)
	base.position = -base.size / 2
	base.z_index = -10
	add_child(base)
	player = PlayerScript.new()
	player.position = SaveData.world_position
	add_child(player)
	var camera := Camera2D.new()
	player.add_child(camera)
	camera.make_current()
	var ranch := RanchScript.new()
	add_child(ranch)
	_build_hud()
	_stamina = WorldStamina.new_state(HorseStats.read(SaveData.horse_collection.find(SaveData.horse_collection.selected)).get("power", 0.65))
	_hoof_player = AudioStreamPlayer.new()
	_hoof_player.volume_db = -12.0
	_hoof_player.bus = &"SFX" if AudioServer.get_bus_index("SFX") >= 0 else &"Master"
	player.add_child(_hoof_player)
	_update_chunks()

func _process(delta: float) -> void:
	_update_chunks()
	_tick_taming(delta)
	_tick_pigs(delta)
	_tick_hoofbeats(delta)
	_tick_stamina(delta)
	if player.gait != _last_gait:
		_last_gait = player.gait
		_gait_label.text = tr(WorldGait.gait_names()[_last_gait])
	if _toast_left > 0.0:
		_toast_left -= delta
		_toast_label.modulate.a = clampf(_toast_left, 0.0, 1.0)
	_board_button.visible = player.position.distance_to(BOARD_POS) < 150.0
	_save_timer += delta
	if _save_timer >= SAVE_EVERY:
		_save_timer = 0.0
		SaveData.save_world_state(player.position)

func _toast(text: String) -> void:
	_toast_label.text = text
	_toast_left = 3.0
	_toast_label.modulate.a = 1.0

func _update_chunks() -> void:
	var pc: Vector2i = WorldMap.chunk_at(player.position)
	for dx in range(-1, 2):
		for dy in range(-1, 2):
			_ensure_chunk(pc.x + dx, pc.y + dy)
	for key in _chunks.keys():
		var c: Vector2i = _chunks[key].get_meta("c")
		if absi(c.x - pc.x) > 2 or absi(c.y - pc.y) > 2:
			_chunks[key].queue_free()
			_chunks.erase(key)

func _ensure_chunk(cx: int, cy: int) -> void:
	var key: String = WorldMap.chunk_key(cx, cy)
	if _chunks.has(key):
		return
	var chunk: Dictionary = WorldEdits.apply(WorldMap.generate(SaveData.world_seed, cx, cy), SaveData.world_edits, cx, cy)
	var node := Node2D.new()
	node.set_meta("c", Vector2i(cx, cy))
	var ground := ColorRect.new()
	ground.color = Color("32653a").lerp(Color("3a7142"), float(absi(hash(key)) % 100) / 220.0)
	ground.size = Vector2(WorldMap.CHUNK_SIZE, WorldMap.CHUNK_SIZE)
	ground.position = Vector2(cx, cy) * WorldMap.CHUNK_SIZE
	ground.z_index = -9
	node.add_child(ground)
	for d in chunk.get("decor", []):
		var decor := DecorScript.new()
		decor.kind = d["kind"]
		decor.size_scale = d["scale"]
		decor.position = d["pos"]
		node.add_child(decor)
	var herd: Dictionary = chunk.get("herd", {})
	var mission_id: String = WorldMap.herd_mission_id(cx, cy)
	if not herd.is_empty() and not SaveData.world_tamed.has(mission_id):
		var horse := WildHorseScript.new()
		horse.name = "herd"
		horse.setup(herd)
		node.add_child(horse)
		var bar := ProgressBar.new()
		bar.name = "bar"
		bar.min_value = 0.0
		bar.max_value = 1.0
		bar.size = Vector2(64, 8)
		bar.position = Vector2(-32, -64)
		bar.show_percentage = false
		bar.visible = false
		horse.add_child(bar)
	var trail := TrailScript.new()
	trail.c = Vector2i(cx, cy)
	node.add_child(trail)
	var pigs: Dictionary = chunk.get("pigs", {})
	var pig_id: String = WorldEdits.edited_pen_id(pigs.get("pos", Vector2.ZERO)) if pigs.get("edited", false) else WorldMap.pig_id(cx, cy)
	if not pigs.is_empty() and not SaveData.world_pigs.has(pig_id):
		var pen := Node2D.new()
		pen.name = "pigs"
		var base: Vector2 = pigs["pos"]
		for i in int(pigs.get("count", 2)):
			var pig := PigScript.new()
			pig.name = "pig%d" % i
			pig.setup({"pos": base + Vector2(cos(i * TAU / maxf(1.0, float(pigs.get("count", 2)))), sin(i * TAU / maxf(1.0, float(pigs.get("count", 2))))) * 44.0})
			pen.add_child(pig)
			var pbar := ProgressBar.new()
			pbar.name = "bar"
			pbar.min_value = 0.0
			pbar.max_value = 1.0
			pbar.size = Vector2(48, 7)
			pbar.position = Vector2(-24, -44)
			pbar.show_percentage = false
			pbar.visible = false
			pig.add_child(pbar)
		node.add_child(pen)
	add_child(node)
	_chunks[key] = node
	if not SaveData.world_discovered.has(key):
		SaveData.mark_world_discovered(key)
		if not herd.is_empty() and not SaveData.world_tamed.has(mission_id) and not SaveData.world_missions.has(mission_id):
			SaveData.set_world_mission(mission_id, "offered")
			_toast(tr("WORLD_FOUND"))
			_refresh_missions()
			SaveData.save_world_state(player.position)

func _tick_taming(delta: float) -> void:
	for key in _chunks:
		var node: Node2D = _chunks[key]
		var horse: Node2D = node.get_node_or_null("herd")
		if horse == null:
			continue
		var dist: float = player.position.distance_to(horse.position)
		if dist > 700.0:
			continue
		var st: Dictionary = WorldTaming.tick(horse.state, dist, player.velocity.length(), player.calm(), float(horse.herd.get("temperament", 0.5)), delta)
		horse.state = st
		var bar: ProgressBar = horse.get_node("bar")
		bar.value = st.get("progress", 0.0)
		bar.visible = bar.value > 0.01
		if WorldTaming.tamed(st):
			_on_tamed(Vector2i(node.get_meta("c")), horse)
		elif WorldTaming.should_flee(st, dist):
			horse.flee_from(player.position, delta)
		elif dist < WorldTaming.CALM_RANGE * 1.5:
			horse.face_towards(player.position)

func _on_tamed(c: Vector2i, horse: Node2D) -> void:
	var mission_id: String = WorldMap.herd_mission_id(c.x, c.y)
	var was_encargo: bool = SaveData.world_missions.get(mission_id, "") == "encargo"
	SaveData.mark_world_tamed(mission_id)
	var herd: Dictionary = horse.herd
	var stats: Dictionary = herd.get("stats", {"speed": 265.0, "handling": 950.0, "power": 0.65, "dodge": 0.9}).duplicate()
	stats["calm"] = clampf(float(herd.get("calm", 1.0)), 0.5, 2.0)
	var traits: Dictionary = herd.get("traits", {})
	var h: Dictionary = {"id": "world_%d_%d" % [c.x, c.y], "parents": [], "stage": "adult", "traits": traits, "stats": stats, "can_jump": false, "can_dodge": false}
	h["name"] = SaveData.horse_collection.suggest_name(traits)
	SaveData.horse_collection.horses.append(h)
	WorldMissions.complete(mission_id)
	horse.queue_free()
	SaveData.save_world_state(player.position)
	_refresh_missions()
	_toast(tr("WORLD_TAMED") + (" " + tr("WORLD_ENCARGO_DONE") if was_encargo else ""))

func _tick_pigs(delta: float) -> void:
	for key in _chunks:
		var node: Node2D = _chunks[key]
		var pen: Node2D = node.get_node_or_null("pigs")
		if pen == null:
			continue
		var all_captured: bool = true
		for pig in pen.get_children():
			if pig.name == "bar":
				continue
			var dist: float = player.position.distance_to(pig.position)
			if dist > 700.0:
				all_captured = false
				continue
			var st: Dictionary = WorldPigs.tick(pig.state, dist, player.velocity.length(), delta)
			pig.state = st
			var bar: ProgressBar = pig.get_node("bar")
			bar.value = st.get("progress", 0.0)
			bar.visible = bar.value > 0.01
			if WorldPigs.captured(st):
				pig.queue_free()
			else:
				all_captured = false
				if st.get("flee", false):
					pig.flee_from(player.position, delta)
				elif dist < WorldPigs.CAPTURE_RANGE * 1.5:
					pig.face_towards(player.position)
		if all_captured and pen.get_child_count() == 0:
			_on_pigs_captured(Vector2i(node.get_meta("c")), pen)

func _on_pigs_captured(c: Vector2i, pen: Node2D) -> void:
	SaveData.world_pigs.append(_pen_id_for(c))
	pen.queue_free()
	SaveData.save_world_state(player.position)
	_pigs_label.text = tr("WORLD_PIGS") % SaveData.world_pigs.size()
	_toast(tr("WORLD_PIG_CAPTURED") % SaveData.world_pigs.size())

func _pen_id_for(c: Vector2i) -> String:
	var chunk: Dictionary = WorldEdits.apply(WorldMap.generate(SaveData.world_seed, c.x, c.y), SaveData.world_edits, c.x, c.y)
	var pigs: Dictionary = chunk.get("pigs", {})
	return WorldEdits.edited_pen_id(pigs.get("pos", Vector2.ZERO)) if pigs.get("edited", false) else WorldMap.pig_id(c.x, c.y)

func _tick_hoofbeats(delta: float) -> void:
	var speed: float = player.velocity.length()
	if speed < 12.0:
		_step_timer = 0.10
		return
	_step_timer -= delta
	if _step_timer > 0.0:
		return
	var intervals: Array[float] = [0.50, 0.33, 0.23]
	_step_timer = intervals[clampi(player.gait, 0, 2)] * clampf(WorldGait.speed_for(player.gait, player.max_speed) / maxf(speed, 1.0), 0.8, 1.6)
	_step_alt = not _step_alt
	_hoof_player.stream = _clop_a if _step_alt else _clop_b
	_hoof_player.pitch_scale = randf_range(0.92, 1.08) * (0.94 if player.gait == WorldGait.GALOPE else 1.0)
	_hoof_player.play()

func _toggle_edit() -> void:
	_edit_mode = not _edit_mode
	if _edit_mode:
		_open_edit_palette()
	elif is_instance_valid(_edit_panel):
		_edit_panel.queue_free()

func _open_edit_palette() -> void:
	if is_instance_valid(_edit_panel):
		_edit_panel.queue_free()
	_edit_panel = Panel.new()
	_edit_panel.position = Vector2(20, 56)
	_edit_panel.size = Vector2(640, 150)
	_edit_panel.z_index = 40
	_hud.add_child(_edit_panel)
	var hint := Label.new()
	hint.text = tr("WORLD_EDIT_HINT")
	hint.position = Vector2(14, 8)
	hint.size = Vector2(610, 26)
	hint.add_theme_font_size_override("font_size", 16)
	_edit_panel.add_child(hint)
	var tools_: Array = [["tree", "WORLD_DECOR_TREE"], ["pine", "WORLD_DECOR_PINE"], ["fruit_tree", "WORLD_DECOR_FRUIT"], ["bush", "WORLD_DECOR_BUSH"], ["rock", "WORLD_DECOR_ROCK"], ["cactus", "WORLD_DECOR_CACTUS"], ["flower", "WORLD_DECOR_FLOWER"], ["pigs", "WORLD_EDIT_PIGS"], ["erase", "WORLD_ERASE"]]
	for i in tools_.size():
		var b := Button.new()
		b.text = tr(tools_[i][1])
		b.position = Vector2(14 + (i % 5) * 124, 40 + (i / 5) * 52)
		b.size = Vector2(116, 44)
		var tool: String = tools_[i][0]
		b.pressed.connect(func(): _edit_tool = tool)
		_edit_panel.add_child(b)

func _unhandled_input(event: InputEvent) -> void:
	if not _edit_mode:
		return
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		var pos: Vector2 = get_global_mouse_position()
		var op: Dictionary
		match _edit_tool:
			"erase":
				op = {"type": "remove_decor", "pos": pos, "radius": 120.0}
			"pigs":
				op = {"type": "add_pigs", "pos": pos, "count": 3}
			_:
				op = {"type": "add_decor", "kind": _edit_tool, "pos": pos, "scale": 1.0}
		SaveData.world_edits.append(op)
		SaveData.save_world_state(player.position)
		for key in _chunks.keys():
			_chunks[key].queue_free()
		_chunks.clear()
		_update_chunks()

func _tick_stamina(delta: float) -> void:
	var before: Dictionary = _stamina
	_stamina = WorldStamina.tick(_stamina, player.gait, player.velocity.length() > 12.0, delta)
	player.gait_cap = WorldStamina.cap_gait(_stamina, WorldGait.GALOPE)
	if WorldStamina.just_tired(before, _stamina):
		_toast(tr("WORLD_HORSE_TIRED"))
		_hoof_player.stream = _pant
		_hoof_player.pitch_scale = 1.0
		_hoof_player.play()
	_gauges["stamina"].set_state(true, WorldStamina.ratio(_stamina))

func _refresh_missions() -> void:
	var counts: Dictionary = WorldMissions.counts()
	_missions_label.text = tr("WORLD_MISSIONS") % [counts.get("offered", 0) + counts.get("encargo", 0), counts.get("done", 0)]

func _home() -> void:
	var tween := create_tween()
	tween.tween_property(player, "position", HOME_POS, 0.6).set_trans(Tween.TRANS_SINE)
	tween.tween_callback(func(): SaveData.save_world_state(player.position))

func _menu() -> void:
	SaveData.save_world_state(player.position)
	get_tree().change_scene_to_file("res://src/Presentation/main_menu.tscn")

static func arrow_to(from: Vector2, to: Vector2) -> String:
	var d: Vector2 = to - from
	var idx: int = int(round(atan2(d.y, d.x) / (PI / 4.0))) % 8
	return ARROWS[(idx + 2) % 8]  # index 0 = up on screen (negative y)

func _build_hud() -> void:
	_hud = CanvasLayer.new()
	add_child(_hud)
	var bar := ColorRect.new()
	bar.color = Color(0.06, 0.15, 0.17, 0.85)
	bar.size = Vector2(1280, 46)
	_hud.add_child(bar)
	_gait_label = Label.new()
	_gait_label.position = Vector2(16, 10)
	_gait_label.add_theme_font_size_override("font_size", 22)
	_hud.add_child(_gait_label)
	_missions_label = Label.new()
	_missions_label.position = Vector2(150, 12)
	_missions_label.add_theme_font_size_override("font_size", 18)
	_hud.add_child(_missions_label)
	_refresh_missions()
	_pigs_label = Label.new()
	_pigs_label.position = Vector2(430, 12)
	_pigs_label.add_theme_font_size_override("font_size", 18)
	_pigs_label.text = tr("WORLD_PIGS") % SaveData.world_pigs.size()
	_hud.add_child(_pigs_label)
	# clock-fill gauges (Ant 11:39/11:40): stamina + ability reminders, bottom
	# right so they never cover the touch joystick
	var horse: Dictionary = SaveData.horse_collection.find(SaveData.horse_collection.selected)
	var abilities: Array = [["stamina", true], ["dodge", HorseTraining.knows(horse, "dodge")], ["jump", HorseJump.capable(horse)]]
	for i in abilities.size():
		var g := RadialGauge.new()
		g.skill = abilities[i][0]
		g.position = Vector2(1046 + i * 84, 636)
		g.size = Vector2(76, 76)
		g.set_state(abilities[i][1], 1.0)
		_gauges[abilities[i][0]] = g
		_hud.add_child(g)
	var specs: Array = [["WORLD_MAP", 760, Callable(self, "_toggle_map")], ["WORLD_EDIT", 870, Callable(self, "_toggle_edit")], ["WORLD_HOME", 980, Callable(self, "_home")], ["WORLD_MENU", 1150, Callable(self, "_menu")]]
	for spec in specs:
		var b := Button.new()
		b.text = tr(spec[0])
		b.position = Vector2(spec[1], 6)
		b.size = Vector2(100 if spec[0] != "WORLD_HOME" else 150, 34)
		b.pressed.connect(spec[2])
		_hud.add_child(b)
	_toast_label = Label.new()
	_toast_label.position = Vector2(340, 60)
	_toast_label.size = Vector2(600, 34)
	_toast_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_toast_label.add_theme_font_size_override("font_size", 21)
	_toast_label.add_theme_color_override("font_outline_color", Color("10252d"))
	_toast_label.add_theme_constant_override("outline_size", 6)
	_toast_label.modulate.a = 0.0
	_hud.add_child(_toast_label)
	_board_button = Button.new()
	_board_button.text = tr("WORLD_BOARD")
	_board_button.position = Vector2(510, 640)
	_board_button.size = Vector2(260, 46)
	_board_button.visible = false
	_board_button.pressed.connect(_open_board)
	_hud.add_child(_board_button)
	_map_overlay = DiscoveryMap.new()
	_map_overlay.world = self
	_map_overlay.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	_map_overlay.visible = false
	_hud.add_child(_map_overlay)
	var touch := CanvasLayer.new()
	touch.name = "TouchControls"
	touch.layer = 2
	add_child(touch)
	var joy := VirtualJoystick.new()
	joy.name = "MoveJoystick"
	joy.anchor_right = 0.5
	joy.anchor_bottom = 1.0
	joy.joystick_mode = 2
	joy.visibility_mode = 1
	joy.joystick_size = 220.0
	joy.tip_size = 80.0
	joy.action_left = &"move_left"
	joy.action_right = &"move_right"
	joy.action_up = &"move_up"
	joy.action_down = &"move_down"
	touch.add_child(joy)

func _toggle_map() -> void:
	_map_overlay.visible = not _map_overlay.visible
	if _map_overlay.visible:
		_map_overlay.queue_redraw()

func _open_board() -> void:
	if is_instance_valid(_board_panel):
		_board_panel.queue_free()
	var encargo: String = WorldMissions.current_encargo()
	if encargo.is_empty():
		encargo = WorldMissions.assign_encargo(SaveData.world_seed)
	_board_panel = Panel.new()
	_board_panel.position = Vector2(390, 200)
	_board_panel.size = Vector2(500, 240)
	_board_panel.z_index = 50
	_hud.add_child(_board_panel)
	var title := Label.new()
	title.text = tr("WORLD_BOARD")
	title.position = Vector2(20, 14)
	title.add_theme_font_size_override("font_size", 22)
	_board_panel.add_child(title)
	var body := Label.new()
	body.position = Vector2(20, 56)
	body.size = Vector2(460, 110)
	body.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	body.add_theme_font_size_override("font_size", 18)
	_board_panel.add_child(body)
	if encargo.is_empty():
		body.text = tr("WORLD_BOARD_NONE")
	else:
		var c: Vector2i = WorldMissions.herd_chunk(encargo)
		var herd: Dictionary = WorldMap.generate(SaveData.world_seed, c.x, c.y).get("herd", {})
		var target: Vector2 = herd.get("pos", Vector2.ZERO)
		body.text = tr("WORLD_BOARD_ACTIVE") % [arrow_to(player.position, target), int(player.position.distance_to(target) / 8.0)]
	var close := Button.new()
	close.text = tr("WORLD_CLOSE")
	close.position = Vector2(190, 180)
	close.size = Vector2(120, 42)
	close.pressed.connect(func(): _board_panel.queue_free())
	_board_panel.add_child(close)

class DiscoveryMap extends Control:
	## Self-drawing discovery map (Ant 11:29): explored chunks show their caminos,
	## ranch, trees/rocks, seen pig pens and missions; unseen stays hidden; player
	## marker; drag to scroll, +/- to zoom. Content comes from the persisted
	## discovered chunks, so it is saved with the game. Cartoon style.
	var world: Node2D
	var zoom: float = 1.0
	var pan: Vector2 = Vector2.ZERO
	var _dragging: bool = false
	var _drag_from: Vector2 = Vector2.ZERO
	var _pan_from: Vector2 = Vector2.ZERO

	func _ready() -> void:
		mouse_filter = Control.MOUSE_FILTER_STOP
		var minus := Button.new()
		minus.text = "-"
		minus.position = Vector2(24, size.y - 84)
		minus.size = Vector2(56, 56)
		minus.pressed.connect(func(): _set_zoom(zoom / 1.4))
		add_child(minus)
		var plus := Button.new()
		plus.text = "+"
		plus.position = Vector2(96, size.y - 84)
		plus.size = Vector2(56, 56)
		plus.pressed.connect(func(): _set_zoom(zoom * 1.4))
		add_child(plus)

	func _set_zoom(z: float) -> void:
		zoom = clampf(z, 0.5, 3.0)
		queue_redraw()

	func _gui_input(event: InputEvent) -> void:
		if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
			_dragging = event.pressed
			_drag_from = event.position
			_pan_from = pan
		elif event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_WHEEL_UP and event.pressed:
			_set_zoom(zoom * 1.15)
		elif event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_WHEEL_DOWN and event.pressed:
			_set_zoom(zoom / 1.15)
		elif event is InputEventMouseMotion and _dragging:
			pan = _pan_from + (event.position - _drag_from)
			queue_redraw()

	func _cells() -> Dictionary:
		var out: Dictionary = {"cells": [], "mins": Vector2i.ZERO, "maxs": Vector2i.ZERO}
		var mins := Vector2i(1 << 30, 1 << 30)
		var maxs := Vector2i(-(1 << 30), -(1 << 30))
		for key in SaveData.world_discovered:
			var parts := str(key).split(",")
			if parts.size() != 2:
				continue
			var c := Vector2i(int(parts[0]), int(parts[1]))
			out.cells.append(c)
			mins = Vector2i(mini(mins.x, c.x), mini(mins.y, c.y))
			maxs = Vector2i(maxi(maxs.x, c.x), maxi(maxs.y, c.y))
		mins = Vector2i(mini(mins.x, 0), mini(mins.y, 0))
		maxs = Vector2i(maxi(maxs.x, 0), maxi(maxs.y, 0))
		out.mins = mins
		out.maxs = maxs
		return out

	func _chunk_rect(c: Vector2i, mins: Vector2i, cell: float, origin: Vector2) -> Rect2:
		return Rect2(origin + Vector2(c - mins) * cell, Vector2.ONE * cell)

	func _to_map(pos: Vector2, mins: Vector2i, cell: float, origin: Vector2) -> Vector2:
		return origin + (pos / WorldMap.CHUNK_SIZE - Vector2(mins)) * cell

	func _draw() -> void:
		# parchment backdrop: unseen world stays hidden under it
		draw_rect(Rect2(Vector2.ZERO, size), Color("1d2a26"), true)
		var data: Dictionary = _cells()
		if (data.cells as Array).is_empty():
			return
		var mins: Vector2i = data.mins
		var maxs: Vector2i = data.maxs
		var cols: int = maxs.x - mins.x + 1
		var rows: int = maxs.y - mins.y + 1
		var cell: float = minf(72.0, minf((size.x - 160.0) / cols, (size.y - 160.0) / rows)) * zoom
		var origin: Vector2 = (size - Vector2(cols, rows) * cell) / 2.0 + pan
		var font: Font = get_theme_default_font()
		for c in data.cells:
			var r: Rect2 = _chunk_rect(c, mins, cell, origin)
			# cartoon ground tile with a soft rim
			draw_rect(r.grow(1.0), Color("24513c"), true)
			draw_rect(r, Color("3f7a45"), true)
			var chunk: Dictionary = WorldEdits.apply(WorldMap.generate(SaveData.world_seed, c.x, c.y), SaveData.world_edits, c.x, c.y)
			_draw_trails(c, mins, cell, origin, r)
			_draw_decor(chunk, mins, cell, origin, r)
			if WorldMap.is_ranch_chunk(c.x, c.y):
				_draw_ranch(r)
			var pen: Dictionary = chunk.get("pigs", {})
			if not pen.is_empty():
				var pid: String = WorldEdits.edited_pen_id(pen.get("pos", Vector2.ZERO)) if pen.get("edited", false) else WorldMap.pig_id(c.x, c.y)
				var pc: Vector2 = _to_map(pen.get("pos", Vector2.ZERO), mins, cell, origin)
				var col: Color = Color("f2a7b8") if not SaveData.world_pigs.has(pid) else Color("f2a7b866")
				draw_circle(pc, maxf(3.0, cell * 0.07), col)
			_mission_mark(c, r, font, cell)
		# player marker: warm dot with a dark ring
		var ppos: Vector2 = _to_map(world.player.position, mins, cell, origin)
		draw_circle(ppos, cell * 0.16, Color("201b1c"))
		draw_circle(ppos, cell * 0.12, Color("f8edce"))
		draw_circle(ppos, cell * 0.05, Color("d94f3d"))

	func _draw_trails(c: Vector2i, mins: Vector2i, cell: float, origin: Vector2, r: Rect2) -> void:
		# clip every dot to its own discovered tile: unseen world stays hidden
		var seed: int = SaveData.world_seed
		var worigin: Vector2 = Vector2(c) * WorldMap.CHUNK_SIZE
		var col := Color("a5825a")
		var dot: float = maxf(2.0, cell * 0.055)
		var clip: Rect2 = r.grow(dot * 0.5)
		for i in range(0, 9):
			var wx: float = worigin.x + i * WorldMap.CHUNK_SIZE / 8.0
			var p1 := Vector2(wx, WorldMap.trail_y_at(seed, wx))
			var m1: Vector2 = _to_map(p1, mins, cell, origin)
			if clip.has_point(m1):
				draw_circle(m1, dot, col)
			var wy: float = worigin.y + i * WorldMap.CHUNK_SIZE / 8.0
			var p2 := Vector2(WorldMap.branch_x_at(seed, wy), wy)
			var m2: Vector2 = _to_map(p2, mins, cell, origin)
			if clip.has_point(m2):
				draw_circle(m2, dot, col)

	func _draw_decor(chunk: Dictionary, mins: Vector2i, cell: float, origin: Vector2, r: Rect2) -> void:
		var dot: float = maxf(1.6, cell * 0.035)
		for d in chunk.get("decor", []):
			var p: Vector2 = _to_map(d["pos"], mins, cell, origin)
			if not r.grow(4.0).has_point(p):
				continue
			match d.get("kind", ""):
				"tree", "fruit_tree":
					draw_circle(p, dot * 1.4, Color("2f5d33"))
				"pine":
					draw_colored_polygon(PackedVector2Array([p + Vector2(-dot * 1.4, dot), p + Vector2(0, -dot * 1.6), p + Vector2(dot * 1.4, dot)]), Color("2f5d33"))
				"rock":
					draw_circle(p, dot, Color("9fabb6"))
				"bush":
					draw_circle(p, dot, Color("63a06b"))
				"cactus":
					draw_rect(Rect2(p - Vector2(dot * 0.5, dot), Vector2(dot, dot * 2.0)), Color("3e7d46"))
				"flower":
					draw_circle(p, dot, Color("e86a8a"))

	func _draw_ranch(r: Rect2) -> void:
		# little house: brown body + red roof, cartoon icon for home
		var center: Vector2 = r.position + Vector2(r.size.x * 0.16, r.size.y * 0.2)
		var s: float = maxf(4.0, r.size.x * 0.09)
		draw_rect(Rect2(center - Vector2(s, s * 0.4), Vector2(s * 2.0, s * 1.2)), Color("8a5a33"))
		draw_colored_polygon(PackedVector2Array([center + Vector2(-s * 1.2, -s * 0.4), center + Vector2(0, -s * 1.3), center + Vector2(s * 1.2, -s * 0.4)]), Color("b4452f"))

	func _mission_mark(c: Vector2i, r: Rect2, font: Font, cell: float) -> void:
		var mission_id: String = WorldMap.herd_mission_id(c.x, c.y)
		var state: String = SaveData.world_missions.get(mission_id, "")
		var pos: Vector2 = r.position + Vector2(r.size.x - cell * 0.34, r.size.y - cell * 0.1)
		if SaveData.world_tamed.has(mission_id) or state == "done":
			draw_circle(pos - Vector2(cell * 0.12, cell * 0.24), cell * 0.14, Color("b3f6df"))
			draw_string(font, pos - Vector2(cell * 0.22, cell * 0.14), "✓", HORIZONTAL_ALIGNMENT_LEFT, -1, int(cell * 0.34), Color("1d2a26"))
		elif state == "encargo":
			draw_circle(pos - Vector2(cell * 0.12, cell * 0.24), cell * 0.14, Color("f2d987"))
			draw_string(font, pos - Vector2(cell * 0.17, cell * 0.14), "!", HORIZONTAL_ALIGNMENT_LEFT, -1, int(cell * 0.34), Color("1d2a26"))
		elif state == "offered":
			draw_circle(pos - Vector2(cell * 0.12, cell * 0.24), cell * 0.14, Color("ffffff"))
			draw_string(font, pos - Vector2(cell * 0.2, cell * 0.14), "?", HORIZONTAL_ALIGNMENT_LEFT, -1, int(cell * 0.34), Color("1d2a26"))
