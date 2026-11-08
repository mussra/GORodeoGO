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
const WildHorseArtScript := preload("res://src/Presentation/wild_horse_art.gd")
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
## Streaming amortizado (Ant 8-nov 17:24, tirón al llegar al borde): el contenido
## del chunk sigue siendo 100% determinista (seed + edits), pero la CONSTRUCCIÓN
## se reparte en pasos con presupuesto de ms por frame y se adelanta en la
## dirección de la marcha. El conjunto ACTIVO sigue siendo el 3x3 alrededor del
## jinete: nodos al árbol, descubrimiento y guardado solo ocurren al activar.
const CHUNK_BUILD_BUDGET_MS := 6.0
const CHUNK_LOOKAHEAD_SECONDS := 1.6
var _chunk_pending: Dictionary = {}  # key -> builder en curso (fuera del árbol)
var _chunk_built: Dictionary = {}    # key -> builder terminado (caché fuera del árbol)
var _build_queue: Array = []         # keys pendientes, lo más cercano primero
var _hud: CanvasLayer
var _audio: RanchAudio
var aim_joystick: VirtualJoystick  # named like the levels so JoystickAppearance.apply works
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
## Lasso state lives in the shared LassoController on the player (Ant 20:02:
## "Quiero que se use el mismo código"); the world only keeps the HOLD session
## of the captured animal.
var _lasso_state: String = ""
var _lasso_horse: Node2D = null

## Occluder rects (owner -> Array[Rect2]): when the rider's feet are inside one,
## a tall body (house, tree, cactus) covers him, so a marker floats above him
## (Ant 7-nov-2026 16:50: "necesito ver claramente donde esta mi vaquero").
var _occluders: Dictionary = {}
var _marker: Node2D = null
var _clop_b: AudioStream = load("res://art/audio/hoof_b.wav")

func _ready() -> void:
	y_sort_enabled = true
	SaveData.ensure_world_seed()
	var base := ColorRect.new()
	base.mouse_filter = Control.MOUSE_FILTER_IGNORE
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
	_stamina = WorldStamina.new_state(HorseStats.read(SaveData.horse_collection.find(SaveData.horse_collection.selected)).get("power", 0.65))
	_hoof_player = AudioStreamPlayer.new()
	_hoof_player.volume_db = -12.0
	_hoof_player.bus = &"SFX" if AudioServer.get_bus_index("SFX") >= 0 else &"Master"
	player.add_child(_hoof_player)
	_update_chunks()
	# Primera pintura completa: la 3x3 inicial se construye de una vez (es el
	# momento de carga); el streaming en marcha ya va repartido por frames.
	while not _build_queue.is_empty():
		_step_chunk_build()
	_update_chunks()

func _process(delta: float) -> void:
	_update_chunks()
	_drain_chunk_builds()
	_tick_taming(delta)
	_tick_lasso(delta)
	_tick_rider_marker()
	if _gauges.has("dodge"):
		# Same rule as the levels (Ant 7-nov-2026 21:33 "Igual"): the dodge needs
		# a trained horse; recomputed so switching horses at the board updates it.
		var horse: Dictionary = SaveData.horse_collection.find(SaveData.horse_collection.selected)
		player.dodge_available = HorseTraining.knows(horse, "dodge")
		player.dodge_recharge_seconds = 2.5 * HorseTraining.recovery(horse, "dodge")
		_gauges["dodge"].set_state(player.dodge_available, 1.0 - player.dodge_cooldown / maxf(0.01, player.dodge_recharge_seconds))
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


func _draw_rider_marker(n: Node2D) -> void:
	var tri := PackedVector2Array([Vector2(-11, -8), Vector2(11, -8), Vector2(0, 8)])
	n.draw_colored_polygon(tri, Color("201b1c"))
	n.draw_colored_polygon(PackedVector2Array([Vector2(-7, -6), Vector2(7, -6), Vector2(0, 5)]), Color("ffd23d"))

func _tick_lasso(_delta: float) -> void:
	# Ant 21:47: the roped animal stays put and the hold timer captures it —
	# if the timer runs out first, it bolts (release path cancels the session).
	if _lasso_state == "hold":
		if not is_instance_valid(_lasso_horse):
			_end_lasso()
		elif _lasso_horse.held <= 0.0:
			var st: Dictionary = _lasso_horse.state
			if st.has("flee"):
				st["flee"] = true
			else:
				var aff: Dictionary = _affinity(_lasso_horse)
				st["spook"] = WorldTaming.spook_seconds(aff.matches)
				# Semental que rompe el lazo: pista inmediata (Ant 8-nov 15:02).
				if "herd" in _lasso_horse and WorldTaming.is_stallion(_lasso_horse.herd) and not WorldTaming.stallion_admits(aff.matches, aff.leader):
					_stallion_hint(_lasso_horse)
			_lasso_horse.state = st
			_lasso_horse.release()
			_end_lasso()



func _release_held_horse() -> void:
	if _lasso_state != "hold" or not is_instance_valid(_lasso_horse):
		return
	var st: Dictionary = _lasso_horse.state
	if st.has("flee"):
		st["flee"] = true
	else:
		st["spook"] = WorldTaming.spook_seconds(_affinity(_lasso_horse).matches)
	_lasso_horse.state = st
	_lasso_horse.release()
	_end_lasso()



func _lasso_pigs() -> Array:
	var out: Array = []
	for key in _chunks:
		var pen: Node2D = _chunks[key].get_node_or_null("pigs")
		if pen == null:
			continue
		for pig in pen.get_children():
			if is_instance_valid(pig):
				out.append(pig)
	return out

func _end_lasso() -> void:
	_lasso_horse = null
	_lasso_state = ""
	player.lasso.set_active_capture_count(0)

## The shared controller resolved a capture: start the hold session (trust
## fills while the animal is held in place; it flees/spooks when the hold ends).
func _on_lasso_prey_captured(prey: Node2D) -> void:
	_lasso_horse = prey
	prey.roped = true
	prey.rider = player
	prey.held = WorldTaming.HOLD_SECONDS
	# Semental no admitido (Ant 8-nov 15:02): rompe el lazo casi al instante.
	if "herd" in prey and WorldTaming.is_stallion(prey.herd):
		var aff: Dictionary = _affinity(prey)
		if not WorldTaming.stallion_admits(aff.matches, aff.leader):
			prey.held = WorldTaming.STALLION_BREAK_SECONDS
	_lasso_state = "hold"
	player.lasso.set_active_capture_count(1)

## Avisos progresivos ante un semental que no se fia (Ant 8-nov 15:02): la
## pista se concreta con cada intento (fase de sesion) y cada caballo tiene
## un enfriamiento para no machacar con el mismo aviso.
var _stallion_hint_stage: int = 0

func _stallion_hint(horse: Node2D) -> void:
	var now: float = Time.get_ticks_msec() / 1000.0
	if now < float(horse.get_meta("stallion_hint_cd", 0.0)):
		return
	horse.set_meta("stallion_hint_cd", now + WorldTaming.STALLION_HINT_COOLDOWN)
	_toast(tr(WorldTaming.stallion_hint_key(_stallion_hint_stage)))
	_stallion_hint_stage += 1

func _toast(text: String) -> void:
	_toast_label.text = text
	# The edit palette covers (20..660, 56..206); drop the toast under it so a
	# "mision descubierta" never hides the tool help (validation 8-nov).
	_toast_label.position.y = 216.0 if is_instance_valid(_edit_panel) and _edit_panel.visible else 60.0
	_toast_left = 3.0
	_toast_label.modulate.a = 1.0

func _update_chunks() -> void:
	var pc: Vector2i = WorldMap.chunk_at(player.position)
	for dx in range(-1, 2):
		for dy in range(-1, 2):
			_activate_or_queue(pc.x + dx, pc.y + dy)
	# Pregeneración: la manzana hacia la que cabalga el jinete se construye antes.
	if is_instance_valid(player) and player.velocity.length() > 30.0:
		var ahead: Vector2i = WorldMap.chunk_at(player.position + player.velocity * CHUNK_LOOKAHEAD_SECONDS)
		for dx in range(-1, 2):
			for dy in range(-1, 2):
				var c := Vector2i(ahead.x + dx, ahead.y + dy)
				if (c.x != pc.x or c.y != pc.y) and absi(c.x - pc.x) <= 2 and absi(c.y - pc.y) <= 2:
					_queue_build(c.x, c.y)
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
		_occluders.erase(key)  # ojo: scope original (borra cada frame; bug latente, reportado)
	_drop_far(pc, _chunk_pending)
	_drop_far(pc, _chunk_built)
	_build_queue.sort_custom(func(a, b):
		var ba: Dictionary = _chunk_pending.get(a, {})
		var bb: Dictionary = _chunk_pending.get(b, {})
		if ba.is_empty() or bb.is_empty():
			return false
		return absi(int(ba["cx"]) - pc.x) + absi(int(ba["cy"]) - pc.y) < absi(int(bb["cx"]) - pc.x) + absi(int(bb["cy"]) - pc.y))

func _drop_far(pc: Vector2i, store: Dictionary) -> void:
	for key in store.keys():
		var b: Dictionary = store[key]
		if absi(int(b["cx"]) - pc.x) > 2 or absi(int(b["cy"]) - pc.y) > 2:
			_discard_builder(b)
			store.erase(key)
			_build_queue.erase(key)

func _discard_builder(b: Dictionary) -> void:
	if is_instance_valid(b.get("node")):
		(b["node"] as Node).free()
	for e in b.get("entities", []):
		if is_instance_valid(e):
			(e as Node).free()
	# Los SpriteFrames del caballo viven en la caché global por genotipo: se quedan.

func _queue_build(cx: int, cy: int) -> void:
	var key: String = WorldMap.chunk_key(cx, cy)
	if _chunks.has(key) or _chunk_pending.has(key) or _chunk_built.has(key):
		return
	_chunk_pending[key] = {"cx": cx, "cy": cy, "phase": 0, "node": null, "entities": [], "boxes": [], "occluders": [], "decor_todo": [], "pig_todo": [], "pig_idx": 0, "data": {}, "frames": null, "frame_specs": null, "done": false}
	_build_queue.append(key)

func _activate_or_queue(cx: int, cy: int) -> void:
	var key: String = WorldMap.chunk_key(cx, cy)
	if _chunks.has(key):
		return
	if _chunk_built.has(key):
		_activate_built(key)
		return
	_queue_build(cx, cy)

func _drain_chunk_builds() -> void:
	var start: int = Time.get_ticks_usec()
	var budget: int = int(CHUNK_BUILD_BUDGET_MS * 1000.0)
	var first := true
	while not _build_queue.is_empty():
		if not first and Time.get_ticks_usec() - start > budget:
			break
		first = false
		_step_chunk_build()

func _step_chunk_build() -> void:
	if _build_queue.is_empty():
		return
	var key: String = _build_queue[0]
	var b: Dictionary = _chunk_pending.get(key, {})
	if b.is_empty():
		_build_queue.pop_front()
		return
	_advance_builder(b)
	if b.get("done", false):
		_chunk_pending.erase(key)
		_chunk_built[key] = b
		_build_queue.pop_front()
		var pc: Vector2i = WorldMap.chunk_at(player.position)
		if absi(int(b["cx"]) - pc.x) <= 1 and absi(int(b["cy"]) - pc.y) <= 1:
			_activate_built(key)

## Un micro-paso de construcción por llamada; el drenaje repite hasta gastar el
## presupuesto del frame. Contenido idéntico al _ensure_chunk síncrono anterior.
func _advance_builder(b: Dictionary) -> void:
	var cx: int = b["cx"]
	var cy: int = b["cy"]
	match int(b["phase"]):
		0:
			b["data"] = WorldEdits.apply(WorldMap.generate(SaveData.world_seed, cx, cy), SaveData.world_edits, cx, cy)
			var node := Node2D.new()
			node.set_meta("c", Vector2i(cx, cy))
			var ground := ColorRect.new()
			ground.mouse_filter = Control.MOUSE_FILTER_IGNORE
			ground.color = Color("32653a").lerp(Color("3a7142"), float(absi(hash(WorldMap.chunk_key(cx, cy))) % 100) / 220.0)
			ground.size = Vector2(WorldMap.CHUNK_SIZE, WorldMap.CHUNK_SIZE)
			ground.position = Vector2(cx, cy) * WorldMap.CHUNK_SIZE
			ground.z_index = -9
			node.add_child(ground)
			b["node"] = node
			b["decor_todo"] = (b["data"] as Dictionary).get("decor", []).duplicate()
			b["phase"] = 1
		1:
			var todo: Array = b["decor_todo"]
			if todo.is_empty():
				b["phase"] = 2
				return
			var d: Dictionary = todo.pop_front()
			var decor := DecorScript.new()
			decor.kind = d["kind"]
			decor.size_scale = d["scale"]
			var boff: float = DecorScript.base_offset(d["kind"], d["scale"])
			decor.draw_offset = Vector2(0, -boff)
			decor.position = d["pos"] + Vector2(0, boff)
			(b["entities"] as Array).append(decor)
			var occ: Rect2 = DecorScript.occluder_box(d["kind"], d["pos"], d["scale"])
			if occ.has_area():
				(b["occluders"] as Array).append(occ)
			var box: Rect2 = DecorScript.solid_box(d["kind"], d["pos"], d["scale"])
			if box.has_area():
				(b["boxes"] as Array).append(box)
			if todo.is_empty():
				b["phase"] = 2
		2:
			var pigs: Dictionary = (b["data"] as Dictionary).get("pigs", {})
			var pig_id: String = WorldEdits.edited_pen_id(pigs.get("pos", Vector2.ZERO)) if pigs.get("edited", false) else WorldMap.pig_id(cx, cy)
			if not pigs.is_empty() and not SaveData.world_pigs.has(pig_id):
				var todo: Array = b["pig_todo"]
				if todo.is_empty() and int(b["pig_idx"]) == 0:
					var base: Vector2 = pigs["pos"]
					var count: int = int(pigs.get("count", 2))
					for i in count:
						todo.append(base + Vector2(cos(i * TAU / maxf(1.0, float(count))), sin(i * TAU / maxf(1.0, float(count)))) * 44.0)
				if todo.is_empty():
					b["phase"] = 3
					return
				var pos: Vector2 = todo.pop_front()
				var pig := PigScript.new()
				pig.name = "pig%d" % int(b["pig_idx"])
				b["pig_idx"] = int(b["pig_idx"]) + 1
				pig.setup({"pos": pos})
				(b["entities"] as Array).append(pig)
				if not todo.is_empty():
					return
			b["phase"] = 3
		3:
			var trail := TrailScript.new()
			trail.c = Vector2i(cx, cy)
			(b["node"] as Node2D).add_child(trail)
			b["phase"] = 4
		4:
			# Frames del caballo de la manada: una textura recoloreada por paso
			# (61 en total; es el 90% del coste del chunk). Misma caché por
			# genotipo que wild_horse_art.gd, así manadas repetidas son gratis.
			var herd: Dictionary = (b["data"] as Dictionary).get("herd", {})
			var mission_id: String = WorldMap.herd_mission_id(cx, cy)
			if herd.is_empty() or SaveData.world_tamed.has(mission_id):
				b["phase"] = 5
				return
			var traits: Dictionary = herd.get("traits", {})
			var cache_key := str(traits)
			if WildHorseArtScript.frame_cache.has(cache_key):
				b["phase"] = 5
				return
			if b["frame_specs"] == null:
				var frames := SpriteFrames.new()
				b["frames"] = frames
				var specs: Array = []
				for spec in [["wild_side", [0], "idle", 3.0], ["wild_walk_side", range(12), "walk", 12.0], ["wild_walk_down", range(12), "walk_down", 12.0], ["wild_walk_up", range(12), "walk_up", 12.0], ["wild_walk_diag_down", range(12), "walk_diag_down", 12.0], ["wild_walk_diag_up", range(12), "walk_diag_up", 12.0]]:
					for i in spec[1]:
						specs.append([spec[0], i, spec[2], spec[3]])
				b["frame_specs"] = specs
			var step: Array = (b["frame_specs"] as Array).pop_front()
			var frames: SpriteFrames = b["frames"]
			if not frames.has_animation(step[2]):
				frames.add_animation(step[2])
				frames.set_animation_speed(step[2], step[3])
			var base: Texture2D = load("res://art/world/wild_base/%s/frame_%02d.png" % [String(step[0]).trim_prefix("wild_"), int(step[1])])
			frames.add_frame(step[2], HorseAppearance.texture(base, step[0], int(step[1]), traits))
			if (b["frame_specs"] as Array).is_empty():
				WildHorseArtScript.frame_cache[cache_key] = frames
				b["phase"] = 5
		5:
			b["done"] = true

## El chunk construido entra en el conjunto activo (3x3): aquí es cuando sus
## nodos se añaden al árbol y se marca el descubrimiento, igual que antes.
func _activate_built(key: String) -> void:
	var b: Dictionary = _chunk_built.get(key, {})
	if b.is_empty():
		return
	_chunk_built.erase(key)
	var cx: int = b["cx"]
	var cy: int = b["cy"]
	var entities: Array = b["entities"]
	for e in entities:
		add_child(e)
	for box in b["boxes"]:
		entities.append(Physics.add_box(self, box))
	for e in entities.duplicate():
		if e is Node2D and String((e as Node2D).name).begins_with("pig"):
			entities.append(Physics.add_box(self, Rect2((e as Node2D).position + Vector2(-12, -6), Vector2(24, 12))))
	for occ in b["occluders"]:
		register_occluder(key, occ)
	var data: Dictionary = b["data"]
	var herd: Dictionary = data.get("herd", {})
	var mission_id: String = WorldMap.herd_mission_id(cx, cy)
	if not herd.is_empty() and not SaveData.world_tamed.has(mission_id):
		var horse := WildHorseScript.new()
		horse.name = "herd"
		horse.setup(herd)
		horse.set_meta("c", Vector2i(cx, cy))
		add_child(horse)
		entities.append(horse)
		_herd_horses[key] = horse
	add_child(b["node"])
	_chunks[key] = b["node"]
	_chunk_entities[key] = entities
	if not SaveData.world_discovered.has(key):
		SaveData.mark_world_discovered(key)
		if not herd.is_empty() and not SaveData.world_tamed.has(mission_id) and not SaveData.world_missions.has(mission_id):
			SaveData.set_world_mission(mission_id, "offered")
			_toast(tr("WORLD_FOUND"))
			_refresh_missions()
			SaveData.save_world_state(player.position)

## Afinidad genetica (Ant 8-nov 13:33): el caballo equipado comparte rasgos
## visibles (pelaje/patron/crin) con el salvaje -> confia mas y se asusta
## menos. Si ademas es "Lider de manada" (3 generaciones, rasgos fijados) y
## comparte los 3 rasgos, el salvaje no huye: curiosea y se acerca.
func _affinity(horse: Node2D) -> Dictionary:
	var ridden: Dictionary = SaveData.horse_collection.find(SaveData.horse_collection.selected)
	var matches: int = WorldTaming.affinity_matches(ridden.get("traits", {}), horse.herd.get("traits", {}))
	return {"matches": matches, "bonus": WorldTaming.affinity_bonus(matches), "leader": matches == 3 and PackLeader.is_leader(ridden, SaveData.horse_collection)}

func _tick_taming(delta: float) -> void:
	for key in _herd_horses:
		var raw = _herd_horses[key]
		if not is_instance_valid(raw):
			continue
		var horse: Node2D = raw
		var dist: float = player.position.distance_to(horse.position)
		if dist > 700.0:
			continue
		var aff: Dictionary = _affinity(horse)
		horse.affinity_matches = aff.matches
		horse.pack_leader_near = aff.leader
		horse.player_ref = player
		# Semental desconfiado (Ant 8-nov 15:02): sin caballo familiar (2+ rasgos
		# o Lider de manada) huye antes del tiro de lazo y no gana confianza.
		var stallion_guard: bool = WorldTaming.is_stallion(horse.herd) and not WorldTaming.stallion_admits(aff.matches, aff.leader)
		var st: Dictionary
		if horse.roped:
			# Roped: trust fills fast while the horse stays put (Ant 21:47).
			# El semental no admitido NUNCA llena confianza en el lazo: lo rompe.
			st = horse.state if stallion_guard else WorldTaming.hold_tick(horse.state, float(horse.herd.get("temperament", 0.5)), delta, aff.bonus)
		else:
			if aff.leader and float(horse.state.get("progress", 0.0)) < WorldTaming.LEADER_START_PROGRESS and dist < WorldTaming.CALM_RANGE * 1.5:
				horse.state["progress"] = WorldTaming.LEADER_START_PROGRESS
			st = WorldTaming.tick(horse.state, dist, player.velocity.length(), player.calm(), float(horse.herd.get("temperament", 0.5)), delta, aff.bonus, WorldTaming.spook_seconds(aff.matches))
			if stallion_guard and dist < WorldTaming.STALLION_FLEE_RANGE:
				if float(st.get("spook", 0.0)) <= 0.0:
					_stallion_hint(horse)
				st["spook"] = WorldTaming.SPOOK_SECONDS
		horse.state = st
		if WorldTaming.tamed(st):
			_deliver_horse(horse.get_meta("c"), horse)
			continue
		if horse.roped:
			continue  # held horses can't bolt
		# "Que suelte" (Ant, 7-nov-2026 19:58, the corral rule): contact with a
		# bolting wild animal stuns the rider and drops the roped capture.
		var touching: bool = dist <= horse.BODY_RADIUS + horse.RIDER_TOUCH_RADIUS
		if aff.leader:
			# Lider de manada: no huye; curiosea y se acerca despacio.
			if dist < WorldTaming.CALM_RANGE * 1.6 and dist > 60.0:
				horse.approach(player.position, delta)
			if dist < WorldTaming.CALM_RANGE * 1.5:
				horse.face_towards(player.position)
		elif WorldTaming.should_flee(st, dist):
			horse.flee_from(player.position, delta)
			if touching and not horse._touching_rider and horse.touch_grace <= 0.0:
				player.stun()
				_release_held_horse()
		elif dist < WorldTaming.CALM_RANGE * 1.5:
			horse.face_towards(player.position)
		horse._touching_rider = touching

func _deliver_horse(c: Vector2i, horse: Node2D) -> void:
	if horse == _lasso_horse:
		_end_lasso()
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
	_audio.play("return")
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
			if dist > 700.0 and not pig.roped:
				all_captured = false
				continue
			var st: Dictionary
			if pig.roped:
				# Roped: trust fills fast while the pig stays put (Ant 21:47).
				st = WorldPigs.hold_tick(pig.state, delta)
			else:
				st = WorldPigs.tick(pig.state, dist, player.velocity.length(), delta)
			pig.state = st
			if WorldPigs.captured(st):
				if pig == _lasso_horse:
					_end_lasso()
				_audio.play("return")
				pig.queue_free()  # captured: counts right away (roped or walk-up)
			else:
				all_captured = false
				if pig.roped:
					continue  # held pigs can't bolt
				# "Que suelte": a bolting pig stuns on contact, like a wild bull.
				var touching: bool = dist <= pig.BODY_RADIUS + pig.RIDER_TOUCH_RADIUS
				if st.get("flee", false):
					pig.flee_from(player.position, delta)
					if touching and not pig._touching_rider and pig.touch_grace <= 0.0:
						player.stun()
						_release_held_horse()
				elif dist < WorldPigs.CAPTURE_RANGE * 1.5:
					pig.face_towards(player.position)
				pig._touching_rider = touching
		if all_captured and pen.get_child_count() == 0:
			_on_pigs_captured(Vector2i(node.get_meta("c")), pen)

func _on_pigs_captured(c: Vector2i, pen: Node2D) -> void:
	_audio.play("win")
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
	if _map_overlay.expanded and event.is_action_pressed("ui_cancel"):
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
		for k in _chunk_pending:
			_discard_builder(_chunk_pending[k])
		_chunk_pending.clear()
		for k in _chunk_built:
			_discard_builder(_chunk_built[k])
		_chunk_built.clear()
		_build_queue.clear()
		_update_chunks()
		while not _build_queue.is_empty():
			_step_chunk_build()
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
	bar.mouse_filter = Control.MOUSE_FILTER_IGNORE
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
		g.mouse_filter = Control.MOUSE_FILTER_IGNORE
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
	# No dodge button: the regate is the corral's gesture (double-press the
	# move stick), handled by the shared DodgeController on the player.
	_map_overlay = DiscoveryMap.new()
	_map_overlay.world = self
	# Ant 22:49 ("el mapa pequeño no puedo recuperarlo tras cerrarlo"): like the
	# arena minimap, the small map is ALWAYS there; closing only collapses it.
	_map_overlay.visible = true
	_hud.add_child(_map_overlay)
	# Same TouchControls scene as the levels (Ant 18:17: "No una copia") — one
	# shared system; the world only adjusts layer and the bounded aim zone.
	var touch: CanvasLayer = load("res://src/Presentation/touch_controls.tscn").instantiate()
	touch.layer = 0
	add_child(touch)
	var joy: VirtualJoystick = touch.get_node("MoveJoystick")
	joy.anchor_top = 0.32
	var aim_joy: VirtualJoystick = touch.get_node("AimJoystick")
	aim_joy.anchor_top = 0.32
	player.lasso.set_aim_joystick(aim_joy)
	aim_joystick = aim_joy
	JoystickAppearance.apply(self)  # same horse-themed sticks as the levels
	player.dodge.set_move_joystick(joy)
	# Same cues as the levels (Ant: same sounds) — one shared RanchAudio.
	_audio = RanchAudio.new()
	_audio.enabled = GameState.sound_enabled
	add_child(_audio)
	player.dodge.drawing_started.connect(func(): _audio.play("bullet_in"))
	player.dodge.drawing_finished.connect(func(): _audio.play("bullet_out"))
	player.dodge.dodge_started.connect(func(): _audio.play("dodge"))
	player.dodge.dodge_finished.connect(func(): _audio.play("skid"))
	player.stunned.connect(func(): _audio.play("stun"))
	player.lasso.lasso_thrown.connect(func(_o: Vector2, _p: Vector2): _audio.play("throw"))
	player.lasso.prey_captured.connect(func(_p: Node2D): _audio.play("capture"))
	player.lasso.prey_provider = func() -> Array:
		var out: Array = []
		for key in _herd_horses:
			if is_instance_valid(_herd_horses[key]):
				out.append(_herd_horses[key])
		out.append_array(_lasso_pigs())
		return out
	player.lasso.can_capture = func() -> bool: return _lasso_state == ""
	player.lasso.prey_captured.connect(_on_lasso_prey_captured)
	player.lasso.release_requested.connect(func(): _release_held_horse())

func _toggle_map() -> void:
	# Toggles collapsed <-> expanded; the small map never disappears (Ant 22:49).
	_map_overlay.visible = true
	_map_overlay.expanded = not _map_overlay.expanded
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
	## Small corner minimap like the arena one (Ant 17:54: "pequeño como el otro"):
	## tap the small map to expand it; X / back / Mapa button closes.
	var world: Node2D
	var expanded: bool = false
	var zoom: float = 1.0
	var pan: Vector2 = Vector2.ZERO
	var _dragging: bool = false
	var _drag_from: Vector2 = Vector2.ZERO
	var _pan_from: Vector2 = Vector2.ZERO
	var _pulse: float = 0.0
	var _close_btn: Button = null
	var _zoom_btns: Array = []

	func _layout() -> void:
		var viewport: Vector2 = get_viewport_rect().size
		size = Vector2(minf(700, viewport.x - 80), minf(410, viewport.y - 180)) if expanded else Vector2(180, 112)
		position = (viewport - size) / 2.0 if expanded else Vector2(viewport.x - size.x - 18, 84)

	func _process(delta: float) -> void:
		if visible:
			_pulse += delta
			_layout()
			if _close_btn != null:
				_close_btn.visible = expanded
			for b in _zoom_btns:
				b.visible = expanded
			queue_redraw()

	func _ready() -> void:
		mouse_filter = Control.MOUSE_FILTER_STOP
		# Ant 22:54 ("el mapa se sale con el zoom"): never paint outside the box.
		clip_contents = true
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
		_close_btn = close
		var minus := Button.new()
		minus.text = "-"
		minus.position = Vector2(24, size.y - 84)
		minus.size = Vector2(56, 56)
		minus.pressed.connect(func(): _set_zoom(zoom / 1.4))
		add_child(minus)
		_zoom_btns.append(minus)
		var plus := Button.new()
		plus.text = "+"
		plus.position = Vector2(96, size.y - 84)
		plus.size = Vector2(56, 56)
		plus.pressed.connect(func(): _set_zoom(zoom * 1.4))
		add_child(plus)
		_zoom_btns.append(plus)

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
					if expanded:
						world._toggle_map()
					else:
						expanded = true
				_dragging = false
		elif event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_WHEEL_UP and event.pressed:
			_set_zoom(zoom * 1.15)
		elif event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_WHEEL_DOWN and event.pressed:
			_set_zoom(zoom / 1.15)
		elif event is InputEventMouseMotion and _dragging and expanded:
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
		# same shell as the arena minimap: dark framed box, content inside
		draw_style_box(RanchTheme.box(Color(0.04, 0.13, 0.17, 0.94), Color("89bdb7"), 9), Rect2(Vector2.ZERO, size))
		var area: Rect2 = Rect2(Vector2(12, 12), size - Vector2(24, 24))
		if area.size.x <= 0.0 or area.size.y <= 0.0:
			return
		draw_rect(area, Color("1d2a26"), true)
		var data: Dictionary = _cells()
		if (data.cells as Array).is_empty():
			return
		var mins: Vector2i = data.mins
		var maxs: Vector2i = data.maxs
		var cols: int = maxs.x - mins.x + 1
		var rows: int = maxs.y - mins.y + 1
		var cell: float = minf(72.0, minf((area.size.x - 16.0) / cols, (area.size.y - 16.0) / rows)) * (zoom if expanded else 1.0)
		# Ant 22:54: clamp the pan so the zoomed map always keeps content in view.
		var content: Vector2 = Vector2(cols, rows) * cell
		var limit: Vector2 = ((content - area.size) / 2.0) + Vector2(48, 48)
		limit.x = maxf(limit.x, 0.0)
		limit.y = maxf(limit.y, 0.0)
		pan = pan.clamp(-limit, limit)
		var origin: Vector2 = area.position + (area.size - content) / 2.0 + (pan if expanded else Vector2.ZERO)
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
