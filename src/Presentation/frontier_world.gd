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
const TestZoneScript := preload("res://src/Presentation/world_test_zone.gd")
const Physics := preload("res://src/Presentation/world_physics.gd")
const DrawNode := preload("res://src/Presentation/world_draw_node.gd")

const BOARD_POS := Vector2(145, -20)
const HOME_POS := Vector2(0, 160)
const SAVE_EVERY := 4.0
const ARROWS: Array[String] = ["↑", "↗", "→", "↘", "↓", "↙", "←", "↖"]

var player: CharacterBody2D
var _chunks: Dictionary = {}
var _chunk_entities: Dictionary = {}
var _herd_horses: Dictionary = {}
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

## Lasso in the open world (Ant, 7-nov-2026 16:20; unified with the corral control
## after "no puedo apuntar" 17:52): SAME gesture as the levels — press the aim
## stick to charge (the rope line extends with the stick), release to throw,
## release near the centre cancels, double tap drops the roped horse.
const LASSO_MAX_THROW: float = 220.0
const LASSO_FLIGHT_TIME: float = 0.8
const LASSO_CHARGE_SPEED: float = 300.0
const LASSO_COOLDOWN: float = 0.8
var _lasso_charging: bool = false
var _charge_keyboard: bool = false
var _charge_distance: float = 0.0
var _charge_visual: Line2D = null
var _aim_dir: Vector2 = Vector2.RIGHT
var _aim_pressed_at: float = 0.0
var _lasso_double_tap: DoubleTapDetector = null
var _lasso: Node2D = null
var _lasso_state: String = ""
var _lasso_flight: float = 0.0
var _lasso_cooldown: float = 0.0
var _lasso_horse: Node2D = null

## Occluder rects (owner -> Array[Rect2]): when the rider's feet are inside one,
## a tall body (house, tree, cactus) covers him, so a marker floats above him
## (Ant 7-nov-2026 16:50: "necesito ver claramente donde esta mi vaquero").
var _occluders: Dictionary = {}
var _marker: Node2D = null
var _dodge_button: Button = null
var _trail_node: Node2D = null
var _clop_b: AudioStream = load("res://art/audio/hoof_b.wav")

func _ready() -> void:
	y_sort_enabled = true
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
	_marker = DrawNode.new()
	_marker.draw_fn = _draw_rider_marker
	_marker.z_index = 60
	_marker.visible = false
	add_child(_marker)
	# dodge trail (estela de regate): drawn on the stationary world node, not on
	# the moving player, so every dot renders where the hoof stepped
	_trail_node = DrawNode.new()
	_trail_node.draw_fn = _draw_dodge_trail
	_trail_node.z_index = 60
	_trail_node.visible = false
	add_child(_trail_node)
	var camera := Camera2D.new()
	player.add_child(camera)
	camera.make_current()
	var ranch := RanchScript.new()
	add_child(ranch)
	register_occluder("ranch_house", Rect2(Vector2(-130, -262), Vector2(170, 142)))
	# fixed showcase zone near the ranch (Ant, 7-nov-2026): additive overlay,
	# no effect on chunk seeds, streaming or saves
	var test_zone := TestZoneScript.new()
	test_zone.name = "test_zone"
	add_child(test_zone)
	_build_hud()
	_lasso_double_tap = DoubleTapDetector.new(LassoAim.DOUBLE_TAP_WINDOW_SECONDS)
	_stamina = WorldStamina.new_state(HorseStats.read(SaveData.horse_collection.find(SaveData.horse_collection.selected)).get("power", 0.65))
	_hoof_player = AudioStreamPlayer.new()
	_hoof_player.volume_db = -12.0
	_hoof_player.bus = &"SFX" if AudioServer.get_bus_index("SFX") >= 0 else &"Master"
	player.add_child(_hoof_player)
	_update_chunks()

func _process(delta: float) -> void:
	_update_chunks()
	_tick_taming(delta)
	_tick_lasso(delta)
	_tick_rider_marker()
	if Input.is_action_just_pressed("world_dodge"):
		_try_dodge()
	_trail_node.visible = player._trail_fade > 0.0
	if _trail_node.visible:
		_trail_node.queue_redraw()
	if _gauges.has("dodge"):
		_gauges["dodge"].set_state(true, 1.0 - player.dodge_cooldown / maxf(0.01, player.dodge_recharge_seconds))
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

func _try_dodge() -> void:
	var wish: Vector2 = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var dir: Vector2 = wish
	if dir.length() < 0.2 and player.velocity.length() > 12.0:
		dir = player.velocity.normalized()
	player.request_dodge(dir)

func register_occluder(owner, rect: Rect2) -> void:
	if not _occluders.has(owner):
		_occluders[owner] = []
	_occluders[owner].append(rect)

func _tick_rider_marker() -> void:
	var hidden: bool = false
	for owner in _occluders:
		for r in _occluders[owner]:
			if (r as Rect2).has_point(player.position):
				hidden = true
				break
		if hidden:
			break
	_marker.visible = hidden
	if hidden:
		var bob: float = absf(sin(Time.get_ticks_msec() / 220.0)) * 8.0
		_marker.position = player.position + Vector2(0, -70 - bob)
		_marker.queue_redraw()

func _draw_dodge_trail(n: Node2D) -> void:
	var a: float = player._trail_fade / 0.7
	for p in player._skid_trail:
		n.draw_circle(p + Vector2(0, 6), 7.0, Color(0.98, 0.8, 0.42, 0.5 * a))
		n.draw_circle(p + Vector2(0, 6), 3.5, Color(1.0, 0.95, 0.78, 0.85 * a))

func _draw_rider_marker(n: Node2D) -> void:
	var tri := PackedVector2Array([Vector2(-11, -8), Vector2(11, -8), Vector2(0, 8)])
	n.draw_colored_polygon(tri, Color("201b1c"))
	n.draw_colored_polygon(PackedVector2Array([Vector2(-7, -6), Vector2(7, -6), Vector2(0, 5)]), Color("ffd23d"))

func _tick_lasso(delta: float) -> void:
	_lasso_cooldown = maxf(0.0, _lasso_cooldown - delta)
	if _lasso_state == "flight":
		_lasso_flight += delta
		_lasso.progress = clampf(_lasso_flight / LASSO_FLIGHT_TIME, 0.0, 1.0)
		if _lasso_flight >= LASSO_FLIGHT_TIME:
			_resolve_lasso()
	elif _lasso_state == "hold":
		if not is_instance_valid(_lasso_horse):
			_end_lasso()
		else:
			_lasso.landing = _lasso_horse.position
			if _lasso_horse.held <= 0.0:
				var st: Dictionary = _lasso_horse.state
				if st.has("flee"):
					st["flee"] = true
				else:
					st["spook"] = WorldTaming.SPOOK_SECONDS
				_lasso_horse.state = st
				_end_lasso()
		return
	if _lasso_charging:
		if _charge_keyboard:
			_charge_distance = minf(LASSO_MAX_THROW, _charge_distance + LASSO_CHARGE_SPEED * delta)
			if player.velocity.length() > 12.0:
				_aim_dir = player.velocity.normalized()
		else:
			var av: Vector2 = Input.get_vector("aim_left", "aim_right", "aim_up", "aim_down")
			if av.length() >= LassoAim.CANCEL_THRESHOLD:
				_aim_dir = av.normalized()
				_charge_distance = LassoAim.throw_distance(av, LASSO_MAX_THROW)
		_update_charge_visual()
		if _charge_keyboard and Input.is_action_just_released("throw_lasso"):
			_stop_charge()
			_throw_lasso(_aim_dir, _charge_distance)
	elif _lasso_state == "" and Input.is_action_just_pressed("throw_lasso"):
		_start_charge(true)

func _on_aim_pressed() -> void:
	_aim_pressed_at = Time.get_ticks_msec() / 1000.0
	if not _lasso_charging and _lasso_state == "":
		_start_charge(false)

func _on_aim_released(input_vector: Vector2) -> void:
	var now: float = Time.get_ticks_msec() / 1000.0
	if LassoAim.is_tap(input_vector, now - _aim_pressed_at):
		if _lasso_double_tap != null and _lasso_double_tap.register_tap(now):
			_release_held_horse()
	elif _lasso_double_tap != null:
		_lasso_double_tap.reset()
	if not _lasso_charging:
		return
	_stop_charge()
	if LassoAim.is_cancel(input_vector):
		return
	_throw_lasso(input_vector.normalized(), LassoAim.throw_distance(input_vector, LASSO_MAX_THROW))

func _start_charge(keyboard: bool) -> void:
	_lasso_charging = true
	_charge_keyboard = keyboard
	_charge_distance = 0.0
	_charge_visual = Line2D.new()
	_charge_visual.width = 3.0
	_charge_visual.default_color = Color(0.85, 0.65, 0.2, 1.0)
	player.add_child(_charge_visual)

func _stop_charge() -> void:
	_lasso_charging = false
	if is_instance_valid(_charge_visual):
		_charge_visual.queue_free()
	_charge_visual = null

func _update_charge_visual() -> void:
	if _charge_visual != null:
		_charge_visual.points = PackedVector2Array([Vector2.ZERO, _aim_dir * _charge_distance])

func _release_held_horse() -> void:
	if _lasso_state != "hold" or not is_instance_valid(_lasso_horse):
		return
	var st: Dictionary = _lasso_horse.state
	if st.has("flee"):
		st["flee"] = true
	else:
		st["spook"] = WorldTaming.SPOOK_SECONDS
	_lasso_horse.state = st
	_lasso_horse.held = 0.0
	_end_lasso()
	_lasso_cooldown = LASSO_COOLDOWN

func _throw_lasso(dir: Vector2, dist: float) -> void:
	if _lasso_state != "" or _lasso_cooldown > 0.0:
		return
	_lasso = LassoRope.new()
	_lasso.rider = player
	_lasso.start = player.position
	_lasso.landing = player.position + dir * dist
	_lasso.progress = 0.0
	add_child(_lasso)
	_lasso_state = "flight"
	_lasso_flight = 0.0

func _resolve_lasso() -> void:
	var best: Node2D = null
	var best_dist: float = _lasso.landing_radius
	for key in _herd_horses:
		var raw = _herd_horses[key]
		if not is_instance_valid(raw):
			continue
		var horse: Node2D = raw
		var d: float = _lasso.landing.distance_to(horse.position)
		if d < best_dist:
			best = horse
			best_dist = d
	for pig in _lasso_pigs():
		var dp: float = _lasso.landing.distance_to(pig.position)
		if dp < best_dist:
			best = pig
			best_dist = dp
	if best == null:
		_end_lasso()
		_lasso_cooldown = LASSO_COOLDOWN
		return
	_lasso_horse = best
	best.held = WorldTaming.HOLD_SECONDS
	_lasso_state = "hold"

func _lasso_pigs() -> Array:
	var out: Array = []
	for key in _chunks:
		var pen: Node2D = _chunks[key].get_node_or_null("pigs")
		if pen == null:
			continue
		for pig in pen.get_children():
			if pig.name != "bar" and is_instance_valid(pig):
				out.append(pig)
	return out

func _end_lasso() -> void:
	if is_instance_valid(_lasso):
		_lasso.queue_free()
	_lasso = null
	_lasso_horse = null
	_lasso_state = ""

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
			for e in _chunk_entities.get(key, []):
				if is_instance_valid(e):
					e.queue_free()
			_chunk_entities.erase(key)
			_herd_horses.erase(key)
		_occluders.erase(key)

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
	var entities: Array = []
	for d in chunk.get("decor", []):
		var decor := DecorScript.new()
		decor.kind = d["kind"]
		decor.size_scale = d["scale"]
		var boff: float = DecorScript.base_offset(d["kind"], d["scale"])
		decor.draw_offset = Vector2(0, -boff)
		decor.position = d["pos"] + Vector2(0, boff)
		add_child(decor)
		entities.append(decor)
		var occ: Rect2 = DecorScript.occluder_box(d["kind"], d["pos"], d["scale"])
		if occ.has_area():
			register_occluder(key, occ)
		var box: Rect2 = DecorScript.solid_box(d["kind"], d["pos"], d["scale"])
		if box.has_area():
			entities.append(Physics.add_box(self, box))
	var herd: Dictionary = chunk.get("herd", {})
	var mission_id: String = WorldMap.herd_mission_id(cx, cy)
	if not herd.is_empty() and not SaveData.world_tamed.has(mission_id):
		var horse := WildHorseScript.new()
		horse.name = "herd"
		horse.setup(herd)
		horse.set_meta("c", Vector2i(cx, cy))
		add_child(horse)
		entities.append(horse)
		_herd_horses[key] = horse
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
		var base: Vector2 = pigs["pos"]
		for i in int(pigs.get("count", 2)):
			var pig := PigScript.new()
			pig.name = "pig%d" % i
			pig.setup({"pos": base + Vector2(cos(i * TAU / maxf(1.0, float(pigs.get("count", 2)))), sin(i * TAU / maxf(1.0, float(pigs.get("count", 2))))) * 44.0})
			add_child(pig)
			entities.append(pig)
			entities.append(Physics.add_box(self, Rect2(pig.position + Vector2(-12, -6), Vector2(24, 12))))
			var pbar := ProgressBar.new()
			pbar.name = "bar"
			pbar.min_value = 0.0
			pbar.max_value = 1.0
			pbar.size = Vector2(48, 7)
			pbar.position = Vector2(-24, -44)
			pbar.show_percentage = false
			pbar.visible = false
			pig.add_child(pbar)
	add_child(node)
	_chunks[key] = node
	_chunk_entities[key] = entities
	if not SaveData.world_discovered.has(key):
		SaveData.mark_world_discovered(key)
		if not herd.is_empty() and not SaveData.world_tamed.has(mission_id) and not SaveData.world_missions.has(mission_id):
			SaveData.set_world_mission(mission_id, "offered")
			_toast(tr("WORLD_FOUND"))
			_refresh_missions()
			SaveData.save_world_state(player.position)

func _tick_taming(delta: float) -> void:
	for key in _herd_horses:
		var raw = _herd_horses[key]
		if not is_instance_valid(raw):
			continue
		var horse: Node2D = raw
		var dist: float = player.position.distance_to(horse.position)
		if dist > 700.0:
			continue
		var st: Dictionary
		if horse.held > 0.0:
			st = WorldTaming.hold_tick(horse.state, float(horse.herd.get("temperament", 0.5)), delta)
		else:
			st = WorldTaming.tick(horse.state, dist, player.velocity.length(), player.calm(), float(horse.herd.get("temperament", 0.5)), delta)
		horse.state = st
		var bar: ProgressBar = horse.get_node("bar")
		bar.value = st.get("progress", 0.0)
		bar.visible = bar.value > 0.01
		if WorldTaming.tamed(st):
			_on_tamed(horse.get_meta("c"), horse)
		elif horse.held <= 0.0 and WorldTaming.should_flee(st, dist):
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
			var st: Dictionary
			if pig.get("held") != null and pig.held > 0.0:
				st = WorldPigs.hold_tick(pig.state, delta)
			else:
				st = WorldPigs.tick(pig.state, dist, player.velocity.length(), delta)
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
	# the native joystick eats touches in its zone; in edit mode taps place
	# decor, so park the touch controls until the palette closes
	var touch: Node = get_node_or_null("TouchControls")
	if touch != null:
		touch.visible = not _edit_mode
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
	if _map_overlay.visible and event.is_action_pressed("ui_cancel"):
		_toggle_map()
		get_viewport().set_input_as_handled()
		return
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
	_dodge_button = Button.new()
	_dodge_button.text = tr("WORLD_DODGE")
	_dodge_button.position = Vector2(1090, 540)
	_dodge_button.size = Vector2(170, 54)
	_dodge_button.pressed.connect(_try_dodge)
	_hud.add_child(_dodge_button)
	_map_overlay = DiscoveryMap.new()
	_map_overlay.world = self
	_map_overlay.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	_map_overlay.visible = false
	_hud.add_child(_map_overlay)
	var touch := CanvasLayer.new()
	touch.name = "TouchControls"
	touch.layer = 0
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
	var aim_joy := VirtualJoystick.new()
	aim_joy.name = "AimJoystick"
	aim_joy.anchor_left = 0.5
	aim_joy.anchor_right = 1.0
	aim_joy.anchor_bottom = 1.0
	aim_joy.joystick_mode = 2
	aim_joy.visibility_mode = 1
	aim_joy.joystick_size = 220.0
	aim_joy.tip_size = 80.0
	aim_joy.action_left = &"aim_left"
	aim_joy.action_right = &"aim_right"
	aim_joy.action_up = &"aim_up"
	aim_joy.action_down = &"aim_down"
	aim_joy.pressed.connect(_on_aim_pressed)
	aim_joy.released.connect(_on_aim_released)
	touch.add_child(aim_joy)

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
	var _pulse: float = 0.0

	func _process(delta: float) -> void:
		if visible:
			_pulse += delta
			queue_redraw()

	func _ready() -> void:
		mouse_filter = Control.MOUSE_FILTER_STOP
		# clear close affordances (Ant 7-nov-2026: "no lo puedo cerrar"):
		# X button, tap without drag, or Android back (ui_cancel in the world)
		var close := Button.new()
		close.text = "X"
		close.set_anchors_preset(Control.PRESET_TOP_RIGHT)
		close.offset_left = -90
		close.offset_top = 16
		close.offset_right = -16
		close.offset_bottom = 88
		close.add_theme_font_size_override("font_size", 40)
		close.pressed.connect(world._toggle_map)
		add_child(close)
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
			if event.pressed:
				_dragging = true
				_drag_from = event.position
				_pan_from = pan
			else:
				if _dragging and (event.position - _drag_from).length() < 12.0:
					world._toggle_map()
				_dragging = false
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
		# player marker (Ant 7-nov-2026: "ver claramente donde esta mi vaquero"):
		# pulsing ring, high-contrast dot and facing arrow
		var ppos: Vector2 = _to_map(world.player.position, mins, cell, origin)
		var ring: float = cell * (0.20 + 0.06 * sin(_pulse * 4.0))
		draw_arc(ppos, ring, 0, TAU, 40, Color("ffd23d"), 3.0, true)
		draw_circle(ppos, cell * 0.16, Color("201b1c"))
		draw_circle(ppos, cell * 0.12, Color("f8edce"))
		draw_circle(ppos, cell * 0.05, Color("d94f3d"))
		var face: Vector2 = world.player.velocity
		if face.length() < 12.0:
			face = Vector2.DOWN
		face = face.normalized()
		var tip: Vector2 = ppos + face * cell * 0.34
		var side: Vector2 = Vector2(-face.y, face.x) * cell * 0.10
		draw_colored_polygon(PackedVector2Array([tip, ppos + face * cell * 0.12 + side, ppos + face * cell * 0.12 - side]), Color("ffd23d"))

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
