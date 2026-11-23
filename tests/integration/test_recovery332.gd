extends GutTest
var original_path:String
func before_each():
 original_path=SaveData.save_path;SaveData.save_path='user://recovery332-'+str(Time.get_ticks_usec())+'.cfg';SaveData.load_progress();SaveData.world_seed=752026;SaveData.world_generator_version=3;SaveData.horse_collection=HorseCollection.new();SaveData.horse_collection.seed_trial();SaveData.equipment_points=321;SaveData.points_legacy_credit_applied=true
func after_each():
 SaveData.save_path=original_path;SaveData.load_progress()
func fixture332(section:String,key:String,value:Variant)->PackedByteArray:
 assert_true(SaveData.save_progress());var cfg=ConfigFile.new();assert_eq(cfg.load(SaveData.save_path),OK);cfg.set_value(section,key,value);assert_eq(cfg.save(SaveData.save_path),OK);return FileAccess.get_file_as_bytes(SaveData.save_path)
func test_unknown_color_recovers_only_in_memory_and_warns_once():
 var raw=SaveData.horse_collection.export_state();raw.horses[0].traits.coat=999
 var bytes=fixture332('horses_trial','state',raw);SaveData.load_progress()
 assert_true(SaveData._load_valid);assert_true(SaveData.cosmetic_protected332);assert_eq(SaveData.horse_collection.horses[0].traits.coat,0);assert_eq(SaveData.equipment_points,321)
 assert_false(SaveData.take_cosmetic_notice332().is_empty());assert_eq(SaveData.take_cosmetic_notice332(),'');SaveData.load_progress();assert_eq(SaveData.take_cosmetic_notice332(),'')
 assert_false(SaveData.save_progress());assert_true(SaveData.save_error330.begins_with('G04'));assert_eq(FileAccess.get_file_as_bytes(SaveData.save_path),bytes)
func test_bad_parentage_is_never_recovered_by_a_color_default():
 var raw=SaveData.horse_collection.export_state();raw.horses[0].traits.coat=999;raw.horses[0].parents=['missing','also-missing']
 var bytes=fixture332('horses_trial','state',raw);SaveData.load_progress();assert_false(SaveData._load_valid);assert_false(SaveData.save_progress());assert_eq(FileAccess.get_file_as_bytes(SaveData.save_path),bytes)
func test_missing_required_trait_is_not_a_cosmetic_repair():
 var raw=SaveData.horse_collection.export_state();raw.horses[0].traits.erase('coat')
 fixture332('horses_trial','state',raw);SaveData.load_progress();assert_false(SaveData._load_valid)
func test_invalid_critical_points_block_instead_of_silent_zero():
 var bytes=fixture332('equipment','points',-10);SaveData.load_progress();assert_false(SaveData._load_valid);assert_false(SaveData.save_progress());assert_eq(FileAccess.get_file_as_bytes(SaveData.save_path),bytes)
func test_herd_color_recovery_preserves_ids_points_and_original():
 var policy=HerdTown217.fresh(752026,VillageCousins140.fresh(752026,[],FloristJourney138.fresh([])),[],{},[])
 policy.herds['1,-1']=[{'coat':999,'pattern':0,'mane':0,'eyes':0,'spots':1},{'coat':0,'pattern':0,'mane':0,'eyes':0,'spots':1},{'coat':0,'pattern':0,'mane':0,'eyes':0,'spots':1}]
 var bytes=fixture332('world','herd_town217',policy);SaveData.load_progress();assert_true(SaveData._load_valid);assert_true(SaveData.cosmetic_protected332);assert_eq(SaveData.world_herd_town217.herds['1,-1'][0].coat,0);assert_eq(SaveData.equipment_points,321);assert_false(SaveData.save_progress());assert_eq(FileAccess.get_file_as_bytes(SaveData.save_path),bytes)
func test_new_invalid_candidate_never_replaces_healthy_file():
 assert_true(SaveData.save_progress());var bytes=FileAccess.get_file_as_bytes(SaveData.save_path);SaveData.horse_collection.horses[0].traits.coat=999;assert_false(SaveData.save_progress());assert_true(SaveData.save_error330.begins_with('G05'));assert_eq(FileAccess.get_file_as_bytes(SaveData.save_path),bytes)
func test_world_writer_agrees_with_cleaner_boundaries():
 var positions=WorldHerdPositions139.new();positions.setup({},7);var id=WorldHerd.member_id(0,0,0)
 positions.put(id,Vector2i.ZERO,0,Vector2(100000000.,0));assert_eq(positions.state,WorldHerdPositions139.clean(positions.state,7))
 positions.put('bad-id',Vector2i.ZERO,0,Vector2.ZERO);positions.put(id,Vector2i.ZERO,6,Vector2.ZERO);positions.put(id,Vector2i.ZERO,0,Vector2(100000001.,0));assert_eq(positions.state.horses.size(),1);assert_eq(positions.state,WorldHerdPositions139.clean(positions.state,7))
func test_nonfinite_world_edits_and_wrong_count_type_rejected():
 for pos in [Vector2(INF,0),Vector2(NAN,1)]:
  assert_false(WorldEdits.valid_op({'type':'add_pigs','pos':pos,'count':2}));assert_false(WorldEdits.valid_op({'type':'remove_decor','pos':pos,'radius':50.}));assert_false(WorldEdits.valid_op({'type':'add_decor','pos':pos,'kind':'tree','scale':1.}))
 assert_false(WorldEdits.valid_op({'type':'add_pigs','pos':Vector2.ZERO,'count':2.5}));assert_false(WorldEdits.valid_op({'type':'add_decor','pos':Vector2.ZERO,'kind':'tree','scale':{}}))

func test_garden_never_generates_inventory_that_cleaner_truncates():
 var state=Garden212.fresh();state.stage='ripe';state.crops=9996;state.seeds=9998;state.harvests=9998
 var next=Garden212.action(state,'harvest');assert_eq(next.crops,9999);assert_eq(Garden212.clean(next),next)
 state.crops=9997;assert_eq(Garden212.action(state,'harvest'),{});assert_eq(state.crops,9997)
func test_unknown_herd_version_remains_protected_even_with_bad_color():
 var policy=HerdTown217.fresh(752026,VillageCousins140.fresh(752026,[],FloristJourney138.fresh([])),[],{},[]);policy.version=999
 var bytes=fixture332('world','herd_town217',policy);SaveData.load_progress();assert_false(SaveData._load_valid);assert_false(SaveData.save_progress());assert_eq(FileAccess.get_file_as_bytes(SaveData.save_path),bytes)
func test_write_failure_does_not_replace_original_or_reward_capture():
 assert_true(SaveData.save_progress());var path=SaveData.save_path;var original=FileAccess.get_file_as_bytes(path);var points=SaveData.equipment_points
 SaveData.save_path='user://missing-directory332-'+str(Time.get_ticks_usec())+'/save.cfg'
 assert_false(SaveData.record_goat104('failed-io'));assert_eq(SaveData.equipment_points,points);assert_eq(SaveData.world_goat_captures.size(),0);assert_true(SaveData.save_error330.begins_with('G02'));assert_push_error_count(1);assert_eq(FileAccess.get_file_as_bytes(path),original)
func test_each_cosmetic_bound_defaults_but_validator_stays_strict():
 var c=HorseCollection.new()
 for key in ['coat','pattern','mane','eyes','spots','legs']:
  var traits={'coat':0,'pattern':0,'mane':0};traits[key]=999;var changes=[]
  assert_false(c.valid_traits(traits));var fixed=CosmeticRecovery332.traits(traits,changes);assert_true(c.valid_traits(fixed));assert_eq(changes,[key]);assert_eq(traits[key],999)

func test_invalid_town_color_recovers_visually_without_touching_original():
 var towns=VillageCousins140.fresh(752026,[],FloristJourney138.fresh([]));towns.towns215.home.spot_index=999;towns.towns215.home.spot='not-html'
 var bytes=fixture332('world','cousins140',towns);SaveData.load_progress();assert_true(SaveData._load_valid);assert_true(SaveData.cosmetic_protected332);assert_eq(SaveData.world_cousins140.towns215.home.spot_index,0);assert_false(SaveData.save_progress());assert_eq(FileAccess.get_file_as_bytes(SaveData.save_path),bytes)
func test_unknown_genetic_finish_is_not_defaulted_or_granted():
 var raw=SaveData.horse_collection.export_state();raw.horses[0].traits.finish='future-genetic-finish'
 var bytes=fixture332('horses_trial','state',raw);SaveData.load_progress();assert_false(SaveData._load_valid);assert_false(SaveData.save_progress());assert_eq(FileAccess.get_file_as_bytes(SaveData.save_path),bytes)

func test_critical_capture_record_position_and_inventory_are_never_silently_dropped():
 for entry in [['pig_captures',['good','']],['goat_captures',['duplicate','duplicate']],['position',Vector2(INF,0)],['pigs_sold',1],['goats_given249',1]]:
  SaveData.load_progress();SaveData._load_valid=true;SaveData.cosmetic_protected332=false;SaveData.world_pig_captures=[];SaveData.world_goat_captures=[];SaveData.world_pigs_sold=0;SaveData.world_goats_given249=0;SaveData.world_position=Vector2.ZERO
  var bytes=fixture332('world',entry[0],entry[1]);SaveData.load_progress();assert_false(SaveData._load_valid);assert_false(SaveData.save_progress());assert_eq(FileAccess.get_file_as_bytes(SaveData.save_path),bytes)

func test_malformed_herd_version_revision_and_rows_are_rejected_without_exception():
 var base=HerdTown217.fresh(752026,VillageCousins140.fresh(752026,[],FloristJourney138.fresh([])),[],{},[])
 for entry in [['version',{}],['seed','wrong'],['revised226',[]],['herds',[]],['herds',{'0,0':null}]]:
  var bad=base.duplicate(true);bad[entry[0]]=entry[1];assert_false(HerdTown217.valid(bad,752026))
 var legacy=base.duplicate(true);legacy.version=1;legacy.revised226=[];assert_false(HerdTown217.valid(legacy,752026))
func test_new_invalid_inventory_candidate_does_not_truncate_or_replace_file():
 assert_true(SaveData.save_progress());var bytes=FileAccess.get_file_as_bytes(SaveData.save_path);SaveData.world_garden212.crops=10000;assert_false(SaveData.save_progress());assert_eq(FileAccess.get_file_as_bytes(SaveData.save_path),bytes)
