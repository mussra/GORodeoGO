extends GutTest
var world:CountryPreview146
var frontier:Node2D
var previous:String
func before_each():
 previous=SaveData.save_path;SaveData.save_path="user://touch154.dat";SaveData._load_valid=true;SaveData.trial_session_active=false;SaveData.world_seed=752026;SaveData.world_generator_version=3;SaveData.country_ledger146={};SaveData.world_position=WorldNominal98.home();SaveData.world_flora138={};SaveData.world_cousins140={};SaveData.world_roaming139={};SaveData.world_places144={};SaveData.world_edits=[];SaveData.world_discovered=[];SaveData.world_missions={};SaveData.world_quests={};SaveData.horse_collection=HorseCollection.new();SaveData.horse_collection.seed_trial()
 get_tree().root.size=Vector2i(1600,720)
func after_each():
 if is_instance_valid(world):world.free()
 if is_instance_valid(frontier):frontier.free()
 SaveData.country_ledger146={};SaveData.save_path=previous;DirAccess.remove_absolute("user://touch154.dat");get_tree().root.size=Vector2i(1280,720);await get_tree().process_frame
func tap(point:Vector2,index:int=0):
 for down in [true,false]:
  var e:=InputEventScreenTouch.new();e.position=point;e.index=index;e.pressed=down;Input.parse_input_event(e);await get_tree().process_frame
 await get_tree().process_frame
func button(host:Node,text_:String)->Button:
 for node in host.find_children("*","Button",true,false):
  if node.text==text_:return node
 return null
func check_controls():
 world.player.set_physics_process(false);await get_tree().process_frame
 await tap(world.map_button.get_global_rect().get_center());assert_true(is_instance_valid(world.modal));assert_false(world.touch_controls.visible)
 var back:=button(world.modal,"X");assert_not_null(back)
 if back!=null:await tap(back.get_global_rect().get_center())
 assert_false(is_instance_valid(world.modal));assert_true(world.touch_controls.visible)
 var count_:Array=[0];world.return_requested.connect(func():count_[0]+=1)
 if world is CountrySession152:world.exit_handler=func(_session):return true
 await tap(button(world.hud_canvas,"Salir a Frontera").get_global_rect().get_center());assert_eq(count_[0],1)
func test_country_clocks_show_owned_abilities_and_tick_shared_stamina():
 world=CountryPreview146.new();get_tree().root.add_child(world);world.player.set_physics_process(false);assert_true(world.gauges154.stamina.visible);assert_eq(world.gauges154.dodge.visible,world.player.dodge_available);assert_eq(world.gauges154.jump.visible,world.player.can_jump)
 var before:float=world.stamina154.value;world.player.gait=WorldGait.GALOPE;world.player.velocity=Vector2(100,0);world._process(1.);assert_lt(world.stamina154.value,before);assert_lt(world.gauges154.stamina.ratio,1.)
 world.show_map();before=world.stamina154.value;world._process(1.);assert_eq(world.stamina154.value,before)
func test_only_interactive_hud_controls_block_touch_and_layer_is_above_sticks():
 world=CountryPreview146.new();get_tree().root.add_child(world);assert_eq(world.hud_canvas.mouse_filter,Control.MOUSE_FILTER_IGNORE);assert_gt(world.hud_canvas.get_parent().layer,world.touch_controls.layer);assert_eq(world.map_button.mouse_filter,Control.MOUSE_FILTER_STOP)
 for gauge in world.gauges154.values():assert_eq(gauge.mouse_filter,Control.MOUSE_FILTER_IGNORE)
func test_owned_ability_clocks_follow_same_rules_and_cooldown_as_frontier():
 world=CountryPreview146.new();get_tree().root.add_child(world);world.player.set_physics_process(false);var horse:=SaveData.horse_collection.find(SaveData.horse_collection.selected)
 MountedStatus154.abilities(world.player,world.gauges154,horse);assert_eq(world.player.can_jump,HorseJump.capable(horse));assert_eq(world.player.dodge_available,HorseTraining.knows(horse,"dodge"));world.player.dodge.cooldown=world.player.dodge_recharge_seconds*.5;MountedStatus154.abilities(world.player,world.gauges154,horse);assert_almost_eq(world.gauges154.dodge.ratio,.5,.001)
func test_new_country_road_uses_same_stamina_discount_and_no_drain_during_map():
 world=CountryPreview146.new();get_tree().root.add_child(world);world.player.set_physics_process(false);assert_true(world.on_road154(world.data.entry));assert_false(world.on_road154(Vector2(100,100)));var start:=WorldStamina.new_state();world.player.gait=WorldGait.GALOPE;world.player.velocity=Vector2(100,0)
 var road:=MountedStatus154.stamina(world.player,world.gauges154,start,1.,true);var grass:=MountedStatus154.stamina(world.player,world.gauges154,start,1.,false);assert_gt(road.value,grass.value)
