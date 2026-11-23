extends GutTest
var old_path:String
func before_each():
 old_path=SaveData.save_path;SaveData.save_path='user://backup333-'+str(Time.get_ticks_usec())+'.cfg';SaveData.load_progress();SaveData.world_seed=752026;SaveData.world_generator_version=3;SaveData.equipment_points=321;SaveData.points_legacy_credit_applied=true;SaveData.recovery_details333=[];SaveData.recovery_backup333='';SaveData.recovery_error333='';SaveData.auto_recovery333=true
func after_each():
 SaveData.save_path=old_path;SaveData.load_progress()
func corrupt333(critical:bool=false)->PackedByteArray:
 assert_true(SaveData.save_progress());var cfg=ConfigFile.new();assert_eq(cfg.load(SaveData.save_path),OK);var raw=cfg.get_value('horses_trial','state');raw.horses[0].traits.coat=999
 if critical:raw.horses[0].parents=['missing','another-missing']
 cfg.set_value('horses_trial','state',raw);cfg.set_value('future-data','keep',{'private':'unchanged','number':123.456});assert_eq(cfg.save(SaveData.save_path),OK);return FileAccess.get_file_as_bytes(SaveData.save_path)
func test_backup_is_exact_and_only_cosmetic_value_changes_in_active_file():
 var original=corrupt333();var source=ConfigFile.new();source.load(SaveData.save_path);SaveData.load_progress()
 assert_true(SaveData._load_valid);assert_false(SaveData.cosmetic_protected332);assert_false(SaveData.recovery_backup333.is_empty());assert_eq(FileAccess.get_file_as_bytes(SaveData.recovery_backup333),original)
 var backup_hash=FileAccess.get_sha256(SaveData.recovery_backup333);var active=ConfigFile.new();active.load(SaveData.save_path);var expected=source.get_value('horses_trial','state');expected.horses[0].traits.coat=0;source.set_value('horses_trial','state',expected);assert_true(SaveData._configs_equal333(source,active));assert_eq(SaveData.equipment_points,321)
 var notice=SaveData.take_cosmetic_notice332();assert_true(notice.contains('traits/coat'));assert_true(notice.contains(SaveData.recovery_backup333));assert_eq(SaveData.take_cosmetic_notice332(),'')
 assert_true(SaveData.record_pig104('after-recovery'));SaveData.load_progress();assert_eq(SaveData.world_pig_captures,['after-recovery']);assert_eq(FileAccess.get_sha256(SaveData.recovery_backup333),backup_hash)
func test_critical_failure_never_rewrites_even_with_invalid_color():
 var original=corrupt333(true);SaveData.load_progress();assert_false(SaveData._load_valid);assert_eq(FileAccess.get_file_as_bytes(SaveData.save_path),original);assert_eq(SaveData.recovery_backup333,'')
func test_failed_backup_reservation_never_overwrites_active_file():
 var original=corrupt333();SaveData.auto_recovery333=false;SaveData.load_progress();var path=SaveData.save_path;var cfg=ConfigFile.new();cfg.load(path)
 SaveData.save_path='user://missing333-'+str(Time.get_ticks_usec())+'/no-dir/save.cfg';assert_false(SaveData._recover_cosmetics333(cfg,path));assert_true(SaveData.cosmetic_protected332);assert_eq(FileAccess.get_file_as_bytes(path),original);assert_true(SaveData.recovery_error333.begins_with('R01'));SaveData.save_path=path
func test_second_repair_creates_new_backup_without_changing_the_first():
 corrupt333();SaveData.load_progress();var first=SaveData.recovery_backup333;var bytes=FileAccess.get_file_as_bytes(first)
 var cfg=ConfigFile.new();cfg.load(SaveData.save_path);var raw=cfg.get_value('horses_trial','state');raw.horses[0].traits.eyes=999;cfg.set_value('horses_trial','state',raw);cfg.save(SaveData.save_path);SaveData.load_progress();assert_ne(SaveData.recovery_backup333,first);assert_eq(FileAccess.get_file_as_bytes(first),bytes);assert_true(SaveData._load_valid);assert_false(SaveData.cosmetic_protected332)
func test_validation_failure_after_backup_keeps_active_original():
 var original=corrupt333();SaveData.auto_recovery333=false;SaveData.load_progress();var cfg=ConfigFile.new();cfg.load(SaveData.save_path);cfg.set_value('equipment','points',-1);cfg.save(SaveData.save_path);original=FileAccess.get_file_as_bytes(SaveData.save_path)
 # Simulate a failure discovered by the independent candidate reader.
 var path=SaveData.save_path;assert_false(SaveData._recover_cosmetics333(cfg,path));assert_true(SaveData.recovery_error333.begins_with('R09'));assert_eq(FileAccess.get_file_as_bytes(path),original);assert_true(SaveData.cosmetic_protected332)
func test_unknown_sections_and_other_horse_traits_survive_recovery():
 var original=corrupt333();SaveData.load_progress();var cfg=ConfigFile.new();cfg.load(SaveData.save_path);assert_eq(cfg.get_value('future-data','keep'),{'private':'unchanged','number':123.456});assert_eq(SaveData.horse_collection.horses[0].traits.finish,'original');assert_eq(FileAccess.get_file_as_bytes(SaveData.recovery_backup333),original)

func test_source_changed_between_read_and_backup_is_not_replaced():
 var original=corrupt333();SaveData.auto_recovery333=false;SaveData.load_progress();var stale=ConfigFile.new();stale.load(SaveData.save_path);var newer=ConfigFile.new();newer.load(SaveData.save_path);newer.set_value('equipment','points',999);newer.save(SaveData.save_path);var current=FileAccess.get_file_as_bytes(SaveData.save_path)
 assert_false(SaveData._recover_cosmetics333(stale,SaveData.save_path));assert_true(SaveData.recovery_error333.begins_with('R05'));assert_eq(FileAccess.get_file_as_bytes(SaveData.save_path),current)
