extends GutTest
var prior:String
var snapshot:Dictionary
var world:Node
func before_each():
 prior=SaveData.save_path;SaveData.save_path="user://garden212-test.cfg";snapshot=SaveData.world_garden212.duplicate(true);SaveData.world_garden212=Garden212.fresh();SaveData._load_valid=true
func after_each():
 if is_instance_valid(world):
  for map_ in [world._chunk_pending,world._chunk_built]:
   for key in map_:world._discard_builder(map_[key])
  world.free()
 SaveData.world_garden212=snapshot;SaveData.save_path=prior;DirAccess.remove_absolute("user://garden212-test.cfg")
 get_tree().paused=false
func test_cycle_discovers_property_keeps_seed_and_cannot_duplicate_sample():
 var s:=Garden212.fresh()
 s=Garden212.action(s,"introduce");s=Garden212.action(s,"accept");assert_eq(s.stage,"search")
 s=Garden212.action(s,"sample");assert_eq(s.seeds,1);assert_eq(Garden212.action(s,"sample"),{})
 s=Garden212.action(s,"plant");assert_eq(s.seeds,0);assert_false(s.discovered)
 s=Garden212.tick(s,5000.,100.);assert_eq(s.stage,"growing","care is required")
 s=Garden212.action(s,"water");s=Garden212.tick(s,899.,0.);assert_eq(s.stage,"growing")
 s=Garden212.tick(s,1.,0.);assert_eq(s.stage,"ripe")
 s=Garden212.action(s,"harvest");assert_eq(s.crops,3);assert_eq(s.seeds,1);assert_true(s.discovered)
 assert_eq(Garden212.action(s,"harvest"),{})
 s=Garden212.action(s,"feed","original");assert_eq(s.crops,2);assert_eq(Garden212.multiplier(s,"original"),.85);assert_eq(Garden212.multiplier(s,"other"),1.)
 assert_eq(Garden212.action(s,"feed","other"),{},"No stacking or replacing effect")
 s=Garden212.tick(s,0.,120.);assert_eq(s.food.left,0.);assert_eq(Garden212.multiplier(s,"original"),1.)
 s=Garden212.action(s,"plant");assert_eq(s.stage,"growing");assert_eq(s.seeds,0)
func test_sanitization_and_missing_field_are_additive():
 assert_eq(Garden212.clean(null),Garden212.fresh())
 assert_eq(Garden212.clean({"version":99}),Garden212.fresh())
 var s:=Garden212.fresh();s.distance=INF;s.food.left=NAN
 var clean:=Garden212.clean(s);assert_eq(clean.distance,0.);assert_eq(clean.food.left,0.)
func test_atomic_action_rollback_and_roundtrip():
 assert_true(SaveData.garden_action212("introduce"));assert_true(SaveData.garden_action212("accept"));assert_true(SaveData.garden_action212("sample"))
 var stored:=ConfigFile.new();assert_eq(stored.load(SaveData.save_path),OK)
 assert_eq(Garden212.clean(stored.get_value("world","garden212")),SaveData.world_garden212)
 var before:=SaveData.world_garden212.duplicate(true)
 SaveData._load_valid=false;assert_false(SaveData.garden_action212("plant"));assert_eq(SaveData.world_garden212,before);SaveData._load_valid=true
 assert_false(SaveData.garden_action212("feed","not-owned"))
func test_food_only_reduces_drain_and_never_changes_genes_or_regen():
 var base:=WorldStamina.new_state();base.value=50.
 var normal:=WorldStamina.tick(base,WorldGait.GALOPE,true,1.,false)
 var fed:=WorldStamina.tick(base,WorldGait.GALOPE,true,1.,false,.85)
 assert_almost_eq(50.-fed.value,(50.-normal.value)*.85,.0001)
 assert_eq(WorldStamina.tick(base,WorldGait.PASO,true,1.,false,.85),WorldStamina.tick(base,WorldGait.PASO,true,1.,false))
 assert_eq(WorldStamina.tick(base,WorldGait.GALOPE,true,1.,true,.85).value,50.-4.*.65*.85)
func test_florist_offers_garden_and_real_world_cycle_saves():
 var runner=get_tree().root.get_node("GutRunner")
 ignore(runner)
 SaveData.world_seed=752026;SaveData.world_generator_version=3;SaveData.world_flora138={};SaveData.world_cousins140={};SaveData.world_roaming139={};SaveData.world_places144={};SaveData.world_edits=[];SaveData.world_discovered=[];SaveData.world_missions={};SaveData.world_quests={};SaveData.country_ledger146={};SaveData.horse_collection=HorseCollection.new();SaveData.horse_collection.seed_trial()
 world=load("res://src/Presentation/frontier_world.tscn").instantiate();add_child(world)
 await wait_physics_frames(4)
 var cover=get_tree().root.get_node_or_null("FrontierTransition")
 if cover!=null:cover.free()
 world.visible=true;world.set_process(false);world.player.set_physics_process(true)
 var garden:GardenWorld212=world.garden212;garden.set_process(false)
 world.player.position=garden.home;world._open_npc(world._npcs98()[1])
 var found:Button
 for child in world._npc_dialog.get_children():
  if child is Button and child.text.begins_with("Huerto de Lucía"):found=child
 assert_not_null(found);found.pressed.emit();await wait_physics_frames(2)
 assert_true(is_instance_valid(garden.panel));assert_false(world.player.is_physics_processing())
 garden.close();world.player.position=garden.plot;garden.open();await wait_physics_frames(2)
 var accept_button:Button
 for c in garden.panel.get_children():
  if c is Button and c.text=="Aceptar el huerto":accept_button=c
 var point:Vector2=get_viewport().get_final_transform()*accept_button.get_global_rect().get_center()
 for pressed_ in [true,false]:
  var e:=InputEventScreenTouch.new();e.position=point;e.index=3;e.pressed=pressed_;Input.parse_input_event(e);Input.flush_buffered_events();await wait_physics_frames(2)
 assert_eq(SaveData.world_garden212.stage,"search");garden.close()
 world.player.position=garden.sample;garden.open();garden.act("sample");garden.close();assert_eq(SaveData.world_garden212.seeds,1)
 world.player.position=garden.plot;garden.open();garden.act("plant");garden.act("water");garden.close()
 SaveData.world_garden212=Garden212.tick(SaveData.world_garden212,900.,0.)
 garden.open();garden.act("harvest");assert_eq(SaveData.world_garden212.crops,3);garden.act("feed");assert_eq(SaveData.world_garden212.crops,2)
 assert_eq(Garden212.multiplier(SaveData.world_garden212,SaveData.horse_collection.selected),.85)
 assert_true(GameState.close_top_overlay(world));await wait_physics_frames(2);assert_true(world.player.is_physics_processing())
func ignore(node:Node):
 if node is Control:node.mouse_filter=Control.MOUSE_FILTER_IGNORE
 for child in node.get_children():ignore(child)

func test_exact_stages_refuse_out_of_order_actions():
 var s:=Garden212.fresh()
 for a in ["accept","sample","plant","water","harvest","feed"]:assert_eq(Garden212.action(s,a,"original"),{})
 s=Garden212.action(s,"introduce");assert_eq(s.stage,"intro")
 assert_eq(Garden212.action(s,"introduce"),{})
 s=Garden212.action(s,"accept");s=Garden212.action(s,"sample");s=Garden212.action(s,"plant");s=Garden212.action(s,"water")
 var before:=s.duplicate(true);s=Garden212.tick(s,0.,86400.)
 assert_eq(s.stage,"growing","No offline clock shortcut or withering")
 assert_eq(s.seeds,before.seeds)
func test_food_save_failure_never_spends_crop_or_changes_horse():
 var s:=Garden212.fresh();s.stage="empty";s.discovered=true;s.crops=3;s.seeds=1
 SaveData.world_garden212=s
 var horse:Dictionary=SaveData.horse_collection.export_state().duplicate(true)
 SaveData._load_valid=false
 assert_false(SaveData.garden_action212("feed",SaveData.horse_collection.selected));assert_eq(SaveData.world_garden212,s)
 assert_eq(SaveData.horse_collection.export_state(),horse);SaveData._load_valid=true
 assert_true(SaveData.garden_action212("feed",SaveData.horse_collection.selected));assert_eq(SaveData.horse_collection.export_state(),horse)
func test_anchors_survive_roundtrip_and_all_ten_art_crops_are_transparent():
 var s:=Garden212.fresh();s.anchors={"home":Vector2(1,2),"plot":Vector2(3,4),"sample":Vector2(5,6)}
 assert_eq(Garden212.clean(s).anchors,s.anchors)
 for path in ["carrot-0","carrot-1","carrot-2","carrot-3","carrot-4","gardener-idle","gardener-walk","gardener-water","gardener-plant","gardener-harvest"]:
  var tex:Texture2D=load("res://art/garden212/"+path+".png");var image:=tex.get_image()
  if image.is_compressed():image.decompress()
  assert_lt(image.get_pixel(0,0).a,.1,path+": transparent corner")
  assert_gt(image.get_size().x,50)

func test_live_load_preserves_crop_food_anchors_and_legacy_is_additive():
 var state:=Garden212.fresh();state.stage="empty";state.seeds=1;state.crops=2;state.discovered=true;state.food={"horse":SaveData.horse_collection.selected,"left":54.}
 state.anchors={"home":Vector2(1,2),"plot":Vector2(3,4),"sample":Vector2(5,6)}
 SaveData.world_garden212=state;assert_true(SaveData.save_progress());SaveData.world_garden212=Garden212.fresh();SaveData.load_progress()
 assert_true(SaveData._load_valid);assert_eq(SaveData.world_garden212,state)
 var c:=ConfigFile.new();assert_eq(c.load(SaveData.save_path),OK);c.erase_section_key("world","garden212");assert_eq(c.save(SaveData.save_path),OK)
 SaveData.load_progress();assert_true(SaveData._load_valid);assert_eq(SaveData.world_garden212,Garden212.fresh())
 c.set_value("world","garden212",{"version":999});assert_eq(c.save(SaveData.save_path),OK);SaveData.load_progress();assert_false(SaveData._load_valid);assert_false(SaveData.save_progress());SaveData._load_valid=true
