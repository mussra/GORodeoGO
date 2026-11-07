extends Node

## Persistent progression (Autoload — see project.godot [autoload]).
## Single tracked value: highest level completed. Every unlock is derived from this —
## no currency, no shop (PROJECT_SPEC.md explicitly excludes a complex economy from MVP).
## Persisted data is validated on load (LevelProgression.sanitize_highest_completed) and
## written atomically (temp file + rename) so an interrupted write cannot corrupt the save.

# Separate candidate storage preserves the 2.0 save byte-for-byte for rollback.
# First launch reads 2.0 only when the new file does not yet exist.
const LEGACY_2_SAVE_PATH: String = "user://save.dat"
const SAVE_PATH: String = "user://save-genetics-v3.dat"
const SAVE_VERSION: int = 3  ## bump when the file layout changes, to allow migrations

const NORMAL_SAVE_PATH:String="user://save-normal-v4.dat"
const DEBUG_SAVE_PATH:String="user://save-debug-v4.dat"
var _load_valid:bool=true
var debug_mode:bool=false
var normal_mode_path:String=NORMAL_SAVE_PATH
var debug_mode_path:String=DEBUG_SAVE_PATH
var horse_collection:HorseCollection = HorseCollection.new()
var hat_color: String = "original"
var highest_level_completed: int = 0
var equipment_points: int = 0
var equipment_owned: Array[String] = []
var equipment_equipped: Dictionary = {}
var points_legacy_credit_applied: bool = false
# Reward policy is supplied by the reviewed economy integration, not guessed on load.

## One-shot flag: the "¡Has conseguido el doble lazo!" intro plays the first time the
## upgrade applies (entering a level with dual capture unlocked), never again after.
var dual_lasso_intro_shown: bool = false

## Frontera: bounded open-world test (Ant, 7-nov-2026). Seed 0 = world not created yet.
## Discovered chunks never change once seen; tamed herds never respawn.
var world_seed: int = 0
var world_discovered: Array[String] = []
var world_tamed: Array[String] = []
var world_position: Vector2 = Vector2(0, 160)
var world_missions: Dictionary = {}  # mission id -> "offered" / "done"
# Overridden only by isolated persistence tests; production retains its original path.
var save_path: String = NORMAL_SAVE_PATH

func _ready() -> void:
	load_progress()
	apply_legacy_points_credit(EquipmentCatalog.REWARDS)

func record_level_completed(level_number: int) -> void:
	if is_new_record(level_number):
		highest_level_completed = level_number
		save_progress()

## Pure decision logic, no side effects — split out so tests can verify it without
## triggering a real disk write to the user's actual save file.
func is_new_record(level_number: int) -> bool:
	return level_number >= 1 and level_number <= LevelCatalog.MAX_LEVEL and level_number > highest_level_completed

func mark_dual_lasso_intro_shown() -> void:
	if dual_lasso_intro_shown:
		return
	dual_lasso_intro_shown = true
	save_progress()

func save_progress() -> bool:
	if not _load_valid:return false # retain unreadable source instead of replacing it with defaults
	if trial_session_active:return true # in-memory selections only, never touch real save
	var config := ConfigFile.new()
	config.set_value("meta", "version", SAVE_VERSION)
	config.set_value("progress", "highest_level_completed", highest_level_completed)
	config.set_value("progress", "dual_lasso_intro_shown", dual_lasso_intro_shown)
	config.set_value("appearance", "hat_color", hat_color)
	if horse_collection.horses.is_empty():horse_collection.seed_trial()
	config.set_value("horses_trial", "state", horse_collection.export_state())
	config.set_value("world", "seed", world_seed)
	config.set_value("world", "discovered", world_discovered)
	config.set_value("world", "tamed", world_tamed)
	config.set_value("world", "position", world_position)
	config.set_value("world", "missions", world_missions)
	config.set_value("equipment", "points", equipment_points)
	config.set_value("equipment", "owned", equipment_owned)
	config.set_value("equipment", "equipped", equipment_equipped)
	config.set_value("equipment", "legacy_credit_applied", points_legacy_credit_applied)
	var temp_path: String = save_path + ".tmp"
	var err: Error = config.save(temp_path)
	if err == OK:
		err = DirAccess.rename_absolute(temp_path, save_path)
	if err != OK:
		push_error("SaveData: could not save progress (error %d)." % err)
		return false
	return true

static func load_source_path(current:String,legacy:String)->String:
	# An unreadable new save must not silently fall back to stale progress.
	return current if FileAccess.file_exists(current) else legacy

func load_progress() -> void:
	_load_valid=true
	if trial_session_active:end_trial_session()
	horse_collection=HorseCollection.new()
	horse_collection.seed_trial()
	hat_color = "original"
	equipment_points = 0
	equipment_owned.clear()
	equipment_equipped.clear()
	points_legacy_credit_applied = false
	world_seed = 0
	world_discovered.clear()
	world_tamed.clear()
	world_position = Vector2(0, 160)
	world_missions.clear()
	var config := ConfigFile.new()
	var source_path:String=load_source_path(save_path,LEGACY_2_SAVE_PATH) if save_path==SAVE_PATH else save_path
	if save_path==NORMAL_SAVE_PATH and not FileAccess.file_exists(save_path):source_path=load_source_path(SAVE_PATH,LEGACY_2_SAVE_PATH)
	var err: Error = config.load(source_path)
	if err != OK:
		_load_valid=not FileAccess.file_exists(source_path)
		dual_lasso_intro_shown = false
		highest_level_completed = 0  # first run (no file) or unreadable file
		return
	if not config.has_section_key("progress","highest_level_completed"):
		_load_valid=false
		return
	if config.has_section_key("horses_trial","state") and not horse_collection.restore(config.get_value("horses_trial","state",{})):
		_load_valid=false
		return
	hat_color = HatAppearance.sanitize(config.get_value("appearance", "hat_color", "original"))
	highest_level_completed = LevelProgression.sanitize_highest_completed(
		config.get_value("progress", "highest_level_completed", 0)
	)
	dual_lasso_intro_shown = config.get_value("progress", "dual_lasso_intro_shown", false)

	var points:Variant=config.get_value("equipment","points",0)
	equipment_points=points if typeof(points)==TYPE_INT and points>=0 else 0
	var owned:Variant=config.get_value("equipment","owned",[])
	if typeof(owned)==TYPE_ARRAY or typeof(owned)==TYPE_PACKED_STRING_ARRAY:
		for item in owned:
			if typeof(item)==TYPE_STRING and not equipment_owned.has(item):equipment_owned.append(item)
	var equipped:Variant=config.get_value("equipment","equipped",{})
	if typeof(equipped)==TYPE_DICTIONARY:
		for slot in equipped:
			if typeof(slot)==TYPE_STRING and typeof(equipped[slot])==TYPE_STRING:equipment_equipped[slot]=equipped[slot]
	points_legacy_credit_applied=config.get_value("equipment","legacy_credit_applied",false)==true
	var wseed:Variant=config.get_value("world","seed",0)
	if typeof(wseed)==TYPE_INT and wseed>0:world_seed=wseed
	for pair in [["discovered",world_discovered],["tamed",world_tamed]]:
		var raw:Variant=config.get_value("world",pair[0],[])
		if raw is Array or raw is PackedStringArray:
			for item in raw:
				if typeof(item)==TYPE_STRING and not pair[1].has(item):pair[1].append(item)
	var wpos:Variant=config.get_value("world","position",world_position)
	if typeof(wpos)==TYPE_VECTOR2 and wpos.is_finite():world_position=wpos
	var wm:Variant=config.get_value("world","missions",{})
	if typeof(wm)==TYPE_DICTIONARY:
		for id in wm:
			if typeof(id)==TYPE_STRING and wm[id] in ["offered","encargo","done"]:world_missions[id]=wm[id]

## One credit for the deducible first win of each completed level. Repeated wins
## before this update were not stored. A missing reward definition postpones migration.
## Loading alone never applies a guessed reward policy or clears existing progress.
func apply_legacy_points_credit(rewards:Dictionary)->bool:
	if points_legacy_credit_applied:return true
	var credit:int=0
	for level in range(1,highest_level_completed+1):
		var value:Variant=rewards.get(level,null)
		if typeof(value)!=TYPE_INT or value<0:return false
		credit+=value
	var before:int=equipment_points
	equipment_points+=credit
	points_legacy_credit_applied=true
	if save_progress():return true
	equipment_points=before
	points_legacy_credit_applied=false
	return false

func equipment_state()->EquipmentPoints:
	var state:=EquipmentPoints.new()
	state.balance=equipment_points
	state.owned.assign(equipment_owned)
	state.equipped=equipment_equipped.duplicate()
	return state

func buy_equipment(item_id:String)->bool:
	var state:=equipment_state()
	if not state.buy(item_id,EquipmentCatalog.ITEMS):return false
	var before:int=equipment_points
	var before_owned:Array[String]=equipment_owned.duplicate()
	equipment_points=state.balance
	equipment_owned.assign(state.owned)
	if save_progress():return true
	equipment_points=before
	equipment_owned=before_owned
	return false

func equip_item(item_id:String)->bool:
	var state:=equipment_state()
	if not state.equip(item_id,EquipmentCatalog.ITEMS):return false
	var before:Dictionary=equipment_equipped.duplicate()
	equipment_equipped=state.equipped
	if save_progress():return true
	equipment_equipped=before
	return false

func equipped_whip_reach()->float:
	var item_id:String=equipment_equipped.get("whip","")
	if not equipment_owned.has(item_id) or not EquipmentCatalog.ITEMS.has(item_id):return 0.0
	return float(EquipmentCatalog.ITEMS[item_id].get("reach",0.0))

func record_victory(level_number:int,training_session:Dictionary={})->int:
	if trial_session_active:return 0 # no temporary victory becomes an acquisition
	if level_number<1 or level_number>LevelCatalog.MAX_LEVEL:return 0
	if not apply_legacy_points_credit(EquipmentCatalog.REWARDS):return 0
	var reward:int=int(EquipmentCatalog.REWARDS.get(level_number,0))
	var before_horses:Dictionary=horse_collection.export_state()
	var before_highest:int=highest_level_completed
	var before_points:int=equipment_points
	if level_number>highest_level_completed:horse_collection.grant_achievement(level_number)
	highest_level_completed=maxi(highest_level_completed,level_number)
	equipment_points+=reward
	horse_collection.birth_credits+=1
	HorseTraining.complete(horse_collection,training_session)
	if save_progress():return reward
	horse_collection.restore(before_horses)
	highest_level_completed=before_highest
	equipment_points=before_points
	return 0

## Cosmetic selection is independent of points and functional equipment.
func select_hat(value:String)->bool:
	if not HatAppearance.OPTIONS.has(value):return false
	var before:String=hat_color
	hat_color=value
	if save_progress():return true
	hat_color=before
	return false

## Trial only: no point charges, no consumed parents. Atomic save rollback.
func breed_horses(a:String,b:String,choices:Dictionary)->Dictionary:
	if not debug_mode and not trial_session_active and horse_collection.birth_credits<=0:return {}
	var before:Dictionary=horse_collection.export_state()
	var child:Dictionary=horse_collection.breed(a,b,choices)
	if child.is_empty():return {}
	if not debug_mode and not trial_session_active:horse_collection.birth_credits-=1
	if save_progress():return child
	horse_collection.restore(before)
	return {}
func select_horse(id:String)->bool:
	if not horse_collection.is_adult(id):return false
	var before:String=horse_collection.selected
	horse_collection.selected=id
	if save_progress():return true
	horse_collection.selected=before
	return false

func rename_horse(id:String,value:String)->bool:
	var h:Dictionary=horse_collection.find(id)
	if h.is_empty():return false
	var before:String=h.name
	if not horse_collection.rename_horse(id,value):return false
	if save_progress():return true
	h.name=before
	return false

func mature_horse_trial(id:String)->bool:
	var before:Dictionary=horse_collection.export_state()
	if not horse_collection.mature_trial(id):return false
	if save_progress():return true
	horse_collection.restore(before)
	return false

# Explicit scratch session. Snapshot is never serialized; restart loads the real file.
var trial_session_active:bool=false
var _trial_snapshot:Dictionary={}
func begin_trial_session()->bool:
	if not GameState.trial_tools_enabled() or trial_session_active:return false
	for key in ["hat_color","highest_level_completed","equipment_points","equipment_owned","equipment_equipped","points_legacy_credit_applied","dual_lasso_intro_shown"]:
		var v:Variant=get(key);_trial_snapshot[key]=v.duplicate(true) if v is Array or v is Dictionary else v
	_trial_snapshot.horses=horse_collection.export_state()
	trial_session_active=true
	horse_collection=HorseCollection.new();horse_collection.restore(_trial_snapshot.horses)
	horse_collection.add_trial_parents()
	equipment_owned.assign(EquipmentCatalog.ITEMS.keys());equipment_equipped={"whip":"whip_basic"}
	dual_lasso_intro_shown=true
	return true
func end_trial_session()->void:
	if not trial_session_active:return
	for key in _trial_snapshot:
		if key!="horses":set(key,_trial_snapshot[key])
	horse_collection=HorseCollection.new();horse_collection.restore(_trial_snapshot.horses)
	_trial_snapshot.clear();trial_session_active=false
func effective_progress()->int:
	return LevelCatalog.MAX_LEVEL if trial_session_active or debug_mode else highest_level_completed
func preview_trial_traits(coat:int,pattern:int,mane:int,eyes:int=10,finish:String="normal")->bool:
	if not trial_session_active and not debug_mode:return false
	var t:Dictionary={"coat":coat,"pattern":pattern,"mane":mane,"eyes":eyes,"finish":finish}
	if not horse_collection.valid_traits(t):return false
	var h:Dictionary=horse_collection.find("preview_temporary")
	if h.is_empty():
		h={"id":"preview_temporary","name":"Aspecto prestado · BASE","parents":[],"stage":"adult","stats":HorseStats.BASE.duplicate(),"traits":t}
		horse_collection.horses.append(h)
	else:h.traits=t
	horse_collection.selected=h.id
	return save_progress()

# Each mode owns a different file. Switching saves the departing mode first.
func switch_mode(want_debug:bool)->bool:
	if debug_mode==want_debug:return true
	var target_path:String=debug_mode_path if want_debug else normal_mode_path
	if FileAccess.file_exists(target_path):
		var check:=ConfigFile.new()
		if check.load(target_path)!=OK or not check.has_section_key("progress","highest_level_completed"):return false
		var verify:=HorseCollection.new()
		if not verify.restore(check.get_value("horses_trial","state",{})):return false
	if trial_session_active:end_trial_session()
	if not save_progress():return false
	var old_path:String=save_path
	var old_debug:bool=debug_mode
	debug_mode=want_debug
	save_path=debug_mode_path if debug_mode else normal_mode_path
	load_progress()
	if debug_mode and not FileAccess.file_exists(target_path):
		horse_collection.add_trial_parents()
		equipment_owned.assign(EquipmentCatalog.ITEMS.keys());equipment_equipped={"whip":"whip_basic"}
	if save_progress():return true
	debug_mode=old_debug;save_path=old_path;load_progress();return false

## Internal game currency only. Persist both sides or restore both on failure.
func buy_market_horse(offer:Dictionary)->bool:
	if not horse_collection.valid_traits(offer.get("traits")):return false
	if not debug_mode and not trial_session_active and not HorseMarket.available(horse_collection,offer,highest_level_completed):return false
	var price:int=0 if debug_mode or trial_session_active else HorseMarket.buy_price(offer)
	if equipment_points<price:return false
	var before:Dictionary=horse_collection.export_state();var points:int=equipment_points
	if HorseMarket.buy(horse_collection,offer).is_empty():return false
	equipment_points-=price
	if not debug_mode and not trial_session_active:horse_collection.bought_offers.append(str(offer.offer_id))
	if save_progress():return true
	horse_collection.restore(before);equipment_points=points;return false
func sell_market_horse(id:String)->bool:
	if not HorseMarket.can_sell(horse_collection,id):return false
	var price:int=HorseMarket.sell_price(horse_collection.find(id));var before:Dictionary=horse_collection.export_state();var points:int=equipment_points
	if not HorseMarket.sell(horse_collection,id):return false
	equipment_points+=price
	if save_progress():return true
	horse_collection.restore(before);equipment_points=points;return false

func set_training_pair(mentor:String,learner:String,skill:String)->bool:
	var before:Dictionary=horse_collection.export_state()
	if not HorseTraining.configure(horse_collection,mentor,learner,skill):return false
	if save_progress():return true
	horse_collection.restore(before);return false
func clear_training_pair()->bool:
	var before:Dictionary=horse_collection.training_pair.duplicate(true);horse_collection.training_pair={}
	if save_progress():return true
	horse_collection.training_pair=before;return false

func set_horse_emblem(id:String,config:Dictionary)->bool:
	var horse:Dictionary=horse_collection.find(id)
	if horse.is_empty() or (not config.is_empty() and not HorseEmblem.valid(config)):return false
	var before:Dictionary=horse_collection.export_state()
	if config.is_empty():horse.traits.erase("emblem")
	else:horse.traits["emblem"]=config.duplicate(true)
	if save_progress():return true
	horse_collection.restore(before);return false

## --- Frontera (bounded open-world test) ---

func ensure_world_seed() -> int:
	if world_seed == 0:
		world_seed = int(randi()) + 1
		save_progress()
	return world_seed

func save_world_state(pos: Vector2) -> bool:
	world_position = pos
	return save_progress()

func mark_world_discovered(key: String) -> void:
	if not world_discovered.has(key):
		world_discovered.append(key)

func mark_world_tamed(key: String) -> void:
	if not world_tamed.has(key):
		world_tamed.append(key)

func set_world_mission(id: String, state: String) -> bool:
	if id.is_empty() or state not in ["offered", "done"]:
		return false
	world_missions[id] = state
	return true

## A tamed wild horse joins the stable as an adult and keeps its own Serenidad.
## Rolls back on a failed save, like every other mutation here.
func adopt_wild_horse(herd: Dictionary) -> Dictionary:
	if not herd.get("traits") is Dictionary or not horse_collection.valid_traits(herd.traits):
		return {}
	var before: Dictionary = horse_collection.export_state()
	var n: int = 1
	while not horse_collection.find("wild_%d" % n).is_empty():
		n += 1
	var horse: Dictionary = {"id": "wild_%d" % n, "parents": [], "stage": "adult", "traits": herd.traits.duplicate(true), "stats": {"calm": clampf(HorseStats.number(herd.get("calm", 1.0), 1.0), 0.5, 2.0)}}
	horse.name = horse_collection.suggest_name(horse.traits)
	horse_collection.horses.append(horse)
	if save_progress():
		return horse
	horse_collection.restore(before)
	return {}
