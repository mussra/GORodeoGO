extends GutTest
var save:Node
var slots:SaveSlots334
var base:String
func before_each():
 base='user://slots334-'+str(Time.get_ticks_usec())+'-'+str(randi());DirAccess.make_dir_absolute(base)
 save=load('res://src/Application/save_data.gd').new();save.save_path=base+'/normal.cfg';save.load_progress();save.equipment_points=432;save.world_seed=752026;save.world_generator_version=3;assert_true(save.save_progress())
 slots=SaveSlots334.new();slots.root=base+'/slots';assert_true(slots.setup(save.save_path,base+'/debug.cfg'));slots.attach(save)
func after_each():save.free()
func test_register_preserves_original_and_creates_verified_backup():
 var bytes=FileAccess.get_file_as_bytes(save.save_path);assert_eq(save.equipment_points,432);assert_eq(slots.state.rows.size(),2)
 var files=DirAccess.open(slots.root).get_directories();assert_eq(files.size(),1);assert_eq(FileAccess.get_file_as_bytes(slots.root+'/'+files[0]+'/original.cfg'),bytes)
 var again=SaveSlots334.new();again.root=slots.root;assert_true(again.setup('unused','unused'));assert_eq(again.state,slots.state);assert_eq(FileAccess.get_file_as_bytes(save.save_path),bytes)
func test_new_named_slot_is_fresh_and_original_remains_selectable():
 var path=save.save_path;var id=slots.active(false).id;var original=FileAccess.get_file_as_bytes(path)
 assert_true(slots.create('Nueva aventura',save));assert_ne(save.save_path,path);assert_eq(save.equipment_points,0);assert_eq(save.world_seed,0);assert_eq(slots.active(false).name,'Nueva aventura');assert_eq(FileAccess.get_file_as_bytes(path),original)
 save.equipment_points=99;assert_true(slots.save_current(save));assert_true(slots.select(id,save));assert_eq(save.save_path,path);assert_eq(save.equipment_points,432);assert_eq(slots.state.rows.size(),3)
func test_rename_persists_without_changing_gameplay_file():
 var bytes=FileAccess.get_file_as_bytes(save.save_path);assert_true(slots.rename(slots.active(false).id,'Mi rancho'));assert_eq(FileAccess.get_file_as_bytes(save.save_path),bytes)
 var again=SaveSlots334.new();again.root=slots.root;assert_true(again.setup('unused','unused'));assert_eq(again.active(false).name,'Mi rancho');assert_false(slots.rename(again.active(false).id,'  '))
func test_failed_save_blocks_switch_and_creation():
 save._load_valid=false;var path=save.save_path;var rows=slots.state.rows.size();assert_false(slots.create('No debe activarse',save));assert_eq(save.save_path,path);assert_eq(slots.state.rows.size(),rows)
func test_bad_target_is_not_activated():
 var old=slots.active(false).id;assert_true(slots.create('Otra',save));var path=save.save_path;var cfg=ConfigFile.new();cfg.set_value('broken','x',true);cfg.save(slots.row(old).path)
 assert_false(slots.select(old,save));assert_eq(save.save_path,path);assert_eq(slots.active(false).name,'Otra')
func test_thumbnail_file_persists_and_old_thumbnail_is_not_deleted():
 var image=Image.create(640,360,false,Image.FORMAT_RGB8);image.fill(Color.RED);assert_true(slots.thumbnail(image,save));var path=slots.active(false).thumbnail;assert_true(FileAccess.file_exists(path));assert_eq(Image.load_from_file(path).get_size(),Vector2i(480,270))
 image.fill(Color.BLUE);assert_true(slots.thumbnail(image,save));assert_ne(slots.active(false).thumbnail,path);assert_true(FileAccess.file_exists(path))
func test_corrupt_catalog_never_reinitializes_or_overwrites():
 var cfg=ConfigFile.new();cfg.set_value('broken','x',true);cfg.save(slots.root+'/catalog-999999999999.cfg');var current=FileAccess.get_file_as_bytes(save.save_path)
 var again=SaveSlots334.new();again.root=slots.root;assert_false(again.setup(save.save_path,base+'/debug.cfg'));assert_eq(FileAccess.get_file_as_bytes(save.save_path),current)

func test_normal_and_debug_slots_remain_separate_and_restore_active_on_restart():
 assert_true(slots.create('Normal nueva',save));var normal=slots.active(false).path
 save.debug_mode=true;slots.attach(save);save.load_progress();assert_true(slots.create('DEBUG nueva',save));var debug=save.save_path;assert_ne(normal,debug)
 var again=SaveSlots334.new();again.root=slots.root;assert_true(again.setup('unused','unused'));assert_eq(again.active(false).path,normal);assert_eq(again.active(true).path,debug)
 save.debug_mode=false;again.attach(save);save.load_progress();assert_eq(save.save_path,normal);assert_false(again.select(again.active(true).id,save))
func test_pending_partial_catalog_is_ignored_in_favor_of_last_verified_revision():
 var f=FileAccess.open(slots.root+'/catalog-999999999999.cfg.pending',FileAccess.WRITE);f.store_string('partial');f.close();var again=SaveSlots334.new();again.root=slots.root;assert_true(again.setup('unused','unused'));assert_eq(again.state,slots.state)
