extends Node2D

## Level contract wiring only (GAMEPLAY_SPEC.md #Level contract) — no gameplay rules live here.
## Level content (bull count, obstacle layout) comes from LevelCatalog.get_level(level_number),
## keyed by GameState.selected_level. Obstacles are spawned at runtime as StaticBody2D
## nodes on the same collision layer as the perimeter fence — no per-level scene needed.
##
## Obstacles block movement (Player + Bull physics collision, reused fence layer) but NOT the
## lasso: the throw lands on a point and captures what is there, even with an obstacle in
## between (D038, supersedes the line-of-sight rule of D012).
##
## Persistent unlocks (tranquilizer, speed, dual capture...) are defined in PlayerUpgrades.
## The "tag" chaser rule lives in ChaserDirector; this node only wires them to the scene.

const CHASER_ENGAGE_DELAY_SECONDS: float = 1.0

@export var world_bounds: Rect2 = Rect2(-480, -270, 960, 540)

@onready var player: CharacterBody2D = $Player
@onready var all_bulls: Array = [$Bull, $Bull2, $Bull3, $Bull4, $Bull5, $Bull6, $Bull7, $Bull8, $Bull9, $Bull10]
@onready var pen: Area2D = $Pen
@onready var hud: CanvasLayer = $HUD
@onready var touch_controls: CanvasLayer = $TouchControls
@onready var aim_joystick: VirtualJoystick = $TouchControls/AimJoystick

var _active_bulls: Array = []
var _bulls_returned: int = 0
var _time_remaining: float = 0.0
var _game_over: bool = false
var _tranquilizer_available: bool = false
var _level_number: int = 1
var _max_simultaneous_captures: int = 1
var _obstacle_rects: Array = []
var _win_requires_all_bulls: bool = true
var _chaser_director: ChaserDirector = ChaserDirector.new(CHASER_ENGAGE_DELAY_SECONDS)
var _chaser_index: int = ChaserDirector.NO_CHASER
var _next_capture_order: int = 1
var _upgrades: PlayerUpgrades
var _paused_by_user_or_os: bool = false
var _pens_data: Array = []  # LevelData.pens for this level
var _pen_doors: Array = []  # PenDoor per pen index; entries may be freed instances once opened, hence untyped
var _pen_released: Array = []  # bool per pen index — a pen's bulls are released at most once

func _ready() -> void:
	var level_data: LevelData = LevelCatalog.get_level(GameState.selected_level)
	_upgrades = PlayerUpgrades.for_progress(SaveData.highest_level_completed)
	_apply_unlocked_upgrades()
	_level_number = level_data.level_number
	_time_remaining = level_data.time_limit_seconds
	_obstacle_rects = level_data.obstacle_rects
	_win_requires_all_bulls = level_data.win_requires_all_bulls
	_spawn_obstacles(_obstacle_rects)

	var bull_count: int = clampi(level_data.bull_count, 1, all_bulls.size())
	_active_bulls = all_bulls.slice(0, bull_count)
	for i in range(all_bulls.size()):
		if i >= bull_count:
			all_bulls[i].deactivate()

	player.world_bounds = world_bounds
	player.set_aim_joystick(aim_joystick)
	var pen_zone_rect: Rect2 = Rect2(pen.global_position - Vector2(40, 40), Vector2(80, 80))
	for bull in _active_bulls:
		bull.world_bounds = world_bounds
		bull.obstacles = _obstacle_rects
		bull.pen_rect = pen_zone_rect
		bull.set_player(player)
		bull.set_peers(_active_bulls)
		bull.chase_probability = level_data.chase_probability
		bull.chaser_blocked.connect(_on_chaser_blocked)

	_activate_bulls(level_data.pens)

	player.lasso_thrown.connect(_on_lasso_thrown)
	player.release_requested.connect(_on_release_requested)
	pen.bull_returned.connect(_on_bull_returned)

	hud.update_bull_count(_bulls_returned, _active_bulls.size())
	hud.update_timer(_time_remaining)
	hud.hide_nerves_slot(0)
	hud.hide_nerves_slot(1)
	hud.restart_requested.connect(_on_restart_requested)
	hud.resume_requested.connect(resume_game)
	hud.quit_requested.connect(_on_quit_requested)
	hud.tranquilizer_requested.connect(_on_tranquilizer_requested)

	_tranquilizer_available = _upgrades.tranquilizer_available
	hud.set_tranquilizer_available(_tranquilizer_available)

## Spawns each obstacle as a StaticBody2D on the fence's collision layer (4) — reuses the
## exact same "solid to Player/Bull, invisible to Pen detection" setup, no new layer needed.
func _spawn_obstacles(rects: Array) -> void:
	for rect: Rect2 in rects:
		var obstacle := StaticBody2D.new()
		obstacle.collision_layer = CollisionLayers.FENCE
		obstacle.collision_mask = 0
		obstacle.position = rect.position + rect.size / 2.0

		var collision_shape := CollisionShape2D.new()
		var rect_shape := RectangleShape2D.new()
		rect_shape.size = rect.size
		collision_shape.shape = rect_shape
		obstacle.add_child(collision_shape)

		var visual := Polygon2D.new()
		var half: Vector2 = rect.size / 2.0
		visual.polygon = PackedVector2Array([
			Vector2(-half.x, -half.y), Vector2(half.x, -half.y),
			Vector2(half.x, half.y), Vector2(-half.x, half.y)
		])
		visual.color = Color(0.35, 0.28, 0.22, 1.0)  # placeholder "rock/crate" color, distinct from the fence
		obstacle.add_child(visual)

		add_child(obstacle)

## Pen-puzzle mode (GAMEPLAY_SPEC.md, levels 11+). Every bull not referenced by any pen
## starts active immediately, exactly as before pens existed — so levels 1-10 (pens == [])
## are untouched. A bull referenced by a pen stays SAFE/inert until that pen's door opens.
func _activate_bulls(pens: Array) -> void:
	var penned_indices: Dictionary = {}  # used as a Set — value unused
	for pen_entry: Dictionary in pens:
		for index: int in pen_entry.get("bull_indices", []):
			penned_indices[index] = true

	for i in range(_active_bulls.size()):
		if not penned_indices.has(i):
			_active_bulls[i].begin_active()

	_spawn_pens(pens)

func _spawn_pens(pens: Array) -> void:
	_pens_data = pens
	_pen_doors.clear()
	_pen_released.clear()

	for pen_index in range(pens.size()):
		var pen_entry: Dictionary = pens[pen_index]
		var door := PenDoor.new()
		door.position = pen_entry.get("door_position", Vector2.ZERO)
		door.hold_seconds = pen_entry.get("door_hold_seconds", LevelCatalog.DEFAULT_DOOR_HOLD_SECONDS)
		door.set_player(player)
		door.opened.connect(_on_pen_door_opened.bind(pen_index))
		add_child(door)
		_pen_doors.append(door)
		_pen_released.append(false)

	if _any_pen_has_links(pens):
		var overlay := PenLinkOverlay.new()
		overlay.setup(pens, _pen_doors)
		add_child(overlay)

func _any_pen_has_links(pens: Array) -> bool:
	for pen_index in range(pens.size()):
		if not PenLinkResolver.get_linked_pen_indices(pens, pen_index).is_empty():
			return true
	return false

## The player opened door pen_index: release its own pen plus every pen its links open
## (PenLinkResolver — master opens all, chain opens specific pens, normal only itself).
## Each pen releases at most once, so a door already opened earlier is skipped.
func _on_pen_door_opened(pen_index: int) -> void:
	for released_index: int in PenLinkResolver.get_released_pen_indices(_pens_data, pen_index):
		if _pen_released[released_index]:
			continue
		_pen_released[released_index] = true
		_release_pen_bulls(released_index)

		if released_index != pen_index:
			var linked_door = _pen_doors[released_index]
			if is_instance_valid(linked_door):
				linked_door.force_open()

func _release_pen_bulls(pen_index: int) -> void:
	var bull_indices: Array = _pens_data[pen_index].get("bull_indices", [])
	for index: int in bull_indices:
		if index >= 0 and index < _active_bulls.size():
			_active_bulls[index].begin_active()

## Applies persistent unlocks once at level start — these are player stats, not
## continuously-recalculated level rules. Schedule/numbers: PlayerUpgrades.
func _apply_unlocked_upgrades() -> void:
	player.max_speed *= _upgrades.speed_multiplier
	player.stun_resistance_multiplier *= _upgrades.stun_duration_multiplier
	player.lasso_travel_time *= _upgrades.lasso_travel_time_multiplier
	player.max_throw_distance *= _upgrades.throw_distance_multiplier
	_max_simultaneous_captures = _upgrades.max_simultaneous_captures

func _process(delta: float) -> void:
	if _game_over:
		return

	_time_remaining -= delta
	hud.update_timer(_time_remaining)
	_update_nerves_hud()
	_update_chaser(delta)

	if _time_remaining <= 0.0:
		_trigger_lose("¡Se acabó el tiempo!")

func _held_bulls() -> Array:
	var held: Array = []
	for bull in _active_bulls:
		if bull.controller.is_held():
			held.append(bull)
	return held

## "Tag" mechanic (rules: ChaserDirector). capture_held is propagated to every active bull
## each frame: the secondary random-chase roll (RandomChaseRoller) is gated on it too.
func _update_chaser(delta: float) -> void:
	var holding_something: bool = not _held_bulls().is_empty()
	for bull in _active_bulls:
		bull.capture_held = holding_something
	_apply_chaser(_chaser_director.update(delta, holding_something, _wild_distances()))

## {bull index -> distance to player} for every bull that is currently wild.
func _wild_distances() -> Dictionary:
	var wild_distances: Dictionary = {}
	for i in range(_active_bulls.size()):
		var bull = _active_bulls[i]
		if bull.controller.is_wild():
			wild_distances[i] = bull.global_position.distance_to(player.global_position)
	return wild_distances

func _apply_chaser(new_chaser: int) -> void:
	if new_chaser == _chaser_index:
		return
	if _chaser_index != ChaserDirector.NO_CHASER:
		_active_bulls[_chaser_index].set_is_chaser(false)
	if new_chaser != ChaserDirector.NO_CHASER:
		_active_bulls[new_chaser].set_is_chaser(true)
	_chaser_index = new_chaser

## The designated chaser could not advance (stuck behind an obstacle/bull): pass the baton to a
## random other wild bull (D036). Ignores stale reports from a bull that is no longer the chaser.
func _on_chaser_blocked(bull: Node2D) -> void:
	if _chaser_index == ChaserDirector.NO_CHASER or _active_bulls[_chaser_index] != bull:
		return
	_apply_chaser(_chaser_director.hand_over_randomly(_wild_distances()))

func _update_nerves_hud() -> void:
	var held: Array = _held_bulls()
	player.set_active_capture_count(held.size())

	var calming_bulls: Array = []
	for bull in held:
		var state: BullState.State = bull.controller.current_state()
		if state == BullState.State.CAPTURED or state == BullState.State.CALMING:
			calming_bulls.append(bull)

	if calming_bulls.size() >= 1:
		hud.update_nerves_slot(0, calming_bulls[0].controller.current_nerves())
	else:
		hud.hide_nerves_slot(0)

	if calming_bulls.size() >= 2:
		hud.update_nerves_slot(1, calming_bulls[1].controller.current_nerves())
	else:
		hud.hide_nerves_slot(1)

func _on_lasso_thrown(throw_origin: Vector2, landing_point: Vector2) -> void:
	if _game_over or _held_bulls().size() >= _max_simultaneous_captures:
		return  # lasso limit reached — can't start another capture right now

	# Nearest-to-landing-point first: with the charge/release mechanic the landing point
	# itself already encodes aim + distance, so distance-to-landing is what should decide
	# which bull (if any) got hit.
	var candidates: Array = _active_bulls.duplicate()
	candidates.sort_custom(func(a, b): return landing_point.distance_to(a.global_position) < landing_point.distance_to(b.global_position))
	for bull in candidates:
		if bull.try_capture(landing_point):
			bull.capture_order = _next_capture_order
			_next_capture_order += 1
			return
		if OS.is_debug_build():
			# DIAGNOSTIC (reinstated — capture precision still reported as inconsistent):
			# only logs misses, to keep noise down. Remove once confirmed resolved.
			print("Lasso MISSED %s: landing=%s bull_pos=%s dist=%.1f effective_radius=%.1f" % [
				bull.name, landing_point, bull.global_position,
				landing_point.distance_to(bull.global_position),
				bull.hit_radius + bull.capture_tolerance
			])

## Double tap on the aim stick drops the most recently captured bull (D038). One bull per
## gesture, so with dual capture the player keeps control of which one stays.
func _on_release_requested() -> void:
	if _game_over:
		return
	var latest: Node2D = null
	for bull in _held_bulls():
		if latest == null or bull.capture_order > latest.capture_order:
			latest = bull
	if latest != null:
		latest.release_by_player()

func _on_tranquilizer_requested() -> void:
	if not _tranquilizer_available or _game_over:
		return
	var used: bool = false
	for bull in _active_bulls:
		var state: BullState.State = bull.controller.current_state()
		if state == BullState.State.CAPTURED or state == BullState.State.CALMING:
			if bull.controller.use_tranquilizer():
				used = true
	if used:
		_tranquilizer_available = false
		hud.set_tranquilizer_available(false)

func _on_bull_returned(returned_bull: Node2D) -> void:
	_bulls_returned += 1
	hud.update_bull_count(_bulls_returned, _active_bulls.size())
	if _win_requires_all_bulls and _bulls_returned >= _active_bulls.size():
		_trigger_win()

func _trigger_win() -> void:
	_game_over = true
	_freeze_gameplay()
	SaveData.record_level_completed(_level_number)
	hud.show_win()

func _trigger_lose(reason: String) -> void:
	_game_over = true
	_freeze_gameplay()
	hud.show_lose(reason)

func _freeze_gameplay() -> void:
	player.set_physics_process(false)
	for bull in _active_bulls:
		bull.set_physics_process(false)
	touch_controls.visible = false  # stop joysticks from eating touches meant for the end-game buttons

func _on_restart_requested() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()

## Android lifecycle (ANDROID_REQUIREMENTS.md): going to background / losing focus pauses the
## game (otherwise the countdown would jump on resume); the back button toggles the pause
## menu. WM_GO_BACK_REQUEST is only delivered because project.godot sets quit_on_go_back=false.
func _notification(what: int) -> void:
	match what:
		NOTIFICATION_APPLICATION_PAUSED, NOTIFICATION_WM_WINDOW_FOCUS_OUT:
			pause_game()
		NOTIFICATION_WM_GO_BACK_REQUEST:
			if _paused_by_user_or_os:
				resume_game()
			else:
				pause_game()

func pause_game() -> void:
	if _game_over or _paused_by_user_or_os:
		return
	_paused_by_user_or_os = true
	get_tree().paused = true
	hud.show_pause()

func resume_game() -> void:
	if not _paused_by_user_or_os:
		return
	_paused_by_user_or_os = false
	get_tree().paused = false
	hud.hide_pause()

func _on_quit_requested() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://src/Presentation/main_menu.tscn")
