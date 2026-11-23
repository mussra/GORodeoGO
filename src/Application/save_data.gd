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

const NORMAL_SAVE_PATH:String="user://save-normal-progress240.dat"
const DEBUG_SAVE_PATH:String="user://save-debug-progress240.dat"
var _load_valid:bool=true
var cosmetic_protected332:bool=false
var cosmetic_changes332:Array=[]
var cosmetic_notices332:Dictionary={}
var auto_recovery333:bool=true
var recovery_backup333:String=""
var recovery_details333:Array=[]
var recovery_error333:String=""
func take_cosmetic_notice332()->String:
	if not recovery_details333.is_empty() and not cosmetic_notices332.has(save_path):
		cosmetic_notices332[save_path]=true
		return "Se ha recuperado la apariencia y esta es la partida activa. Cambios: "+", ".join(recovery_details333)+". Copia original intacta: "+recovery_backup333+". Puedes continuar y guardar con normalidad."
	if cosmetic_changes332.is_empty() or cosmetic_notices332.has(save_path):return ""
	cosmetic_notices332[save_path]=true
	return "Se han sustituido valores de apariencia no reconocidos (%d) por valores por defecto, solo en memoria. La partida original está intacta y protegida. En esta sesión no se guardarán cambios. Antes de continuar, consulta Ajustes > Diagnóstico de guardado."%cosmetic_changes332.size()

var debug_mode:bool=false
var normal_mode_path:String=NORMAL_SAVE_PATH
var debug_mode_path:String=DEBUG_SAVE_PATH
var horse_collection:HorseCollection = HorseCollection.new()
var hat_color: String = "original"
var hat_designs235:Dictionary={}
var world_bull_returns269:Dictionary={}
var pending_bull_returns269:Dictionary={}
var rodeo_intro240:bool=false
var victories240:Dictionary=ModeVictories240.fresh()
var _issued240:int=0
var pending_victory240:Dictionary={}
var last_growth251:Dictionary={}
func take_growth251()->Dictionary:
	var result:=last_growth251;last_growth251={};return result
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
var world_generator_version:int=1 # missing field means legacy; only new worlds use v2
var story_intro319:bool=false
var world_seed: int = 0
var world_discovered: Array[String] = []
var world_tamed: Array[String] = []
var world_position: Vector2 = Vector2(0, 160)
var world_places144:Dictionary={}
var siesta_rest166:float=0.
var repeat_contract165:Dictionary=ProgressionEconomy165.new_contract()
var country_ledger146:Dictionary={} # Separate future-country progress; no entry enabled yet.
var world_herd_town217:Dictionary={}
var world_cousins140:Dictionary={} # Four-town journal, separate additive V3 state.
var world_roaming139:Dictionary={} # Moved individuals, sparse/current-chunk indexed at runtime.
var world_garden212:Dictionary=Garden212.fresh()
var world_flora138:Dictionary={} # Separate versioned expansion, never rewrites inherited quests.
var world_jobs249:Dictionary={}
var interior_search264:Dictionary={}
var world_goats_given249:int=0
var world_quests:Dictionary={} # NPC quest states; old captures are never retro-counted
var world_missions: Dictionary = {}  # mission id -> "offered" / "encargo" / "done"
var world_pigs: Array[String] = []  # captured pig-pen ids ("pig_cx_cy")
var world_notes106:Dictionary={} # region -> compact annotation rows, photo bytes separate
var world_notes_revision106:int=0
var world_pig_captures:Array[String]=[] # individual IDs, new captures only
var world_pigs_sold:int=0
var world_goat_captures:Array[String]=[]
var world_edits: Array = []  # world-editor ops (see WorldEdits), layered over the seed
# Overridden only by isolated persistence tests; production retains its original path.
var save_path: String = NORMAL_SAVE_PATH

var slots334:SaveSlots334
func _ready() -> void:
	slots334=SaveSlots334.new()
	if not slots334.setup(NORMAL_SAVE_PATH,DEBUG_SAVE_PATH):
		_load_valid=false;save_error330=slots334.error;return
	slots334.attach(self)
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

var save_error330:String=""
var save_metrics242:Dictionary={"calls":0,"failures":0,"last_usec":0,"max_usec":0,"last_bytes":0}
func save_progress() -> bool:
	var started:int=Time.get_ticks_usec()
	var actual_write:bool=not trial_session_active
	save_error330=""
	var ok:bool=_save_progress242()
	if ok and actual_write:
		world_bull_returns269.merge(pending_bull_returns269,true);pending_bull_returns269.clear()
	if actual_write:
		var elapsed:int=Time.get_ticks_usec()-started
		save_metrics242.calls+=1;save_metrics242.last_usec=elapsed
		save_metrics242.max_usec=maxi(save_metrics242.max_usec,elapsed)
		if not ok:save_metrics242.failures+=1
		elif FileAccess.file_exists(save_path):
			var file:=FileAccess.open(save_path,FileAccess.READ)
			if file!=null:save_metrics242.last_bytes=file.get_length()
	return ok

func _save_progress242() -> bool:
	if cosmetic_protected332:
		save_error330="G04 · Apariencia recuperada solo en memoria. El original sigue protegido."
		return false
	if not _load_valid:
		save_error330="G01 · Partida protegida: la lectura no superó la validación."
		return false # retain unreadable source instead of replacing it with defaults
	if trial_session_active:return true # in-memory selections only, never touch real save
	var config := ConfigFile.new()
	config.set_value("meta", "version", SAVE_VERSION)
	config.set_value("progress","story_intro319",story_intro319)
	config.set_value("progress","victories240",victories240)
	config.set_value("progress","rodeo_intro240",rodeo_intro240)
	var returned269:Dictionary=world_bull_returns269.duplicate(true);returned269.merge(pending_bull_returns269,true)
	config.set_value("world","bull_returns269",returned269)
	config.set_value("progress", "highest_level_completed", highest_level_completed)
	config.set_value("progress", "dual_lasso_intro_shown", dual_lasso_intro_shown)
	if horse_collection.horses.is_empty():horse_collection.seed_trial()
	# Validate generated snapshots before the atomic replacement. No relaxed readers.
	var candidate:=HorseCollection.new()
	if not world_position.is_finite() or world_pigs_sold<0 or world_pigs_sold>world_pig_captures.size() or world_goats_given249<0 or world_goats_given249>world_goat_captures.size() or world_generator_version not in [1,2,3,4,5,6] or equipment_points<0 or world_seed<0 or repeat_contract165.get("version",0)!=ProgressionEconomy165.VERSION or world_garden212.get("version",0)!=Garden212.VERSION or not candidate.restore(horse_collection.export_state()) or not ModeVictories240.valid(victories240) or (not world_herd_town217.is_empty() and not HerdTown217.valid(world_herd_town217,world_seed)) or (not country_ledger146.is_empty() and not CountryLedger146.valid(country_ledger146,world_seed,world_generator_version)):
		save_error330="G05 · Los datos nuevos no superan la validación. Archivo anterior intacto."
		return false
	for ids332 in [world_pig_captures,world_goat_captures]:
		if WorldLivestock104.valid_ids(ids332).size()!=ids332.size():save_error330="G05 · Registro de capturas no válido. Archivo anterior intacto.";return false
	for key332 in ["crops","seeds","harvests"]:
		var count332:Variant=world_garden212.get(key332,0)
		if not count332 is int or count332<0 or count332>9999:save_error330="G05 · Inventario del jardín no válido. Archivo anterior intacto.";return false
	var next_hat_designs235:=HatDesigns235.collect(hat_designs235,horse_collection)
	config.set_value("appearance","hat_designs235",next_hat_designs235)
	config.set_value("appearance", "hat_color", hat_color)
	config.set_value("horses_trial", "state", horse_collection.export_state())
	config.set_value("world", "seed", world_seed)
	config.set_value("world", "generator_version", world_generator_version)
	config.set_value("world", "discovered", world_discovered)
	config.set_value("world", "tamed", world_tamed)
	config.set_value("world", "position", world_position)
	config.set_value("world", "quests", world_quests)
	config.set_value("world","jobs249",world_jobs249)
	config.set_value("world","interior_search264",interior_search264)
	config.set_value("world","goats_given249",world_goats_given249)
	config.set_value("world","flora138",world_flora138)
	config.set_value("world","garden212",world_garden212)
	config.set_value("world","roaming139",world_roaming139)
	config.set_value("world","cousins140",world_cousins140)
	config.set_value("world","herd_town217",world_herd_town217)
	config.set_value("world","places144",world_places144)
	config.set_value("world","siesta_rest166",siesta_rest166)
	config.set_value("world","repeat_contract165",repeat_contract165)
	config.set_value("world","countries146",country_ledger146)
	config.set_value("world", "missions", world_missions)
	config.set_value("world", "pigs", world_pigs)
	config.set_value("world","notes106",world_notes106)
	config.set_value("world","pig_captures",world_pig_captures)
	config.set_value("world","pigs_sold",world_pigs_sold)
	config.set_value("world","goat_captures",world_goat_captures)
	config.set_value("world", "edits", world_edits)
	config.set_value("equipment", "points", equipment_points)
	config.set_value("equipment", "owned", equipment_owned)
	config.set_value("equipment", "equipped", equipment_equipped)
	config.set_value("equipment", "legacy_credit_applied", points_legacy_credit_applied)
	var temp_path: String = save_path + ".tmp"
	var err: Error = config.save(temp_path)
	if err == OK:
		err = DirAccess.rename_absolute(temp_path, save_path)
		if err!=OK:save_error330="G03 · No se pudo confirmar el archivo: "+error_string(err)
	else:save_error330="G02 · No se pudo escribir el archivo temporal: "+error_string(err)
	if err != OK:
		push_error("SaveData: could not save progress (error %d)." % err)
		return false
	hat_designs235=next_hat_designs235
	return true

static func load_source_path(current:String,legacy:String)->String:
	# An unreadable new save must not silently fall back to stale progress.
	return current if FileAccess.file_exists(current) else legacy

func load_progress() -> void:
	_load_valid=true
	cosmetic_protected332=false;cosmetic_changes332.clear()
	if trial_session_active:end_trial_session()
	horse_collection=HorseCollection.new()
	horse_collection.seed_trial()
	hat_color = "original"
	hat_designs235={}
	equipment_points = 0
	equipment_owned.clear()
	equipment_equipped.clear()
	points_legacy_credit_applied = false
	story_intro319=false
	world_seed = 0
	world_generator_version=1
	world_discovered.clear()
	world_tamed.clear()
	world_position = Vector2(0, 160)
	world_bull_returns269={};pending_bull_returns269={}
	rodeo_intro240=false
	victories240=ModeVictories240.fresh();_issued240=0;pending_victory240.clear()
	world_quests.clear();world_jobs249.clear();interior_search264.clear();world_goats_given249=0
	world_flora138.clear()
	world_garden212=Garden212.fresh()
	world_roaming139.clear()
	world_cousins140.clear();world_herd_town217.clear()
	world_places144.clear();siesta_rest166=0.;repeat_contract165=ProgressionEconomy165.new_contract()
	country_ledger146.clear()
	world_missions.clear()
	world_pigs.clear()
	world_notes106.clear();world_notes_revision106+=1
	world_pig_captures.clear();world_pigs_sold=0;world_goat_captures.clear()
	world_edits.clear()
	var config := ConfigFile.new()
	var source_path:String=load_source_path(save_path,LEGACY_2_SAVE_PATH) if save_path==SAVE_PATH else save_path
	if save_path=="user://save-normal-v4.dat" and not FileAccess.file_exists(save_path):source_path=load_source_path(SAVE_PATH,LEGACY_2_SAVE_PATH) # legacy-only fallback, never for fresh progress240
	var err: Error = config.load(source_path)
	if err != OK:
		_load_valid=not FileAccess.file_exists(source_path)
		dual_lasso_intro_shown = false
		highest_level_completed = 0  # first run (no file) or unreadable file
		return
	if not config.has_section_key("progress","highest_level_completed"):
		_load_valid=false
		return
	# Present malformed critical scalars must not be silently replaced by zero.
	var critical332:Dictionary={"progress":["highest_level_completed"],"equipment":["points"],"world":["seed","pigs_sold","goats_given249"]}
	for section in critical332:
		for key in critical332[section]:
			if config.has_section_key(section,key):
				var value:Variant=config.get_value(section,key)
				if not value is int or value<0:_load_valid=false;return
	if config.has_section_key("horses_trial","state"):
		var raw_horses:Variant=config.get_value("horses_trial","state",{})
		if not horse_collection.restore(raw_horses):
			var recovered:Variant=CosmeticRecovery332.collection(raw_horses,cosmetic_changes332)
			if cosmetic_changes332.is_empty() or not horse_collection.restore(recovered):
				_load_valid=false;cosmetic_changes332.clear();return
			cosmetic_protected332=true
	var raw_hat332:Variant=config.get_value("appearance", "hat_color", "original")
	hat_color = HatAppearance.sanitize(raw_hat332)
	if raw_hat332!=hat_color:cosmetic_changes332.append("hat");cosmetic_protected332=true
	hat_designs235=HatDesigns235.collect(HatDesigns235.clean(config.get_value("appearance","hat_designs235",{})),horse_collection)
	# Keep old equipped cosmetics on load, without granting every catalogue item.
	if hat_color.begins_with("hat:"):hat_designs235[hat_color]=true
	highest_level_completed = LevelProgression.sanitize_highest_completed(
		config.get_value("progress", "highest_level_completed", 0)
	)
	GalaxyKeys173.migrate(horse_collection,highest_level_completed)
	story_intro319=config.get_value("progress","story_intro319",false)==true
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
	var generator:Variant=config.get_value("world","generator_version",1)
	if typeof(generator)!=TYPE_INT or generator not in [1,2,3,4,5,6]:
		_load_valid=false;return
	world_generator_version=generator
	for pair in [["discovered",world_discovered],["tamed",world_tamed],["pigs",world_pigs]]:
		var raw:Variant=config.get_value("world",pair[0],[])
		if raw is Array or raw is PackedStringArray:
			for item in raw:
				if typeof(item)==TYPE_STRING and not pair[1].has(item):pair[1].append(item)
	world_notes106=WorldNotes106.clean(config.get_value("world","notes106",{}));world_notes_revision106+=1
	for key332 in ["pig_captures","goat_captures"]:
		var ids332:Variant=config.get_value("world",key332,[])
		if not ids332 is Array and not ids332 is PackedStringArray:_load_valid=false;return
		if WorldLivestock104.valid_ids(ids332).size()!=ids332.size():_load_valid=false;return
	world_pig_captures=WorldLivestock104.valid_ids(config.get_value("world","pig_captures",[]))
	world_goat_captures=WorldLivestock104.valid_ids(config.get_value("world","goat_captures",[]))
	var sold:Variant=config.get_value("world","pigs_sold",0)
	if sold>world_pig_captures.size():_load_valid=false;return
	world_pigs_sold=clampi(sold,0,world_pig_captures.size()) if sold is int else 0
	var wpos:Variant=config.get_value("world","position",world_position)
	if not wpos is Vector2 or not wpos.is_finite():_load_valid=false;return
	world_position=wpos
	var we:Variant=config.get_value("world","edits",[])
	world_edits.clear()
	if typeof(we)==TYPE_ARRAY:
		for op in we:
			if WorldEdits.valid_op(op):world_edits.append(op)
	world_bull_returns269=clean_bull_returns269(config.get_value("world","bull_returns269",{}));pending_bull_returns269.clear()
	rodeo_intro240=config.get_value("progress","rodeo_intro240",false)==true
	var victory_raw:Variant=config.get_value("progress","victories240",ModeVictories240.fresh())
	if not ModeVictories240.valid(victory_raw):
		_load_valid=false;return
	victories240=victory_raw.duplicate(true);_issued240=victories240.last;pending_victory240.clear()
	world_quests=NpcQuests.clean(config.get_value("world","quests",{}))
	world_jobs249=TownJobs249.clean(config.get_value("world","jobs249",{}),world_seed)
	var search_raw264:Variant=config.get_value("world","interior_search264",{})
	interior_search264=search_raw264 if search_raw264 is Dictionary else {}
	var given332:int=config.get_value("world","goats_given249",0)
	if given332>world_goat_captures.size():_load_valid=false;return
	world_goats_given249=given332
	world_flora138=FloristJourney138.clean(config.get_value("world","flora138",{}))
	var garden_raw:Variant=config.get_value("world","garden212",{})
	if not garden_raw is Dictionary or (not garden_raw.is_empty() and garden_raw.get("version",0)!=Garden212.VERSION):
		_load_valid=false;return
	for key332 in ["crops","seeds","harvests"]:
		var count_value332:Variant=garden_raw.get(key332,0)
		if not count_value332 is int or count_value332<0 or count_value332>9999:_load_valid=false;return
	world_garden212=Garden212.clean(garden_raw)
	world_roaming139=WorldHerdPositions139.clean(config.get_value("world","roaming139",{}),world_seed)
	var count332:int=cosmetic_changes332.size()
	var recovered_towns332:Variant=CosmeticRecovery332.towns(config.get_value("world","cousins140",{}),cosmetic_changes332)
	world_cousins140=VillageCousins140.clean(recovered_towns332,world_seed)
	if cosmetic_changes332.size()>count332:cosmetic_protected332=true
	var herd_policy:Variant=config.get_value("world","herd_town217",{})
	if not herd_policy is Dictionary:_load_valid=false;return
	var old_count:int=cosmetic_changes332.size()
	herd_policy=CosmeticRecovery332.policy(herd_policy,cosmetic_changes332)
	if not herd_policy.is_empty() and not HerdTown217.valid(herd_policy,world_seed):_load_valid=false;return
	if old_count<cosmetic_changes332.size():cosmetic_protected332=true
	world_herd_town217=herd_policy.duplicate(true)
	var raw_places335:Variant=config.get_value("world","places144",{})
	if raw_places335 is Dictionary and raw_places335.has("return335") and (not raw_places335.return335 is Vector2 or not raw_places335.return335.is_finite()):_load_valid=false;return
	world_places144=WorldPlaces144.clean(raw_places335,world_seed,world_generator_version)
	siesta_rest166=SiestaRest166.clean(config.get_value("world","siesta_rest166",0.))
	var contract165:Variant=config.get_value("world","repeat_contract165",ProgressionEconomy165.new_contract())
	if not contract165 is Dictionary or contract165.get("version",0)!=ProgressionEconomy165.VERSION:
		_load_valid=false;return
	repeat_contract165=ProgressionEconomy165.clean(contract165)
	var countries:Variant=config.get_value("world","countries146",{})
	if not countries is Dictionary or (not countries.is_empty() and not CountryLedger146.valid(countries,world_seed,world_generator_version)):
		_load_valid=false;return # Preserve unknown/corrupt future-country data instead of replacing it.
	country_ledger146={} if countries.is_empty() else CountryLedger146.upgrade(countries)
	var wm:Variant=config.get_value("world","missions",{})
	if typeof(wm)==TYPE_DICTIONARY:
		for id in wm:
			if typeof(id)==TYPE_STRING and wm[id] in ["offered","encargo","done"]:world_missions[id]=wm[id]

	if cosmetic_protected332 and auto_recovery333:_recover_cosmetics333(config,source_path)

func _recover_cosmetics333(source:ConfigFile,source_path:String)->bool:
	recovery_error333=""
	# Reserve a new directory atomically. No existing backup is ever opened for writing.
	var folder:String=save_path+".backup-"+str(Time.get_unix_time_from_system()).replace(".","-")+"-"+str(Time.get_ticks_usec())
	if DirAccess.make_dir_absolute(folder)!=OK:
		recovery_error333="R01 · No se pudo reservar una copia única. El original sigue protegido.";return false
	var backup:String=folder+"/original.cfg"
	var bytes:PackedByteArray=FileAccess.get_file_as_bytes(source_path)
	var original_hash:String=FileAccess.get_sha256(source_path)
	if bytes.is_empty() or original_hash.is_empty():recovery_error333="R02 · No se pudo leer el original para la copia.";return false
	var file:=FileAccess.open(backup,FileAccess.WRITE)
	if file==null:recovery_error333="R03 · No se pudo escribir la copia.";return false
	file.store_buffer(bytes);file.flush();var error:Error=file.get_error();file.close()
	if error!=OK or FileAccess.get_sha256(backup)!=original_hash or FileAccess.get_file_as_bytes(backup)!=bytes:
		recovery_error333="R04 · La copia no coincide. El original sigue protegido.";return false
	var copied_source:=ConfigFile.new()
	if copied_source.load(backup)!=OK or not _configs_equal333(source,copied_source):
		recovery_error333="R05 · La lectura y la copia difieren. Original intacto.";return false
	# Patch the original ConfigFile, not a re-export of normalized gameplay data.
	var candidate:=ConfigFile.new()
	if candidate.parse(source.encode_to_text())!=OK:recovery_error333="R05 · No se pudo preparar la corrección.";return false
	var changes:Array=[]
	if candidate.has_section_key("horses_trial","state"):candidate.set_value("horses_trial","state",CosmeticRecovery332.collection(candidate.get_value("horses_trial","state"),changes))
	for key in ["cousins140","herd_town217"]:
		if candidate.has_section_key("world",key):
			var raw:Variant=candidate.get_value("world",key)
			candidate.set_value("world",key,CosmeticRecovery332.towns(raw,changes) if key=="cousins140" else CosmeticRecovery332.policy(raw,changes))
	if candidate.has_section_key("appearance","hat_color"):candidate.set_value("appearance","hat_color",HatAppearance.sanitize(candidate.get_value("appearance","hat_color")))
	var details:Array=[]
	for section in source.get_sections():
		for key in source.get_section_keys(section):_recovery_diff333(source.get_value(section,key),candidate.get_value(section,key),section+"/"+key,details)
	if details.is_empty():recovery_error333="R06 · No se encontró una corrección cosmética verificable.";return false
	var staged:String=folder+"/corrected.cfg"
	if candidate.save(staged)!=OK:recovery_error333="R07 · No se pudo escribir el candidato. Original intacto.";return false
	var reloaded:=ConfigFile.new()
	if reloaded.load(staged)!=OK or not _configs_equal333(candidate,reloaded):recovery_error333="R08 · El candidato cambió al recargar. Original intacto.";return false
	var verify:Node=get_script().new();verify.auto_recovery333=false;verify.save_path=staged;verify.load_progress()
	var valid_:bool=verify._load_valid and not verify.cosmetic_protected332
	verify.free()
	if not valid_:recovery_error333="R09 · La corrección no supera la validación completa. Original intacto.";return false
	if FileAccess.get_sha256(source_path)!=original_hash or FileAccess.get_sha256(backup)!=original_hash:
		recovery_error333="R10 · El original o la copia cambiaron durante la comprobación.";return false
	if DirAccess.rename_absolute(staged,save_path)!=OK:recovery_error333="R11 · No se pudo activar la corrección. Original intacto.";return false
	# The committed file is the exact candidate already validated above.
	var old_auto:bool=auto_recovery333;auto_recovery333=false;load_progress();auto_recovery333=old_auto
	recovery_backup333=backup;recovery_details333=details
	return _load_valid and not cosmetic_protected332

static func _configs_equal333(a:ConfigFile,b:ConfigFile)->bool:
	if a.get_sections()!=b.get_sections():return false
	for section in a.get_sections():
		if a.get_section_keys(section)!=b.get_section_keys(section):return false
		for key in a.get_section_keys(section):
			if a.get_value(section,key)!=b.get_value(section,key):return false
	return true
static func _recovery_diff333(a:Variant,b:Variant,path_:String,out:Array)->void:
	if a==b:return
	if a is Dictionary and b is Dictionary and a.keys()==b.keys():
		for key in a:_recovery_diff333(a[key],b[key],path_+"/"+str(key),out)
	elif a is Array and b is Array and a.size()==b.size():
		for i in a.size():_recovery_diff333(a[i],b[i],path_+"/"+str(i),out)
	else:out.append(path_+" → "+str(b))

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

func unequip_cosmetic243(slot:String)->bool:
	if slot not in ["cosmetic_hat","cosmetic_blanket"]:return false
	if not equipment_equipped.has(slot):return false
	var before:Dictionary=equipment_equipped.duplicate()
	equipment_equipped.erase(slot)
	if save_progress():return true
	equipment_equipped=before
	return false

func equipped_whip_reach()->float:
	var item_id:String=equipment_equipped.get("whip","")
	if not equipment_owned.has(item_id) or not EquipmentCatalog.ITEMS.has(item_id):return 0.0
	return float(EquipmentCatalog.ITEMS[item_id].get("reach",0.0))

var rodeo_saved241:bool=false
func record_victory(level_number:int,training_session:Dictionary={},mounted_horse_id:String="")->int:
	rodeo_saved241=false;last_growth251={}
	if trial_session_active:return 0 # no temporary victory becomes an acquisition
	if level_number<1 or level_number>LevelCatalog.MAX_LEVEL:return 0
	if not apply_legacy_points_credit(EquipmentCatalog.REWARDS):return 0
	var reward:int=ProgressionEconomy165.victory_points(level_number,highest_level_completed)
	var before_horses:Dictionary=horse_collection.export_state()
	var before_victories:Dictionary=victories240.duplicate(true)
	_issued240=maxi(_issued240,victories240.last)+1
	ModeVictories240.record(victories240,"bulls",_issued240)
	var before_highest:int=highest_level_completed
	var before_points:int=equipment_points
	GalaxyKeys173.migrate(horse_collection,highest_level_completed)
	if level_number>highest_level_completed and level_number not in [20,40]:horse_collection.grant_achievement(level_number)
	highest_level_completed=maxi(highest_level_completed,level_number)
	equipment_points+=reward
	horse_collection.birth_credits+=1
	FoalGrowth174.advance(horse_collection)
	HorseTraining.complete(horse_collection,training_session)
	HorseMastery.record(horse_collection,mounted_horse_id,level_number)
	var growth_id:String=mounted_horse_id if not mounted_horse_id.is_empty() else horse_collection.selected
	var growth:=VictoryGrowth251.apply(horse_collection,growth_id,"bulls")
	var champion:=VictoryGrowth251.champion(horse_collection,growth_id)
	if not champion.is_empty():growth["champion"]=champion.duplicate(true)
	if not horse_collection.find(growth_id).is_empty():growth["horse"]=horse_collection.find(growth_id).duplicate(true)
	if save_progress():
		last_growth251=growth
		rodeo_saved241=true;return reward
	horse_collection.restore(before_horses)
	victories240=before_victories
	highest_level_completed=before_highest
	equipment_points=before_points
	return 0

## Cosmetic selection is independent of points and functional equipment.
func select_hat(value:String)->bool:
	if HatAppearance.sanitize(value)!=value:return false
	if value.begins_with("hat:") and not HatDesigns235.collect(hat_designs235,horse_collection).has(value):return false
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
func mature_horse174(id:String)->bool:
	var before:Dictionary=horse_collection.export_state()
	if not FoalGrowth174.mature(horse_collection,id):return false
	if save_progress():return true
	horse_collection.restore(before);return false
func select_horse(id:String)->bool:
	if not horse_collection.is_adult(id):return false
	var before:String=horse_collection.selected
	horse_collection.selected=id
	if save_progress():return true
	horse_collection.selected=before
	return false

func horse_editing_allowed()->bool:
	return debug_mode or trial_session_active

func rename_horse(id:String,value:String)->bool:
	if not horse_editing_allowed():return false
	var h:Dictionary=horse_collection.find(id)
	if h.is_empty():return false
	var before:String=h.name
	if not horse_collection.rename_horse(id,value):return false
	if save_progress():return true
	h.name=before
	return false

func mature_horse_trial(id:String)->bool:
	if not horse_editing_allowed():return false
	var before:Dictionary=horse_collection.export_state()
	if not horse_collection.mature_trial(id):return false
	if save_progress():return true
	horse_collection.restore(before)
	return false

# Explicit scratch session. Snapshot is never serialized; restart loads the real file.
var trial_session_active:bool=false
var familiarization325:bool=false
var _trial_snapshot:Dictionary={}
func begin_trial_session(enhanced:bool=true)->bool:
	if (enhanced and not GameState.trial_tools_enabled()) or trial_session_active:return false
	for key in ["story_intro319","world_bull_returns269","pending_bull_returns269","interior_search264","rodeo_intro240","victories240","world_herd_town217","world_garden212","repeat_contract165","siesta_rest166","country_ledger146","world_quests","world_jobs249","world_goats_given249","world_pigs_sold","world_pig_captures","world_goat_captures","hat_color","hat_designs235","highest_level_completed","equipment_points","equipment_owned","equipment_equipped","points_legacy_credit_applied","dual_lasso_intro_shown"]:
		var v:Variant=get(key);_trial_snapshot[key]=v.duplicate(true) if v is Array or v is Dictionary else v
	_trial_snapshot.horses=horse_collection.export_state()
	trial_session_active=true;familiarization325=not enhanced
	horse_collection=HorseCollection.new();horse_collection.restore(_trial_snapshot.horses)
	if enhanced:
		horse_collection.add_trial_parents()
		equipment_owned.assign(EquipmentCatalog.ITEMS.keys());equipment_equipped={"whip":"whip_basic"}
	dual_lasso_intro_shown=true
	return true
func end_trial_session()->void:
	if not trial_session_active:return
	for key in _trial_snapshot:
		if key!="horses":set(key,_trial_snapshot[key])
	horse_collection=HorseCollection.new();horse_collection.restore(_trial_snapshot.horses)
	_trial_snapshot.clear();trial_session_active=false;familiarization325=false
func effective_progress()->int:
	return 0 if familiarization325 else LevelCatalog.MAX_LEVEL if trial_session_active or debug_mode else highest_level_completed
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
	if offer.get("traits",{}).get("finish","")=="galaxy" and not debug_mode and not trial_session_active:
		if not GalaxyKeys173.consume(horse_collection,highest_level_completed,int(offer.get("galaxy_key173",0))):return false
	if HorseMarket.buy(horse_collection,offer).is_empty():
		horse_collection.restore(before);return false
	equipment_points-=price
	if not debug_mode and not trial_session_active:horse_collection.bought_offers.append(str(offer.offer_id))
	if save_progress():return true
	horse_collection.restore(before);equipment_points=points;return false
func sell_market_horse(id:String)->bool:
	if not HorseMarket.can_sell(horse_collection,id):return false
	var price:int=HorseMarket.sell_price(horse_collection.find(id));var before:Dictionary=horse_collection.export_state();var points:int=equipment_points
	hat_designs235=HatDesigns235.collect(hat_designs235,horse_collection)
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

func set_horse_pattern_color(id:String,key:String,value:int)->bool:
	if not horse_editing_allowed():return false
	if key not in ["pattern","spots","coat"]:return false
	var horse:Dictionary=horse_collection.find(id)
	if horse.is_empty():return false
	var traits:Dictionary=horse.traits.duplicate(true)
	if key in ["coat","spots"]:
		traits[key+"_style238"]="rainbow" if value==20 else "flat"
		if value!=20:traits[key]=HorseCollection.base239(value)
	else:traits[key]=value
	if traits.get("finish","")=="original":traits["finish"]="normal"
	if not horse_collection.valid_traits(traits):return false
	var before:Dictionary=horse_collection.export_state();horse.traits=traits
	if save_progress():return true
	horse_collection.restore(before);return false

func set_horse_legs(id:String,color:int,mustang:bool=false)->bool:
	if not horse_editing_allowed():return false
	var horse:Dictionary=horse_collection.find(id)
	if horse.is_empty() or color< -1 or color>=HorseCollection.COATS.size():return false
	var before:Dictionary=horse_collection.export_state()
	if color<0:horse.traits.erase("legs")
	else:horse.traits["legs"]=color
	if mustang:
		horse.traits["coat"]=10;horse.traits["mane"]=0;horse.traits["pattern"]=0;horse.traits["finish"]="normal"
	if save_progress():return true
	horse_collection.restore(before);return false

func set_horse_emblem(id:String,config:Dictionary)->bool:
	if not horse_editing_allowed():return false
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
		world_generator_version=6
		world_position=ModularWorldLayout93.world(WorldTerrain103.plan(world_seed).doors.ranch)+Vector2(0,70)
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
	if id.is_empty() or state not in ["offered","encargo","done"]:
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

func pig_inventory104()->int:return WorldLivestock104.available(world_pig_captures,world_pigs_sold)
func record_pig104(id:String)->bool:
	if id.is_empty() or world_pig_captures.has(id):return false
	var before_points:int=equipment_points;var before_quests:Dictionary=world_quests.duplicate(true);var before_contract:Dictionary=repeat_contract165.duplicate(true)
	world_pig_captures.append(id)
	if WorldPigs.CHASE_MODE:equipment_points+=WorldPigs.CHASE_REWARD_POINTS
	NpcQuests.record(world_quests,"capture_animal","pig",id)
	ProgressionEconomy165.record(repeat_contract165,"pig",id)
	if save_progress():return true
	world_pig_captures.erase(id);equipment_points=before_points;world_quests=before_quests;repeat_contract165=before_contract;return false
func sell_pigs104(count:int,expected_unit_price:int)->Dictionary:
	if expected_unit_price!=WorldLivestock104.PIG_SALE_PRICE or count<=0 or count>pig_inventory104():return {}
	var quote:Dictionary=WorldLivestock104.quote(count)
	var before_points:int=equipment_points;var before_sold:int=world_pigs_sold
	world_pigs_sold+=count;equipment_points+=int(quote.total)
	if save_progress():return quote
	world_pigs_sold=before_sold;equipment_points=before_points;return {}
func record_goat104(id:String)->bool:
	if id.is_empty() or world_goat_captures.has(id):return false
	var before:Dictionary=world_quests.duplicate(true);var before_points:int=equipment_points;var before_contract:Dictionary=repeat_contract165.duplicate(true)
	world_goat_captures.append(id);NpcQuests.record(world_quests,"capture_animal","goat",id)
	equipment_points+=ProgressionEconomy165.GOAT_CAPTURE_POINTS;ProgressionEconomy165.record(repeat_contract165,"goat",id)
	if save_progress():return true
	world_goat_captures.erase(id);world_quests=before;equipment_points=before_points;repeat_contract165=before_contract;return false

func store_note106(note:Dictionary)->bool:
	var before:Dictionary=world_notes106.duplicate(true)
	for rows in world_notes106.values():
		for i in range(rows.size()-1,-1,-1):
			if rows[i].id==note.id:rows.remove_at(i)
	var region:String=WorldNotes106.region_key(note.pos)
	if not world_notes106.has(region):world_notes106[region]=[]
	world_notes106[region].append(note)
	world_notes106=WorldNotes106.clean(world_notes106)
	if save_progress():world_notes_revision106+=1;return true
	world_notes106=before;return false
func delete_note106(id:String)->bool:
	var before:Dictionary=world_notes106.duplicate(true)
	var found:bool=false
	for rows in world_notes106.values():
		for i in range(rows.size()-1,-1,-1):
			if rows[i].id==id:rows.remove_at(i);found=true
	if not found:return false
	world_notes106=WorldNotes106.clean(world_notes106)
	if save_progress():world_notes_revision106+=1;return true
	world_notes106=before;return false

func ensure_flora138()->bool:
	if world_generator_version<3:return false
	if not world_flora138.is_empty():return true
	return commit_flora138(FloristJourney138.fresh(world_discovered),world_position)
func commit_flora138(next:Dictionary,pos:Vector2,town_hint215:String="")->bool:
	var clean:Dictionary=FloristJourney138.clean(next)
	if clean.is_empty():return false
	var before:Dictionary=world_flora138.duplicate(true);var previous:Vector2=world_position
	var towns_before:Dictionary=world_cousins140.duplicate(true)
	if town_hint215 in VillageCousins140.IDS and not world_cousins140.is_empty():
		world_cousins140=towns_before.duplicate(true);world_cousins140.hint215=town_hint215;world_cousins140.revealed215[town_hint215]=true
	world_flora138=clean
	if save_world_state(pos):return true
	world_flora138=before;world_cousins140=towns_before;world_position=previous;return false

func ensure_cousins140()->bool:
	if world_generator_version<3:return false
	if not world_cousins140.is_empty():return true
	return commit_cousins140(VillageCousins140.fresh(world_seed,world_discovered,world_flora138),world_position)
func commit_cousins140(next:Dictionary,pos:Vector2)->bool:
	var clean:=VillageCousins140.clean(next,world_seed)
	if clean.is_empty():return false
	var before:Dictionary=world_cousins140;var old_pos:Vector2=world_position
	world_cousins140=clean
	if save_world_state(pos):return true
	world_cousins140=before;world_position=old_pos;return false

func commit_places144(state:Dictionary,pos:Vector2)->bool:
	var before:Dictionary=world_places144;var previous:Vector2=world_position
	world_places144=WorldPlaces144.clean(state,world_seed,world_generator_version);world_position=pos
	if save_progress():return true
	world_places144=before;world_position=previous;return false

func commit_country_exit152(state:Dictionary,pos:Vector2)->bool:
	if not pos.is_finite() or not CountryLedger146.valid(state,world_seed,world_generator_version) or state.active!="frontier":return false
	var previous_position:Vector2=world_position;var previous_ledger:Dictionary=country_ledger146
	world_position=pos;country_ledger146=CountryLedger146.upgrade(state)
	if save_progress():return true
	world_position=previous_position;country_ledger146=previous_ledger;return false

func store_country_ledger146(state:Dictionary)->bool:
	# Storage only. Scene routing/entry remain disabled until a complete transition exists.
	if not CountryLedger146.valid(state,world_seed,world_generator_version):return false
	var before:Dictionary=country_ledger146
	country_ledger146=CountryLedger146.upgrade(state)
	if save_progress():return true
	country_ledger146=before;return false

func accept_repeat_contract165()->bool:
	if trial_session_active:return false
	var before:Dictionary=repeat_contract165.duplicate(true)
	if not ProgressionEconomy165.accept(repeat_contract165):return false
	if save_progress():return true
	repeat_contract165=before;return false
func claim_repeat_contract165()->int:
	if trial_session_active:return 0
	var before:Dictionary=repeat_contract165.duplicate(true);var points:int=equipment_points;var horses:Dictionary=horse_collection.export_state()
	var reward:int=ProgressionEconomy165.claim(repeat_contract165)
	if reward<=0:return 0
	equipment_points+=reward
	FoalGrowth174.advance(horse_collection)
	if save_progress():return reward
	repeat_contract165=before;equipment_points=points;horse_collection.restore(horses);return 0
func can_capture_animal165(target:String)->bool:
	return target in ["pig","goat"]

## Inventory is spent exactly once, in the same save as points and completion.
func _deliver_job249(id:String,q:Dictionary,legacy:bool=false)->bool:
	var states:Dictionary=world_quests if legacy else world_jobs249
	var state_:Dictionary=NpcQuests.state(states,id)
	if state_.get("thanked",false):return false
	if not TownJobs249.ready(q,state_):return false
	var before:Dictionary=states.duplicate(true);var points:int=equipment_points
	var sold:int=world_pigs_sold;var goats:int=world_goats_given249
	if q.kind=="capture_animal":
		var from_:int=sold if q.target=="pig" else goats
		var captures:Array=world_pig_captures if q.target=="pig" else world_goat_captures
		var events:Array=captures.slice(from_,from_+int(q.goal))
		states[id]={"status":"done","count":int(q.goal),"events":events,"thanked":true}
		if q.target=="pig":world_pigs_sold+=int(q.goal)
		else:world_goats_given249+=int(q.goal)
	else:NpcQuests.acknowledge(states,id)
	equipment_points+=int(q.get("reward",120))
	if save_progress():return true
	if legacy:world_quests=before
	else:world_jobs249=before
	equipment_points=points;world_pigs_sold=sold;world_goats_given249=goats
	return false
func deliver_town_job249(town:String,role:String)->bool:
	var q:=TownJobs249.job(world_seed,town,role)
	return false if q.is_empty() else _deliver_job249(TownJobs249.key(town,role),q)
func deliver_legacy_animals249(id:String)->bool:
	if not NpcQuests.QUESTS.has(id):return false
	var q:Dictionary=NpcQuests.QUESTS[id].duplicate(true)
	if q.kind!="capture_animal" or q.npc!="farmer":return false
	q["reward"]=int(q.goal)*40
	return _deliver_job249(id,q,true)

func buy_finish168(style:String)->bool:
	var id:String="finish_"+style
	if trial_session_active or style not in ["gold","crystal","ice"] or equipment_owned.has(id):return false
	if not ProgressionEconomy165.missing(id,equipment_points,world_pig_captures.size(),world_goat_captures.size(),int(repeat_contract165.completed)).is_empty():return false
	var before_points:int=equipment_points;var before_owned:Array[String]=equipment_owned.duplicate()
	equipment_points-=int(ProgressionEconomy165.EXTRAS[id].price);equipment_owned.append(id)
	if save_progress():return true
	equipment_points=before_points;equipment_owned=before_owned;return false
func equip_finish168(horse_id:String,style:String)->bool:
	if trial_session_active or style not in ["","gold","crystal","ice"] or (not style.is_empty() and not equipment_owned.has("finish_"+style)):return false
	var horse:Dictionary=horse_collection.find(horse_id)
	if horse.is_empty() or not horse_collection.is_adult(horse_id):return false
	var before:Dictionary=horse_collection.export_state()
	if style.is_empty():horse.erase("special_finish168")
	else:horse.special_finish168=style
	if save_progress():return true
	horse_collection.restore(before);return false

func buy_adorn169(metal:String)->bool:
	var id:String="adorn_"+metal
	if trial_session_active or metal not in ["gold","silver"] or equipment_owned.has(id):return false
	if not ProgressionEconomy165.missing(id,equipment_points,world_pig_captures.size(),world_goat_captures.size(),int(repeat_contract165.completed)).is_empty():return false
	var before_points:int=equipment_points;var before_owned:Array[String]=equipment_owned.duplicate()
	equipment_points-=int(ProgressionEconomy165.EXTRAS[id].price);equipment_owned.append(id)
	if save_progress():return true
	equipment_points=before_points;equipment_owned=before_owned;return false
func equip_adorn169(horse_id:String,slot:String,metal:String)->bool:
	if trial_session_active or slot not in ["legs","boots","both"] or metal not in ["","gold","silver"] or (not metal.is_empty() and not equipment_owned.has("adorn_"+metal)):return false
	var horse:Dictionary=horse_collection.find(horse_id)
	if horse.is_empty() or not horse_collection.is_adult(horse_id):return false
	var before:Dictionary=horse_collection.export_state()
	for pair in [["legs","leg_adorn169"],["boots","boot_adorn169"]]:
		if slot==pair[0] or slot=="both":
			if metal.is_empty():horse.erase(pair[1])
			else:horse[pair[1]]=metal
	if save_progress():return true
	horse_collection.restore(before);return false

## No spending. Completion and mode verified from the cup ledger at claim time.
func claim_cup195()->Dictionary:
	last_growth251={}
	if trial_session_active:return {"ok":false,"reason":"trial_session"}
	var loaded:=RaceCupSession194.load_state()
	if not loaded.ok:return loaded
	if not RaceCup194.current(loaded.state).is_empty():return {"ok":false,"reason":"cup_incomplete"}
	var before:=horse_collection.export_state()
	var granted:=CupRewards195.claim(horse_collection)
	if not granted.ok or granted.already:return granted
	var before_victories:Dictionary=victories240.duplicate(true)
	var ticket:=victory_ticket240("cup")
	ModeVictories240.record(victories240,"cup",ticket.sequence)
	var growth:=VictoryGrowth251.apply(horse_collection,horse_collection.selected,"cup")
	if save_progress():last_growth251=growth;return granted
	victories240=before_victories
	horse_collection.restore(before)
	return {"ok":false,"reason":"save_failed"}

func garden_action212(action_:String,horse:String="",anchors:Dictionary={})->bool:
	if trial_session_active:return false
	if action_=="feed" and not horse_collection.horses.any(func(h):return h.id==horse):return false
	var next:=Garden212.action(world_garden212,action_,horse)
	if next.is_empty():return false
	if action_=="introduce" and not anchors.is_empty():
		if not ["home","plot","sample"].all(func(k):return anchors.get(k) is Vector2 and anchors[k].is_finite()):return false
		next.anchors=anchors.duplicate(true)
	var before:Dictionary=world_garden212
	world_garden212=next
	if save_progress():return true
	world_garden212=before;return false

func relocate_garden214(anchors:Dictionary)->bool:
	if trial_session_active or not ["home","plot","sample"].all(func(k):return anchors.get(k) is Vector2 and anchors[k].is_finite()):return false
	var before:=world_garden212.duplicate(true)
	world_garden212=before.duplicate(true);world_garden212.anchors=anchors.duplicate(true);world_garden212.layout214=2
	if save_progress():return true
	world_garden212=before;return false

func ensure_herd_town217()->bool:
	if world_generator_version<3 or world_cousins140.is_empty():return false
	if world_herd_town217.get("version",0)==HerdTown217.VERSION:return true
	var before:=world_herd_town217.duplicate(true)
	world_herd_town217=HerdTown217.fresh(world_seed,world_cousins140,world_discovered,world_roaming139,world_tamed) if before.is_empty() else HerdTown217.upgraded226(before)
	if save_progress():return true
	world_herd_town217=before;return false
func prepare_herd217(base:Dictionary,cx:int,cy:int)->bool:
	if base.is_empty() or not HerdTown217.eligible(world_herd_town217,cx,cy):return true
	var key:=WorldMap.chunk_key(cx,cy)
	if world_herd_town217.get("revised226",{}).has(key):return true
	var members_:Array=WorldHerd.members(base,world_seed,cx,cy)
	if not members_.any(func(h):return HerdTown217.influence(world_herd_town217.towns,h.pos).total>0.):return true
	var before:=world_herd_town217.duplicate(true)
	members_=HerdTown217.colored(members_,world_herd_town217,cx,cy,world_tamed)
	world_herd_town217.herds[key]=members_.map(func(h):return h.traits.duplicate(true))
	world_herd_town217.revised226[key]=true
	if save_progress():return true
	world_herd_town217=before;return false

## A ticket belongs to one completed run and one storage context, never a UI refresh.
func victory_ticket240(mode:String)->Dictionary:
	_issued240=maxi(_issued240,int(victories240.last))+1
	return {"mode":mode,"sequence":_issued240,"debug":debug_mode,"trial":trial_session_active,"horse251":horse_collection.selected}
func record_mode_victory240(ticket:Dictionary,course:int=-1)->bool:
	last_growth251={}
	if trial_session_active or ticket.get("trial",true) or ticket.get("debug")!=debug_mode:return false
	if not pending_victory240.is_empty() and pending_victory240.ticket!=ticket:return false
	var before:=victories240.duplicate(true)
	if not ModeVictories240.record(victories240,str(ticket.get("mode","")),int(ticket.get("sequence",0)),course):return false
	var horses_before:=horse_collection.export_state()
	var horse_id:String=str(ticket.get("horse251",""))
	var growth:=VictoryGrowth251.apply(horse_collection,horse_id,str(ticket.get("mode","")))
	if ticket.get("mode","")=="race":
		var mounted:=horse_collection.find(horse_id)
		if not mounted.is_empty():
			var courses:Array=mounted.get("race_courses251",[]).duplicate()
			if course not in courses:courses.append(course)
			mounted.race_courses251=courses
		var prize:=VictoryGrowth251.race_horse(horse_collection,int(ticket.sequence))
		if not prize.is_empty():growth["new_horse"]=prize.duplicate(true)
	var champion:=VictoryGrowth251.champion(horse_collection,horse_id)
	if not champion.is_empty():growth["champion"]=champion.duplicate(true)
	if not horse_collection.find(horse_id).is_empty():growth["horse"]=horse_collection.find(horse_id).duplicate(true)
	if save_progress():pending_victory240.clear();last_growth251=growth;return true
	horse_collection.restore(horses_before)
	victories240=before;pending_victory240={"ticket":ticket.duplicate(true),"course":course};return false
func retry_victory240()->bool:
	if pending_victory240.is_empty():return true
	return record_mode_victory240(pending_victory240.ticket,pending_victory240.course)

func mode_open240(mode:String)->bool:
	return ModeAccess240.open(mode,highest_level_completed,world_places144,world_quests,rodeo_intro240,victories240.wins,debug_mode) and pending_victory240.is_empty()
func accept_rodeo240()->bool:
	if not ModeAccess240.rodeo_offered(world_quests):return false
	var before:bool=rodeo_intro240
	rodeo_intro240=true
	if save_progress():return true
	rodeo_intro240=before;return false

func record_bull_return269(level:int,index:int)->bool:
	if trial_session_active or debug_mode or level<1 or level>LevelCatalog.MAX_LEVEL or index<0 or index>=mini(16,LevelCatalog.get_level(level).bull_count):return false
	var key:String="%d:%d"%[level,index]
	if world_bull_returns269.has(key):return true
	pending_bull_returns269[key]=true
	return save_progress()
static func clean_bull_returns269(raw:Variant)->Dictionary:
	var result:Dictionary={}
	if not raw is Dictionary:return result
	for level in range(1,LevelCatalog.MAX_LEVEL+1):
		for index in mini(16,LevelCatalog.get_level(level).bull_count):
			var key:String="%d:%d"%[level,index]
			if raw.has(key) and raw[key] is bool and raw[key]==true:result[key]=true
	return result

## Read-only checks. Never changes, repairs, renames or removes the source save.
func save_diagnostic330()->String:
	var lines:PackedStringArray=[]
	lines.append("Modo: "+("DEBUG" if debug_mode else "Normal"))
	lines.append("Lectura protegida: "+("sí" if not _load_valid or cosmetic_protected332 else "no"))
	if cosmetic_protected332:lines.append("G04 · Valores de apariencia recuperados solo en memoria: %d. El original no se ha modificado. Esta sesión no guarda cambios."%cosmetic_changes332.size())
	if not recovery_backup333.is_empty():lines.append("R00 · Copia original: "+recovery_backup333)
	if not recovery_error333.is_empty():lines.append(recovery_error333)
	if not save_error330.is_empty():lines.append(save_error330)
	var cfg:=ConfigFile.new();var err:=cfg.load(save_path)
	if err!=OK:
		lines.append(("G10 · No se puede leer el archivo: " if FileAccess.file_exists(save_path) else "G11 · Todavía no existe archivo en este modo: ")+error_string(err))
		return "\n".join(lines)
	var errors:PackedStringArray=[]
	if not cfg.has_section_key("progress","highest_level_completed"):errors.append("G20 · Falta el registro de progreso.")
	for pair in [["progress","highest_level_completed"],["equipment","points"],["world","seed"],["world","pigs_sold"],["world","goats_given249"]]:
		if cfg.has_section_key(pair[0],pair[1]):
			var value:Variant=cfg.get_value(pair[0],pair[1])
			if not value is int or value<0:errors.append("G28 · Dato crítico no válido: "+pair[0]+"/"+pair[1])
	if cfg.has_section_key("horses_trial","state"):
		var verify:=HorseCollection.new()
		if not verify.restore(cfg.get_value("horses_trial","state",{})):errors.append("G21 · El registro de caballos no supera la validación.")
	var generator:Variant=cfg.get_value("world","generator_version",1)
	if typeof(generator)!=TYPE_INT or generator not in [1,2,3,4,5,6]:errors.append("G22 · Versión del mundo no reconocida.")
	if not ModeVictories240.valid(cfg.get_value("progress","victories240",ModeVictories240.fresh())):errors.append("G23 · Registro de victorias no válido.")
	var garden:Variant=cfg.get_value("world","garden212",{})
	if not garden is Dictionary or (not garden.is_empty() and garden.get("version",0)!=Garden212.VERSION):errors.append("G24 · Versión del jardín no reconocida.")
	var seed_raw332:Variant=cfg.get_value("world","seed",0)
	var seed_:int=seed_raw332 if seed_raw332 is int else 0
	var herd:Variant=cfg.get_value("world","herd_town217",{})
	if not herd is Dictionary or (not herd.is_empty() and not HerdTown217.valid(herd,seed_)):errors.append("G25 · Registro del pueblo de manadas no válido.")
	var contract:Variant=cfg.get_value("world","repeat_contract165",ProgressionEconomy165.new_contract())
	if not contract is Dictionary or contract.get("version",0)!=ProgressionEconomy165.VERSION:errors.append("G26 · Versión de encargos no reconocida.")
	var countries:Variant=cfg.get_value("world","countries146",{})
	if generator is int and generator in [1,2,3,4,5,6] and (not countries is Dictionary or (not countries.is_empty() and not CountryLedger146.valid(countries,seed_,generator))):errors.append("G27 · Registro de países no válido.")
	for key332 in ["pig_captures","goat_captures"]:
		var ids332:Variant=cfg.get_value("world",key332,[])
		if (not ids332 is Array and not ids332 is PackedStringArray) or WorldLivestock104.valid_ids(ids332).size()!=ids332.size():errors.append("G29 · Registro de capturas no válido: "+key332)
	for pair332 in [["pigs_sold","pig_captures"],["goats_given249","goat_captures"]]:
		var used332:Variant=cfg.get_value("world",pair332[0],0)
		var ids332:Variant=cfg.get_value("world",pair332[1],[])
		if used332 is int and (ids332 is Array or ids332 is PackedStringArray) and used332>ids332.size():errors.append("G31 · Inventario inconsistente: "+pair332[0])
	if garden is Dictionary:
		for key332 in ["crops","seeds","harvests"]:
			var count332:Variant=garden.get(key332,0)
			if not count332 is int or count332<0 or count332>9999:errors.append("G32 · Inventario del jardín no válido: "+key332)
	var pos332:Variant=cfg.get_value("world","position",Vector2.ZERO)
	if not pos332 is Vector2 or not pos332.is_finite():errors.append("G30 · Posición del mundo no válida.")
	if errors.is_empty():lines.append("G00 · Comprobaciones disponibles superadas. No certifica todos los datos posibles.")
	else:lines.append_array(errors)
	lines.append("Este diagnóstico no modifica archivos. Comparte una captura si falla el guardado.")
	return "\n".join(lines)
