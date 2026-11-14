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
var _no_lasso_room_hint_shown189:bool=false
var _tranquilizer_available: bool = false
var _level_number: int = 1
var _max_simultaneous_captures: int = 1
var _obstacle_rects: Array = []
var _mounted_horse_id:String=""
var _training_session:Dictionary={}
var _training_before:Dictionary={}
var _training_status:Label
var _training_companion:Node2D
var _win_requires_all_bulls: bool = true
var _chaser_director: ChaserDirector = ChaserDirector.new(CHASER_ENGAGE_DELAY_SECONDS)
var _chaser_index: int = ChaserDirector.NO_CHASER
var _next_capture_order: int = 1
var _arena_scale:float=1.0
var _edge_indicators:EdgeIndicators
var _upgrades: PlayerUpgrades
var _paused_by_user_or_os: bool = false
var _intro_overlay_active: bool = false  # one-shot dual-lasso celebration: tree paused, HUD interactive
var _audio: RanchAudio
var _puzzle_corrals: Array = []
var _distraction_stations: Array = []
var _pens_data: Array = []  # LevelData.pens for this level
var _pen_doors: Array = []  # PenDoor per pen index; entries may be freed instances once opened, hence untyped
var _courier_jobs: Dictionary = {}
var _link_overlay: PenLinkOverlay
var _pen_released: Array = []  # bool per pen index — a pen's bulls are released at most once

func _ready() -> void:
	JoystickAppearance.apply(self)
	RanchMusic.set_paused(false)
	RanchMusic.set_enabled(GameState.sound_enabled)
	RanchMusic.play_context("gameplay")
	_audio = RanchAudio.new()
	add_child(_audio)
	_audio.enabled = GameState.sound_enabled
	var level_data: LevelData = LevelCatalog.get_level(GameState.selected_level)
	_upgrades = PlayerUpgrades.for_progress(SaveData.effective_progress())
	_apply_unlocked_upgrades()
	if SaveData.trial_session_active:
		var banner:=Label.new();banner.text=tr("ENSAYO AISLADO · sin premios ni guardado · equipo prestado");banner.position=Vector2(25,85);banner.add_theme_font_size_override("font_size",18);ToastStack.backdrop(banner);hud.add_child(banner);hud._toasts.set_top(156.)
	_level_number = level_data.level_number
	_arena_scale=ArenaLayout.scale_for_level(_level_number)
	world_bounds=ArenaLayout.bounds_for_level(_level_number)
	if _arena_scale>1.0:_expand_arena()
	_time_remaining = level_data.time_limit_seconds
	_obstacle_rects = level_data.obstacle_rects if level_data.pens.is_empty() or _level_number>=21 else []
	_win_requires_all_bulls = level_data.win_requires_all_bulls
	_spawn_obstacles(_obstacle_rects)
	_setup_art()
	_spawn_jump_fences()
	_spawn_distraction_stations()

	var bull_count: int = clampi(level_data.bull_count, 1, all_bulls.size())
	_active_bulls = all_bulls.slice(0, bull_count)
	for i in range(all_bulls.size()):
		if i >= bull_count:
			all_bulls[i].deactivate()

	player.world_bounds = world_bounds
	player.set_aim_joystick(aim_joystick)
	player.set_move_joystick($TouchControls/MoveJoystick)
	player.dodge_drawing_started.connect(func(): _audio.play("bullet_in"))
	player.dodge_drawing_finished.connect(func(): _audio.play("bullet_out"))
	player.dodge_started.connect(func(): _audio.play("dodge"))
	player.dodge_finished.connect(func(): _audio.play("skid"))
	var pen_zone_rect: Rect2 = Rect2(pen.global_position - Vector2(40, 40), Vector2(80, 80))
	for bull in _active_bulls:
		bull.world_bounds = world_bounds
		bull.obstacles = _obstacle_rects
		bull.pen_rect = pen_zone_rect
		bull.set_distraction_stations(_distraction_stations)
		bull.set_player(player)
		bull.set_peers(_active_bulls)
		bull.chase_probability = level_data.chase_probability
		bull.chaser_blocked.connect(_on_chaser_blocked)
		bull.controller.state_changed.connect(_on_bull_audio_state)

	_activate_bulls(level_data.pens)

	player.lasso.prey_provider = func() -> Array: return _active_bulls
	player.lasso.can_capture = func() -> bool: return not _game_over and _held_bulls().size() < _max_simultaneous_captures
	player.prey_captured.connect(_on_prey_captured)
	player.release_requested.connect(_on_release_requested)
	player.throw_blocked.connect(_on_throw_blocked)
	pen.bull_returned.connect(_on_bull_returned)

	hud.update_bull_count(_bulls_returned, _active_bulls.size())
	hud.update_timer(_time_remaining)
	hud.set_level(_level_number)
	if GameState.debug_cheats_active():hud.flash_hint(tr("DEBUG_GAMEPLAY") if SaveData.debug_mode else tr("ENSAYO: regate y doble lazo activos, sin alterar progreso"),5.0)
	hud.hide_nerves_slot(0)
	hud.hide_nerves_slot(1)
	hud.restart_requested.connect(_on_restart_requested)
	# clock-fill ability gauges (Ant 11:40): indicators only, no balance change
	for spec in [["dodge", player.dodge_available], ["jump", player.can_jump]]:
		var g := RadialGauge.new()
		g.skill = spec[0]
		g.position = Vector2(1130 if spec[0] == "dodge" else 1214, 636)
		g.size = Vector2(76, 76)
		g.set_state(spec[1], 1.0)
		hud.add_child(g)
		_level_gauges[spec[0]] = g
	hud.next_requested.connect(_on_next_requested)
	hud.sound_toggled.connect(_on_sound_toggled)
	player.lasso_released.connect(func(): _audio.play("throw"))
	player.stunned.connect(func(): _audio.play("stun"))
	hud.resume_requested.connect(resume_game)
	hud.pause_requested.connect(pause_game)
	hud.pause_toggle_requested.connect(_toggle_pause)
	hud.quit_requested.connect(_on_quit_requested)
	hud.tranquilizer_requested.connect(_on_tranquilizer_requested)

	_tranquilizer_available = _upgrades.tranquilizer_available
	hud.set_tranquilizer_available(_tranquilizer_available)

	# First level played with the dual lasso unlocked: celebrate and explain it once,
	# before the action starts (Ant, 4-nov).
	if _upgrades.max_simultaneous_captures >= 2 and not SaveData.dual_lasso_intro_shown:
		_show_dual_lasso_intro()

## Spawns each obstacle as a StaticBody2D on the fence's collision layer (4) — reuses the
## exact same "solid to Player/Bull, invisible to Pen detection" setup, no new layer needed.
func _setup_art() -> void:
	var art := ArenaArt.new()
	art.world_bounds=world_bounds
	art.obstacle_rects = _obstacle_rects
	art.pen_position = pen.position
	add_child(art)
	for fence_name: String in ["FenceTop", "FenceBottom", "FenceLeft", "FenceRight", "Pen"]:
		get_node(fence_name + "/Polygon2D").hide()
	get_viewport().size_changed.connect(_fit_camera)
	_fit_camera()
	if _arena_scale>1.0:
		var layer:=CanvasLayer.new()
		layer.layer=5
		add_child(layer)
		_edge_indicators=EdgeIndicators.new()
		_edge_indicators.level=self
		layer.add_child(_edge_indicators)
		var map_layer:=CanvasLayer.new()
		map_layer.layer=15
		add_child(map_layer)
		var minimap:=ArenaMinimap.new()
		minimap.level=self
		map_layer.add_child(minimap)

func _fit_camera() -> void:
	var size: Vector2 = get_viewport_rect().size
	var factor: float = minf((size.x - 48.0) / 1046.0, (size.y - 136.0) / 626.0)
	$Camera2D.zoom = Vector2.ONE * maxf(factor, 0.1)
	$Camera2D.offset = Vector2(0, -24.0 / maxf(factor, 0.1))

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
		visual.visible = false
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
	_pens_data = pens.duplicate(true)
	for index in range(_pens_data.size()):
		var entry: Dictionary = _pens_data[index]
		var layout: Dictionary = ArenaLayout.spread_corral(PuzzleCorralLayout.build(_pens_data.size(), index, entry["bull_indices"].size(),entry.get("layout_mirror_x",false)),_arena_scale)
		entry["door_position"] = layout["door"]
		var corral := PuzzleCorral.new()
		corral.layout = layout
		corral.number = index + 1
		add_child(corral)
		_puzzle_corrals.append(corral)
		for slot in range(entry["bull_indices"].size()):
			_active_bulls[entry["bull_indices"][slot]].global_position = layout["slots"][slot]
	pens = _pens_data
	_pen_doors.clear()
	_pen_released.clear()

	for pen_index in range(pens.size()):
		var pen_entry: Dictionary = pens[pen_index]
		var door := PenDoor.new()
		door.door_number = pen_index + 1
		door.is_master = pen_entry.get("is_master", false)
		door.linked_count = PenLinkResolver.get_linked_pen_indices(pens, pen_index).size()
		for bull_index: int in pen_entry.get("bull_indices", []):
			_active_bulls[bull_index].pen_number = pen_index + 1
		door.position = pen_entry.get("door_position", Vector2.ZERO)
		door.hold_seconds = pen_entry.get("door_hold_seconds", LevelCatalog.DEFAULT_DOOR_HOLD_SECONDS)
		door.set_player(player)
		door.opened.connect(_on_pen_door_opened.bind(pen_index))
		add_child(door)
		_pen_doors.append(door)
		_pen_released.append(false)

	if _any_pen_has_links(pens):
		var overlay := PenLinkOverlay.new()
		_link_overlay = overlay
		overlay.focus_player = player
		overlay.layouts = _puzzle_corrals.map(func(c): return c.layout)
		overlay.setup(pens, _pen_doors)
		add_child(overlay)

func _any_pen_has_links(pens: Array) -> bool:
	for pen_index in range(pens.size()):
		if not PenLinkResolver.get_linked_pen_indices(pens, pen_index).is_empty():
			return true
	return false

## Open this corral now. Its courier physically visits the configured linked latches.
## Capture pauses the errand; release resumes it. Manual doors remain available.
## Arrival never recursively launches a destination corral's own links.
func _on_pen_door_opened(pen_index: int) -> void:
	_audio.play("door")
	_release_one_pen(pen_index)
	var targets: Array = PenLinkResolver.get_linked_pen_indices(_pens_data,pen_index).filter(func(i): return not _pen_released[i])
	if targets.is_empty(): return
	var indices: Array = _pens_data[pen_index]["bull_indices"]
	var bull: Node = _active_bulls[indices[0]]
	_courier_jobs[bull] = {"from":pen_index,"targets":targets}
	if not bull.courier_arrived.is_connected(_on_courier_arrived):
		bull.courier_arrived.connect(_on_courier_arrived)
	if not bull.courier_interrupted.is_connected(_on_courier_interrupted):
		bull.courier_interrupted.connect(_on_courier_interrupted)
	_send_courier(bull)

func _on_courier_interrupted(_bull: Node) -> void:
	# The designated opener keeps its pending destination while held.
	_refresh_trail()

func _release_one_pen(index: int) -> void:
	if _pen_released[index]: return
	_pen_released[index] = true
	_puzzle_corrals[index].open_gate()
	_release_pen_bulls(index)
	var door = _pen_doors[index]
	if is_instance_valid(door): door.force_open()

func _send_courier(bull: Node) -> void:
	var job: Dictionary = _courier_jobs[bull]
	while not job["targets"].is_empty() and _pen_released[job["targets"][0]]:
		job["targets"].pop_front()
	if job["targets"].is_empty():
		_courier_jobs.erase(bull)
		_refresh_trail()
		return
	var route: PackedVector2Array = CorralRoute.build(_puzzle_corrals[job["from"]].layout,_puzzle_corrals[job["targets"][0]].layout)
	var source_layout: Dictionary = _puzzle_corrals[job["from"]].layout
	if bull.global_position.distance_to(source_layout["door"]) < 12:
		route.remove_at(0)
	elif source_layout["rect"].has_point(bull.global_position):
		route.insert(0,Vector2(source_layout["gate"].x,bull.global_position.y))
	bull.follow_corral_track(route)
	_refresh_trail()

## Resume from the bull's actual position, not its old source corral.
func _resume_courier(bull: Node) -> void:
	var job:Dictionary=_courier_jobs[bull]
	while not job["targets"].is_empty() and _pen_released[job["targets"][0]]:job["targets"].pop_front()
	if job["targets"].is_empty():return
	var destination:Vector2=_puzzle_corrals[job["targets"][0]].layout["door"]
	var route:PackedVector2Array=bull._courier_detour(destination,PenDoor.RADIUS)
	if route.is_empty():return # still blocked: retry rather than teleport or forget task
	route.append(destination)
	bull.follow_corral_track(route)
	_refresh_trail()

func _on_courier_arrived(bull: Node) -> void:
	if not _courier_jobs.has(bull): return
	var job: Dictionary = _courier_jobs[bull]
	var target: int = job["targets"].pop_front()
	_release_one_pen(target)
	_audio.play("door")
	job["from"] = target
	_send_courier(bull)

func _release_pen_bulls(pen_index: int) -> void:
	var bull_indices: Array = _pens_data[pen_index].get("bull_indices", []).duplicate()
	var exit_x: float = _puzzle_corrals[pen_index].layout["gate"].x
	bull_indices.sort_custom(func(a, b): return absf(_active_bulls[a].global_position.x - exit_x) < absf(_active_bulls[b].global_position.x - exit_x))
	var exit_order: int = 0
	for index: int in bull_indices:
		if index >= 0 and index < _active_bulls.size():
			var layout: Dictionary = _puzzle_corrals[pen_index].layout
			_active_bulls[index].guide_out_of_corral(layout["gate"], layout["inward"], 0.75 + exit_order * 1.25)
			exit_order += 1
			_active_bulls[index].begin_active()

## Applies persistent unlocks once at level start — these are player stats, not
## continuously-recalculated level rules. Schedule/numbers: PlayerUpgrades.
func _apply_unlocked_upgrades() -> void:
	var reach:float=SaveData.equipped_whip_reach()
	if GameState.debug_cheats_active():reach=maxf(reach,260.0)
	var trained_horse:Dictionary=SaveData.horse_collection.find(SaveData.horse_collection.selected)
	player.dodge_available=reach>0 and HorseTraining.knows(trained_horse,"dodge")
	player.dodge_recharge_seconds=2.5*HorseTraining.recovery(trained_horse,"dodge")
	player.jump_recovery_multiplier=HorseTraining.recovery(trained_horse,"jump")
	_mounted_horse_id=SaveData.horse_collection.selected
	_training_session=HorseTraining.session(SaveData.horse_collection)
	_training_before=TrainingReport.snapshot(SaveData.horse_collection,_training_session)
	if not _training_session.is_empty():_show_training_companion()
	player.dodge_path_limit=reach if reach>0 else 260.0
	var horse_stats:Dictionary=HorseStats.read(SaveData.horse_collection.find(SaveData.horse_collection.selected))
	player.max_speed=horse_stats.speed
	player.acceleration=horse_stats.handling
	player.dual_capture_speed_multiplier=horse_stats.power
	if reach>0:player.dodge_path_limit=reach*horse_stats.dodge
	player.max_speed *= _upgrades.speed_multiplier
	player.stun_resistance_multiplier *= _upgrades.stun_duration_multiplier
	player.max_throw_distance *= _upgrades.throw_distance_multiplier
	_max_simultaneous_captures = maxi(2,_upgrades.max_simultaneous_captures) if GameState.debug_cheats_active() else _upgrades.max_simultaneous_captures
	player.set_max_captures(_max_simultaneous_captures)

var _level_gauges: Dictionary = {}

func _process(delta: float) -> void:
	_update_training_status()
	if not _level_gauges.is_empty():
		_level_gauges["dodge"].set_state(player.dodge_available, 1.0 - player._dodge_cooldown / maxf(0.01, player.dodge_recharge_seconds) if player.dodge_available else 0.0)
		_level_gauges["jump"].set_state(player.can_jump, 1.0 - player._jump_cooldown / maxf(0.01, 1.2 * player.jump_recovery_multiplier) if player.can_jump else 0.0)
	if _arena_scale>1.0:_update_follow_camera()
	if _game_over:
		return

	# Manually opened destinations retire obsolete errands immediately.
	for bull in _courier_jobs.keys():
		var job: Dictionary = _courier_jobs[bull]
		job["retry"]=maxf(0.0,float(job.get("retry",0.0))-delta)
		if job["targets"].all(func(i): return _pen_released[i]):
			bull._courier_active = false
			bull._courier_path.clear()
			_courier_jobs.erase(bull)
			_refresh_trail()
		elif bull.controller.is_wild() and not bull._courier_active and job["retry"]<=0:
			_resume_courier(bull)
			job["retry"]=.35
	_time_remaining -= delta
	hud.update_timer(_time_remaining)
	_update_nerves_hud()
	_update_chaser(delta)

	if _time_remaining <= 0.0:
		_trigger_lose(tr("¡Se acabó el tiempo!"))

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

## Only free, exited wild bulls may chase. A courier never consumes the chaser role.
func _wild_distances() -> Dictionary:
	var wild_distances: Dictionary = {}
	for i in range(_active_bulls.size()):
		var bull = _active_bulls[i]
		if bull.controller.is_wild() and not _courier_jobs.has(bull) and not bull._leaving_corral:
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

	var ready_count: int = 0
	for bull in held:
		if bull.controller.current_state() == BullState.State.CONTROLLED:
			ready_count += 1
	var closed_doors: bool = _pen_released.has(false)
	hud.update_guidance(held.size(), ready_count, closed_doors)

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

## Resolution itself lives in the shared LassoController (same code as the open
## world, Ant 7-nov 20:02): nearest candidate to the landing point first, each
## prey's own capture rule. Here only the level bookkeeping: capture order and
## the player's active-capture count for the towing speed penalty.
func _on_prey_captured(prey: Node2D) -> void:
	var bull = prey
	bull.capture_order = _next_capture_order
	_next_capture_order += 1
	player.set_active_capture_count(_held_bulls().size())

## The player tried to throw with no free lasso slot (Ant, 4-nov: throws are limited to
## the available slots — 1 normally, 2 with the dual lasso). The throw is refused in
## player.gd; here we explain why and how to free a slot.
func _on_throw_blocked() -> void:
	# One explanation per level attempt, even after freeing/refilling slots.
	if _no_lasso_room_hint_shown189:return
	_no_lasso_room_hint_shown189=true
	hud.flash_hint(tr("Sin hueco: doble toque en el lazo para soltar un toro antes de lanzar"), 1.8)

## One-shot dual-lasso unlock celebration: pause the action, show the animated overlay,
## remember it so it never nags again on later levels or replays.
func _show_dual_lasso_intro() -> void:
	_intro_overlay_active = true
	player.cancel_input()
	_reset_touch_controls()
	touch_controls.visible = false
	RanchMusic.set_paused(true)
	get_tree().paused = true
	hud.dual_lasso_intro_accepted.connect(_on_dual_lasso_intro_accepted, CONNECT_ONE_SHOT)
	hud.show_dual_lasso_intro()
	_audio.play("win")

func _on_dual_lasso_intro_accepted() -> void:
	SaveData.mark_dual_lasso_intro_shown()
	RanchMusic.set_paused(false)
	get_tree().paused = false
	touch_controls.visible = true
	_intro_overlay_active = false

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
		player.set_active_capture_count(_held_bulls().size())

func _on_tranquilizer_requested() -> void:
	if not _tranquilizer_available or _game_over or _paused_by_user_or_os:
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
	if _game_over:
		return
	_courier_jobs.erase(returned_bull) # permanently secured, not a released wild opener
	_refresh_trail()
	_audio.play("return")
	_bulls_returned += 1
	hud.update_bull_count(_bulls_returned, _active_bulls.size())
	if _win_requires_all_bulls and _bulls_returned >= _active_bulls.size():
		_trigger_win()

func _trigger_win() -> void:
	if _game_over:
		return
	_game_over = true
	_freeze_gameplay()
	var reward:int=SaveData.record_victory(_level_number,_training_session,_mounted_horse_id)
	hud.show_win()
	hud.end_label.text += "\nENSAYO AISLADO: sin premios ni progreso guardado" if SaveData.trial_session_active else "\n+%d puntos · Saldo: %d\nEquipo y precios en prueba" % [reward,SaveData.equipment_points]
	_show_training_result()
	_audio.play("win")

func _trigger_lose(reason: String) -> void:
	if _game_over:
		return
	_game_over = true
	_freeze_gameplay()
	hud.show_lose(reason)
	_show_training_result()
	_audio.play("lose")

func _freeze_gameplay() -> void:
	pen.delivery_enabled = false
	pen.set_physics_process(false)
	for station in _distraction_stations:
		station.set_process(false)
	player.cancel_all_actions()
	_reset_touch_controls()
	player.set_physics_process(false)
	for door in _pen_doors:
		if is_instance_valid(door):
			door.set_process(false)
	for bull in _active_bulls:
		bull.set_physics_process(false)
	touch_controls.visible = false  # stop joysticks from eating touches meant for the end-game buttons

func _on_next_requested() -> void:
	if not _game_over or _level_number >= LevelCatalog.MAX_LEVEL:
		return
	GameState.selected_level = _level_number + 1
	RanchMusic.set_paused(false)
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_restart_requested() -> void:
	RanchMusic.set_paused(false)
	get_tree().paused = false
	get_tree().reload_current_scene()

## Android lifecycle (ANDROID_REQUIREMENTS.md): going to background / losing focus pauses the
## game (otherwise the countdown would jump on resume); the back button toggles the pause
## menu. WM_GO_BACK_REQUEST is only delivered because project.godot sets quit_on_go_back=false.
func _toggle_pause() -> void:
	if _intro_overlay_active:
		return
	if _paused_by_user_or_os:
		resume_game()
	else:
		pause_game()

func _notification(what: int) -> void:
	match what:
		NOTIFICATION_APPLICATION_PAUSED, NOTIFICATION_WM_WINDOW_FOCUS_OUT:
			pause_game()


func pause_game() -> void:
	if _game_over or _paused_by_user_or_os or _intro_overlay_active:
		return
	_paused_by_user_or_os = true
	player.cancel_input()
	_reset_touch_controls()
	touch_controls.visible = false
	RanchMusic.set_paused(true)
	get_tree().paused = true
	hud.show_pause()

func resume_game() -> void:
	if not _paused_by_user_or_os:
		return
	_paused_by_user_or_os = false
	RanchMusic.set_paused(false)
	get_tree().paused = false
	hud.hide_pause()
	touch_controls.visible = true

func _on_quit_requested() -> void:
	RanchMusic.set_paused(false)
	get_tree().paused = false
	get_tree().change_scene_to_file(GameState.menu_scene)

func _on_bull_audio_state(state: BullState.State) -> void:
	if state == BullState.State.CAPTURED:
		_audio.play("capture")
	elif state == BullState.State.CONTROLLED:
		_audio.play("calm")

func _on_sound_toggled(value: bool) -> void:
	RanchMusic.set_enabled(value)
	_audio.enabled = value
	GameState.sound_enabled = value

func _reset_touch_controls() -> void:
	# Godot 4.7 VirtualJoystick has no public reset method. Its RESIZED handler
	# resets touch_index, vectors and action presses without emitting a throw.
	# Hiding the CanvasLayer alone leaves held actions stuck after focus loss.
	for stick_name: String in ["MoveJoystick", "AimJoystick"]:
		var stick: VirtualJoystick = touch_controls.get_node(stick_name)
		stick.notification(Control.NOTIFICATION_RESIZED)

## Non-solid tactical objects, introduced at level3; do not alter obstacle collisions.
func _spawn_distraction_stations() -> void:
	if _level_number < 3:
		return
	var entries: Array = [{"kind": "water", "position": Vector2(-350, -150)}, {"kind": "hay", "position": Vector2(400, 100)}]
	if _level_number >= 11:
		entries = [{"kind": "water", "position": Vector2(-150, 0)}, {"kind": "hay", "position": Vector2(180, 0)}]
	for entry: Dictionary in entries:
		var station := DistractionStation.new()
		station.kind = entry["kind"]
		station.position = entry["position"] * _arena_scale
		add_child(station)
		_distraction_stations.append(station)

func _refresh_trail() -> void:
	if not is_instance_valid(_link_overlay):return
	_link_overlay.active_from=-1
	_link_overlay.active_to=-1
	if not _courier_jobs.is_empty():
		var job:Dictionary=_courier_jobs.values()[0]
		if not job["targets"].is_empty():
			_link_overlay.active_from=job["from"]
			_link_overlay.active_to=job["targets"][0]

func _expand_arena() -> void:
	pen.position *= _arena_scale
	$PenBarrier.position *= _arena_scale
	for pair in [["FenceTop",true,-1],["FenceBottom",true,1],["FenceLeft",false,-1],["FenceRight",false,1]]:
		var fence: StaticBody2D = get_node(pair[0])
		var shape: CollisionShape2D = fence.get_node("CollisionShape2D")
		shape.shape = shape.shape.duplicate()
		if pair[1]:
			fence.position.y = pair[2] * (world_bounds.size.y / 2 + 10)
			shape.shape.size = Vector2(world_bounds.size.x + 40,20)
		else:
			fence.position.x = pair[2] * (world_bounds.size.x / 2 + 10)
			shape.shape.size = Vector2(20,world_bounds.size.y + 40)

func _update_follow_camera() -> void:
	var camera: Camera2D = $Camera2D
	var half: Vector2 = get_viewport_rect().size / (camera.zoom * 2)
	var border: Rect2 = world_bounds.grow(55)
	var center: Vector2 = player.global_position
	center.x = clampf(center.x,border.position.x+half.x,border.end.x-half.x)
	center.y = clampf(center.y,border.position.y+half.y,border.end.y-half.y)
	camera.position = center - camera.offset
	camera.force_update_scroll()

func _spawn_jump_fences()->void:
	# Short internal rails leave clear routes around both ends for bulls.
	if _level_number<3:return
	var center:Vector2=Vector2.ZERO
	for candidate:Vector2 in [Vector2(0,0),Vector2(0,-130),Vector2(0,130),Vector2(-200,0),Vector2(200,0)]:
		var clear:bool=true
		var footprint:Rect2=Rect2(candidate-Vector2(105,45),Vector2(210,90))
		for obstacle:Rect2 in _obstacle_rects:
			if footprint.intersects(obstacle):clear=false
		if footprint.intersects(Rect2(pen.position-Vector2(90,90),Vector2(180,180))):clear=false
		if clear:center=candidate;break
	var rect:Rect2=Rect2(center-Vector2(75,7),Vector2(150,14))
	var fence:=JumpFence.new();fence.position=center;add_child(fence)
	_obstacle_rects.append(rect)
	player.collision_mask|=32
	var horse:Dictionary=SaveData.horse_collection.find(SaveData.horse_collection.selected)
	player.can_jump=HorseJump.capable(horse)
	for bull in all_bulls:bull.collision_mask|=32

func _show_training_companion()->void:
	var mentor:Dictionary=SaveData.horse_collection.find(_training_session.mentor)
	var card:=Panel.new();card.name="TrainingStatus";card.position=Vector2(22,76);card.size=Vector2(390,150);card.mouse_filter=Control.MOUSE_FILTER_IGNORE;card.add_theme_stylebox_override("panel",RanchTheme.box(Color("10252d"),Color("77dbd5"),8));hud.add_child(card)
	var portrait:=TextureRect.new();portrait.position=Vector2(4,16);portrait.size=Vector2(78,100);portrait.expand_mode=TextureRect.EXPAND_IGNORE_SIZE;portrait.stretch_mode=TextureRect.STRETCH_KEEP_ASPECT_CENTERED;HorsePortrait.apply(portrait,mentor.traits,SaveData.hat_color);card.add_child(portrait)
	_training_status=Label.new();_training_status.position=Vector2(90,8);_training_status.size=Vector2(290,30);_training_status.add_theme_font_size_override("font_size",17);card.add_child(_training_status);_update_training_status()

func _update_training_status()->void:
	if not is_instance_valid(_training_status):return
	var current:Dictionary=TrainingReport.snapshot(SaveData.horse_collection,_training_session)
	if current.is_empty():return
	_training_status.text=str(current.name).left(22)+" · "+("Salto" if current.skill=="jump" else "Esquiva")
	var previous=_training_status.get_parent().get_node_or_null("TrainingBars")
	if previous!=null:previous.free()
	var bars:=VBoxContainer.new();bars.name="TrainingBars";bars.position=Vector2(90,40);bars.size.x=290;_training_status.get_parent().add_child(bars)
	for spec in [["Aprendizaje","learning"],["Dominio","mastery"],["Afinidad","affinity"]]:HorseStatBars.row(bars,spec[0],HorseStatBars.learned_value(SaveData.horse_collection.find(_training_session.learner),_training_session.skill) if spec[1]=="learning" else current[spec[1]],0,100,true)

func _show_training_result()->void:
	if _training_session.is_empty():return
	var after:Dictionary=TrainingReport.snapshot(SaveData.horse_collection,_training_session)
	if after.is_empty():return
	var summary:=Label.new();summary.name="TrainingResult";summary.position=Vector2(25,145);summary.size=Vector2(462,145);summary.horizontal_alignment=HORIZONTAL_ALIGNMENT_CENTER;summary.add_theme_font_size_override("font_size",18)
	summary.text=str(after.name).left(24)+" · "+("Salto" if after.skill=="jump" else "Esquiva")
	summary.size.y=30
	var bars:=VBoxContainer.new();bars.name="TrainingResultBars";bars.position=Vector2(25,190);bars.size.x=462;hud.end_panel.add_child(bars)
	for spec in [["Aprendizaje","learning"],["Dominio","mastery"],["Afinidad","affinity"]]:HorseStatBars.row(bars,spec[0],HorseStatBars.learned_value(SaveData.horse_collection.find(_training_session.learner),_training_session.skill) if spec[1]=="learning" else after[spec[1]],0,100,true)

	hud.end_panel.offset_top=-210;hud.end_panel.offset_bottom=210
	hud.end_label.position.y=12;hud.end_label.size.y=125
	hud.restart_button.position.y=330;hud.quit_button.position.y=330;hud._next_button.position.y=330
	hud.end_panel.add_child(summary)
	if is_instance_valid(_training_status):_training_status.get_parent().hide()

func navigate_back()->void:
	if _game_over:
		hud.quit_requested.emit()
	elif _paused_by_user_or_os:resume_game()
	else:pause_game()
