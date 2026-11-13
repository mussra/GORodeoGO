extends GutTest
var sut:Node
func before_each():
 sut=load("res://src/Application/save_data.gd").new();sut.save_path="user://adorn169.dat";sut.horse_collection.seed_trial();sut.equipment_points=100000;sut.points_legacy_credit_applied=true
func after_each():sut.free();DirAccess.remove_absolute("user://adorn169.dat")
func activity():
 for i in 40:sut.world_pig_captures.append("pig%d"%i)
 for i in 30:sut.world_goat_captures.append("goat%d"%i)
 sut.repeat_contract165=ProgressionEconomy165.new_contract(8)
func test_purchase_requirements_once_reload_and_both_slots_without_gene_changes():
 assert_false(sut.buy_adorn169("silver"));activity()
 var before:Dictionary=sut.horse_collection.export_state()
 assert_true(sut.buy_adorn169("silver"));assert_eq(sut.equipment_points,94000);assert_false(sut.buy_adorn169("silver"))
 assert_true(sut.buy_adorn169("gold"));assert_eq(sut.equipment_points,82000)
 assert_true(sut.equip_adorn169("original","both","gold"));assert_true(sut.equip_adorn169("original","boots","silver"))
 assert_eq(HorseAdorn169.metal(sut.horse_collection.find("original"),"legs"),"gold");assert_eq(HorseAdorn169.metal(sut.horse_collection.find("original"),"boots"),"silver")
 sut.load_progress();assert_eq(HorseAdorn169.metal(sut.horse_collection.find("original"),"boots"),"silver");assert_eq(sut.world_pig_captures.size(),40);assert_eq(sut.repeat_contract165.completed,8)
 assert_true(sut.equip_adorn169("original","both",""));assert_eq(sut.horse_collection.export_state(),before)
func test_failure_rolls_back_and_invalid_modes_owners_foals_slots_are_rejected():
 activity();sut._load_valid=false;assert_false(sut.buy_adorn169("gold"));assert_eq(sut.equipment_points,100000);assert_false(sut.equipment_owned.has("adorn_gold"))
 sut._load_valid=true;sut.trial_session_active=true;assert_false(sut.buy_adorn169("gold"));sut.trial_session_active=false;assert_true(sut.buy_adorn169("gold"));sut._load_valid=false
 assert_false(sut.equip_adorn169("original","both","gold"));assert_false(HorseAdorn169.active(sut.horse_collection.find("original")));sut._load_valid=true
 for args in [["original","bad","gold"],["original","both","bad"],["unknown","both","gold"],["original","both","silver"]]:assert_false(sut.equip_adorn169(args[0],args[1],args[2]))
 sut.horse_collection.find("original").stage="foal";assert_false(sut.equip_adorn169("original","both","gold"));assert_false(sut.buy_adorn169("bad"))
func test_all_133_masks_match_alpha_safe_nonoverlapping_regions():
 var total:int=0
 for spec in FinishPose168.specs():
  for i in spec.count:
   total+=1;var p:=HorseAdorn169.mask_path(spec,i);assert_true(ResourceLoader.exists(p),p)
   var mask:Image=load(p).get_image();var source:Image=load(FinishPose168.paths(spec,i).source).get_image()
   if mask.is_compressed():mask.decompress()
   if source.is_compressed():source.decompress()
   assert_eq(mask.get_size(),source.get_size(),p)
   var valid:bool=true;var boot:int=0
   for y in mask.get_height():
    for x in mask.get_width():
     var c:Color=mask.get_pixel(x,y)
     if c.r>.01 and c.g>.01:valid=false
     if maxf(c.r,c.g)>.01 and source.get_pixel(x,y).a<.38:valid=false
     if c.g>.01:boot+=1
   assert_true(valid,p)
   if spec.kind=="horse":assert_eq(boot,0,p)
 assert_eq(total,133)
func test_material_cache_preserves_finish_and_independent_slot_metals():
 var horse:Dictionary={"leg_adorn169":"gold","boot_adorn169":"silver","special_finish168":"ice"};var spec:Dictionary=FinishPose168.specs()[0]
 var m:=HorseAdorn169.material(horse,spec,0);assert_eq(m.get_shader_parameter("style"),3);assert_eq(m.get_shader_parameter("leg_metal169"),1);assert_eq(m.get_shader_parameter("boot_metal169"),2)
 assert_same(m,HorseAdorn169.material(horse,spec,0));assert_ne(m,HorseAdorn169.material(horse,spec,1));assert_ne(m,HorseAdorn169.material({"leg_adorn169":"silver"},spec,0))
 assert_null(HorseAdorn169.material({},spec,0));assert_same(FinishPose168.material("gold",spec,0),HorseAdorn169.material({"special_finish168":"gold"},spec,0))
 var invalid:Dictionary=sut.horse_collection.export_state();invalid.horses[0].leg_adorn169="bad";assert_false(sut.horse_collection.restore(invalid))
