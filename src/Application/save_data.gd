extends Node

## Persistent progression (Autoload — see project.godot [autoload]).
## Single tracked value: highest level completed. Every unlock is derived from this —
## no currency, no shop (PROJECT_SPEC.md explicitly excludes a complex economy from MVP).
## Persisted data is validated on load (LevelProgression.sanitize_highest_completed) and
## written atomically (temp file + rename) so an interrupted write cannot corrupt the save.

const SAVE_PATH: String = "user://save.dat"
const SAVE_VERSION: int = 2  ## bump when the file layout changes, to allow migrations

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
# Overridden only by isolated persistence tests; production retains its original path.
var save_path: String = SAVE_PATH

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
	var config := ConfigFile.new()
	config.set_value("meta", "version", SAVE_VERSION)
	config.set_value("progress", "highest_level_completed", highest_level_completed)
	config.set_value("progress", "dual_lasso_intro_shown", dual_lasso_intro_shown)
	config.set_value("appearance", "hat_color", hat_color)
	config.set_value("horses_trial", "state", horse_collection.export_state())
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

func load_progress() -> void:
	horse_collection=HorseCollection.new()
	horse_collection.seed_trial()
	hat_color = "original"
	equipment_points = 0
	equipment_owned.clear()
	equipment_equipped.clear()
	points_legacy_credit_applied = false
	var config := ConfigFile.new()
	var err: Error = config.load(save_path)
	if err != OK:
		dual_lasso_intro_shown = false
		highest_level_completed = 0  # first run (no file) or unreadable file
		return
	horse_collection.restore(config.get_value("horses_trial","state",{}))
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

func record_victory(level_number:int)->int:
	if level_number<1 or level_number>LevelCatalog.MAX_LEVEL:return 0
	if not apply_legacy_points_credit(EquipmentCatalog.REWARDS):return 0
	var reward:int=int(EquipmentCatalog.REWARDS.get(level_number,0))
	var before_horses:Dictionary=horse_collection.export_state()
	var before_highest:int=highest_level_completed
	var before_points:int=equipment_points
	if level_number>highest_level_completed:horse_collection.grant_achievement(level_number)
	highest_level_completed=maxi(highest_level_completed,level_number)
	equipment_points+=reward
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
	var before:Dictionary=horse_collection.export_state()
	var child:Dictionary=horse_collection.breed(a,b,choices)
	if child.is_empty():return {}
	if save_progress():return child
	horse_collection.restore(before)
	return {}
func select_horse(id:String)->bool:
	if horse_collection.find(id).is_empty():return false
	var before:String=horse_collection.selected
	horse_collection.selected=id
	if save_progress():return true
	horse_collection.selected=before
	return false
