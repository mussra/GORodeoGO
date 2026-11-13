extends Node
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
  var e:=InputEventScreenTouch.new();e.position=get_viewport().get_screen_transform()*point;e.index=index;e.pressed=down;Input.parse_input_event(e);await get_tree().process_frame
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
func test_wide_touches_open_map_close_and_exit_temporary_country():
 world=CountryPreview146.new();get_tree().root.add_child(world);await check_controls()
func test_wide_touches_open_map_close_and_exit_persistent_country():
 world=CountrySession152.new();world.session_state=CountryLedger146.enter(CountryLedger146.fresh(SaveData.world_seed,SaveData.world_generator_version),SaveData.world_position,752026);get_tree().root.add_child(world);assert_true(world.activate152());await check_controls()
func test_country_clocks_show_owned_abilities_and_tick_shared_stamina():
 world=CountryPreview146.new();get_tree().root.add_child(world);world.player.set_physics_process(false);assert_true(world.gauges154.stamina.visible);assert_eq(world.gauges154.dodge.visible,world.player.dodge_available);assert_eq(world.gauges154.jump.visible,world.player.can_jump)
 var before:float=world.stamina154.value;world.player.gait=WorldGait.GALOPE;world.player.velocity=Vector2(100,0);world._process(1.);assert_lt(world.stamina154.value,before);assert_lt(world.gauges154.stamina.ratio,1.)
 world.show_map();before=world.stamina154.value;world._process(1.);assert_eq(world.stamina154.value,before)
func test_hud_never_captures_plain_world_movement_or_aim_touch():
 world=CountryPreview146.new();get_tree().root.add_child(world);world.player.set_physics_process(false);await get_tree().process_frame
 var e:=InputEventScreenTouch.new();e.position=Vector2(300,450);e.index=2;e.pressed=true;Input.parse_input_event(e);await get_tree().process_frame
 var d:=InputEventScreenDrag.new();d.index=2;d.position=Vector2(380,450);d.relative=Vector2(80,0);Input.parse_input_event(d);await get_tree().process_frame;assert_true(Input.is_action_pressed("move_right"));e.pressed=false;e.position=d.position;Input.parse_input_event(e);await get_tree().process_frame;assert_false(Input.is_action_pressed("move_right"))
func test_frontier_menu_and_country_saved_entry_receive_wide_touches():
 frontier=load("res://src/Presentation/frontier_world.gd").new();get_tree().root.add_child(frontier)
 while frontier._loading_world:await get_tree().process_frame
 frontier.player.set_physics_process(false);await get_tree().create_timer(1.,true).timeout;await tap(button(frontier,"Menú").get_global_rect().get_center());assert_true(is_instance_valid(frontier._navigation));await get_tree().create_timer(.2,true).timeout
 var card:Button=frontier._navigation.canvas.get_node("Navigate_country_saved152");await tap(card.get_global_rect().get_center())
 for i in 40:await get_tree().process_frame
 for child in get_tree().root.get_children():
  if child is CountrySession152:world=child
 assert_not_null(world)
 if world!=null:assert_true(world.activated)

func assert_true(value):assert(value)
func assert_false(value):assert(not value)
func assert_not_null(value):assert(value!=null)
func assert_eq(a,b):assert(a==b)
func assert_lt(a,b):assert(a<b)
func _ready():run154.call_deferred()
func run154():
 for method in ["test_wide_touches_open_map_close_and_exit_temporary_country","test_wide_touches_open_map_close_and_exit_persistent_country","test_hud_never_captures_plain_world_movement_or_aim_touch","test_frontier_menu_and_country_saved_entry_receive_wide_touches"]:
  await before_each();await call(method);await RenderingServer.frame_post_draw;get_viewport().get_texture().get_image().save_png("/downloads/touch154-"+method+".png");print("TOUCH154_PASS ",method);await after_each()
 for size_ in [Vector2i(1280,720),Vector2i(960,540)]:
  await before_each();get_tree().root.size=size_;await get_tree().process_frame;await test_wide_touches_open_map_close_and_exit_temporary_country();print("TOUCH154_SIZE_OK ",size_);await after_each()
 print("TOUCH154_ALL_OK");get_tree().quit()
